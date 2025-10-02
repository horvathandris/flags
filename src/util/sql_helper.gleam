import gleam/list
import gleam/result
import pog
import snag

pub fn expect_single_row(
  query_result: Result(pog.Returned(a), pog.QueryError),
  mapper mapper: fn(a) -> Result(b, String),
) {
  use returned <- result.try(
    query_result |> snag.map_error(fn(_) { "failed to execute query" }),
  )

  case returned {
    // this shouldn't really be an error
    pog.Returned(0, _) -> snag.error("no rows returned")
    pog.Returned(1, rows) -> {
      let assert Ok(row) = list.first(rows)
      mapper(row)
      |> snag.map_error(fn(_) { "failed to map row" })
    }
    _ -> snag.error("more than one row returned")
  }
}
