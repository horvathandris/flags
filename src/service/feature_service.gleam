import context.{type Context}
import domain/feature.{type Feature}
import gleam/list
import gleam/result
import pog
import snag.{type Result}
import sql
import typeid.{type TypeId}

pub fn create_feature(
  ctx: Context,
  name: String,
  description: String,
) -> Result(Feature) {
  let query_result =
    sql.create_feature(
      ctx.db,
      feature.new_id()
        |> typeid.suffix,
      name,
      description,
    )
    |> snag.map_error(fn(_) { "failed to create feature" })
  use returned <- result.try(query_result)

  case returned {
    pog.Returned(0, _) -> snag.error("failed to create feature")
    pog.Returned(1, rows) -> {
      let assert Ok(row) = list.first(rows)
      feature.from_create_feature_row(row)
      |> snag.map_error(fn(_) { "failed to map row to feature" })
    }
    _ -> snag.error("more than one row returned")
  }
}

pub fn find_feature_by_id(ctx: Context, id: TypeId(Feature)) -> Result(Feature) {
  let query_result =
    sql.find_feature_by_id(ctx.db, typeid.suffix(id))
    |> snag.map_error(fn(_) { "failed to query feature by id" })
  use returned <- result.try(query_result)

  case returned {
    pog.Returned(0, _) -> snag.error("feature not found")
    pog.Returned(1, rows) -> {
      let assert Ok(row) = list.first(rows)
      feature.from_find_feature_by_id_row(row)
      |> snag.map_error(fn(_) { "failed to map row to feature" })
    }
    _ -> snag.error("more than one row returned")
  }
}
