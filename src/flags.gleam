import context
import dot_env
import gleam/otp/static_supervisor
import infra/db

pub fn main() -> Nil {
  dot_env.load_default()

  let #(db_supervisor, connection) = db.init()
  let _ctx = context.Context(db: connection)

  let assert Ok(_actor) =
    static_supervisor.new(static_supervisor.OneForOne)
    |> static_supervisor.add(db_supervisor)
    |> static_supervisor.start

  let assert Ok(_) = db.migrate()

  // let assert Ok(feature) =
  //   feature_service.create_feature(ctx, "feature2", "description")

  // let assert Ok(feature) = feature_service.find_feature_by_id(ctx, feature.id)

  Nil
}
