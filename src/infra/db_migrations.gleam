import cigogne
import cigogne/config
import gleam/result
import snag

const app_name = "flags"

pub fn migrate() -> snag.Result(Nil) {
  use config <- result.try(
    config.get(app_name)
    |> result.replace_error(snag.new("failed to get config for " <> app_name)),
  )
  use engine <- result.try(
    cigogne.create_engine(config)
    |> result.replace_error(snag.new("failed to create engine")),
  )
  cigogne.apply_all(engine)
  |> result.replace_error(snag.new("failed to apply migrations"))
}
