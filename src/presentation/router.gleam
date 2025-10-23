import context
import given
import gleam/http
import gleam/http/response
import gleam/json
import presentation/dto
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
    http.Get, ["api", "v1", "features"], [#("name", feature_name), ..] ->
      get_feature_by_name(context, feature_name)
    _, _, _ -> wisp.not_found()
  }
}

fn get_feature_by_id(
  context: context.Context,
  feature_id: String,
) -> response.Response(wisp.Body) {
  use feature_id <- given.ok(typeid.parse(feature_id), else_return: fn(_) {
    wisp.bad_request("Invalid feature ID")
  })

  use feature <- given.ok(
    feature_service.find_feature_by_id(context, feature_id),
    else_return: fn(_) { wisp.not_found() },
  )

  dto.to_get_feature_response(feature)
  |> json.to_string
  |> wisp.json_response(200)
}

fn get_feature_by_name(
  context: context.Context,
  feature_name: String,
) -> response.Response(wisp.Body) {
  use feature <- given.ok(
    feature_service.find_feature_by_name(context, feature_name),
    else_return: fn(_) { wisp.not_found() },
  )

  dto.to_get_feature_response(feature)
  |> json.to_string
  |> wisp.json_response(200)
}
