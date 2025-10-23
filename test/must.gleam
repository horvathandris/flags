import gleam/string
import simplejson/jsonvalue

pub fn exist(
  res: Result(jsonvalue.JsonValue, jsonvalue.JsonPathError),
) -> jsonvalue.JsonValue {
  case res {
    Ok(value) -> value
    Error(_) -> panic as "value at path does not exist"
  }
}

pub fn be_json_string(value: jsonvalue.JsonValue) -> String {
  case value {
    jsonvalue.JsonString(str:) -> str
    _ -> panic as { string.inspect(value) <> "\nshould be a string" }
  }
}
