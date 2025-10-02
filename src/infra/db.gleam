import cigogne
import cigogne/config
import dot_env/env
import gleam/erlang/process
import gleam/int
import gleam/option.{type Option}
import gleam/otp/supervision
import gleam/result
import pog
import snag

const app_name = "flags"

pub fn init() -> #(
  supervision.ChildSpecification(pog.Connection),
  pog.Connection,
) {
  let pool_name = process.new_name("pog")

  let child_spec =
    pog.default_config(pool_name)
    |> pog.host(get_host() |> option.unwrap("localhost"))
    |> pog.database(get_database() |> option.unwrap("flags"))
    |> pog.user(get_user() |> option.unwrap("flags_user"))
    |> pog.password(get_password())
    |> pog.pool_size(15)
    |> pog.supervised

  let connection = pog.named_connection(pool_name)

  #(child_spec, connection)
}

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
  env.get_string("PGHOST")
  |> option.from_result
}

fn get_port() -> Option(Int) {
  env.get_string("PGPORT")
  |> result.replace_error(Nil)
  |> result.try(int.parse)
  |> option.from_result
}

fn get_user() -> Option(String) {
  env.get_string("PGUSER")
  |> option.from_result
}

fn get_password() -> Option(String) {
  env.get_string("PGPASSWORD")
  |> option.from_result
}

fn get_database() -> Option(String) {
  env.get_string("PGDATABASE")
  |> option.from_result
}
