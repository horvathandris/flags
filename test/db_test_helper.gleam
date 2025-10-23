import context
import dot_env
import gleam/erlang/process
import gleam/otp/actor
import gleam/otp/static_supervisor
import infra/db
import pog

// TODO: i wonder if there's a way to reuse the connection for multiple tests
pub fn with_db(test_fn: fn(context.Context) -> Nil) {
  let #(context, actor) = setup()
  test_fn(context)
  teardown(context, actor)
}

fn setup() -> #(context.Context, actor.Started(static_supervisor.Supervisor)) {
  dot_env.load_default()

  let #(spec, conn) = db.init()

  let assert Ok(_) = db.migrate()

  let assert Ok(actor) =
    static_supervisor.new(static_supervisor.OneForOne)
    |> static_supervisor.add(spec)
    |> static_supervisor.start

  #(context.Context(db: conn), actor)
}

fn teardown(
  context: context.Context,
  actor: actor.Started(static_supervisor.Supervisor),
) -> Nil {
  let assert Ok(_) = truncate_table(context.db, "features")

  process.send_exit(actor.pid)
}

fn truncate_table(
  connection: pog.Connection,
  table_name: String,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  pog.query("TRUNCATE TABLE " <> table_name)
  |> pog.execute(connection)
}
