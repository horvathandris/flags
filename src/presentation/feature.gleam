import domain/feature
import gleam/json
import typeid

pub fn to_get_feature_response(feature: feature.Feature) -> json.Json {
  json.object([
    #("id", typeid.to_string(feature.id) |> json.string),
    #("name", json.string(feature.name)),
    #("description", json.string(feature.description)),
  ])
}
