import cigogne
import cigogne/config
import gleam/result
import snag

const app_name = "flags"

pub fn migrate() -> snag.Result(Nil) {
  let config =
    config.Config(
      database: config.EnvVarConfig,
      migrations: config.MigrationsConfig(
        ..config.default_migrations_config,
        application_name: app_name,
      ),
      migration_table: config.default_mig_table_config,
    )
  use engine <- result.try(
    cigogne.create_engine(config)
    |> result.replace_error(snag.new("failed to create engine")),
  )
  cigogne.apply_all(engine)
  |> result.replace_error(snag.new("failed to apply migrations"))
}
