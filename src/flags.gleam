import dot_env
import infra/db_migrations

pub fn main() -> Nil {
  dot_env.load_default()

  let assert Ok(_) = db_migrations.migrate()

  Nil
}
