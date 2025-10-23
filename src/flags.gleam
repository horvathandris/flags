import context
import dot_env
import gleam/erlang/process
import gleam/otp/actor
import gleam/otp/static_supervisor
import infra/db
import mist
import presentation/router
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  start()
  process.sleep_forever()
}

pub fn start() -> actor.Started(static_supervisor.Supervisor) {
  dot_env.load_default()
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)

  let #(db_supervisor, connection) = db.init()
  let ctx = context.Context(db: connection)

  let assert Ok(_) = db.migrate()

  let server_supervisor =
    router.handle_request(_, ctx)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(8080)
    |> mist.supervised

  let assert Ok(actor) =
    static_supervisor.new(static_supervisor.OneForOne)
    |> static_supervisor.add(db_supervisor)
    |> static_supervisor.add(server_supervisor)
    |> static_supervisor.start

  actor
}
