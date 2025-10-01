import cigogne
import cigogne/config
import dot_env/env
import gleam/int
import gleam/option.{type Option}
import gleam/result
import snag

const app_name = "flags"

pub fn migrate() -> snag.Result(Nil) {
  let database_config =
    config.DetailedDbConfig(
      host: get_host(),
      port: get_port(),
      user: get_user(),
      password: get_password(),
      name: get_database(),
    )

  let config =
    config.Config(
      database: database_config,
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

fn get_host() -> Option(String) {
  env.get_string("POSTGRES_HOST")
  |> option.from_result
}

fn get_port() -> Option(Int) {
  env.get_string("POSTGRES_PORT")
  |> result.replace_error(Nil)
  |> result.try(int.parse)
  |> option.from_result
}

fn get_user() -> Option(String) {
  env.get_string("POSTGRES_USER")
  |> option.from_result
}

fn get_password() -> Option(String) {
  env.get_string("POSTGRES_PASSWORD")
  |> option.from_result
}

fn get_database() -> Option(String) {
  env.get_string("POSTGRES_DB")
  |> option.from_result
}
