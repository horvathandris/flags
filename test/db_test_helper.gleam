import context
import dot_env
import gleam/otp/static_supervisor
import infra/db
import pog

// TODO: i wonder if there's a way to reuse the connection for multiple tests
pub fn with_db(test_fn: fn(context.Context) -> Nil) {
  let context = setup()
  test_fn(context)
  teardown(context)
}

pub fn setup() -> context.Context {
  dot_env.load_default()

  let #(spec, conn) = db.init()

  let assert Ok(_actor) =
    static_supervisor.new(static_supervisor.OneForOne)
    |> static_supervisor.add(spec)
    |> static_supervisor.start

  let assert Ok(_) = db.migrate()

  context.Context(db: conn)
}

pub fn teardown(context: context.Context) {
  let assert Ok(_) = truncate_table(context.db, "features")
}

fn truncate_table(
  connection: pog.Connection,
  table_name: String,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  pog.query("TRUNCATE TABLE " <> table_name)
  |> pog.execute(connection)
}
