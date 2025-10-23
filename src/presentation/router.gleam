import context
import gleam/http
import gleam/http/response
import gleam/json
import gleam/result
import presentation/feature
import presentation/middleware
import service/feature_service
import typeid
import wisp

pub fn handle_request(
  req: wisp.Request,
  context: context.Context,
) -> response.Response(wisp.Body) {
  use req <- middleware.middleware(req)

  case req.method, wisp.path_segments(req), wisp.get_query(req) {
    http.Get, ["api", "v1", "features", feature_id], _ ->
      get_feature_by_id(context, feature_id)
    http.Get, ["api", "v1", "features"], [#("name", feature_name)] ->
      get_feature_by_name(context, feature_name)
    _, _, _ -> wisp.not_found()
  }
}

fn get_feature_by_id(
  context: context.Context,
  feature_id: String,
) -> response.Response(wisp.Body) {
  typeid.parse(feature_id)
  |> result.replace_error(wisp.bad_request("Invalid feature ID"))
  |> result.try(fn(feature_id) {
    feature_service.find_feature_by_id(context, feature_id)
    |> result.replace_error(wisp.not_found())
    |> result.map(feature.to_get_feature_response)
    |> result.map(fn(json) { wisp.json_response(json.to_string(json), 200) })
  })
  |> result.unwrap_both
}

fn get_feature_by_name(
  context: context.Context,
  feature_name: String,
) -> response.Response(wisp.Body) {
  feature_service.find_feature_by_name(context, feature_name)
  |> result.replace_error(wisp.not_found())
  |> result.map(feature.to_get_feature_response)
  |> result.map(fn(json) { wisp.json_response(json.to_string(json), 200) })
  |> result.unwrap_both
}
