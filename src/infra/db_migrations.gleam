import cigogne
import cigogne/config
import gleam/result

pub fn migrate() -> Result(Nil, cigogne.CigogneError) {
  config.default_config
  |> cigogne.create_engine
  |> result.try(cigogne.apply_all)
}
