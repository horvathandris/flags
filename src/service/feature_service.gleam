import context.{type Context}
import domain/feature.{type Feature}
import snag.{type Result}
import sql
import typeid.{type TypeId}
import util/sql_helper

pub fn create_feature(
  ctx: Context,
  name: String,
  description: String,
) -> Result(Feature) {
  sql.create_feature(
    ctx.db,
    feature.new_id()
      |> typeid.suffix,
    name,
    description,
  )
  |> sql_helper.expect_single_row(mapper: feature.from_create_feature_row)
}

pub fn find_feature_by_id(ctx: Context, id: TypeId(Feature)) -> Result(Feature) {
  sql.find_feature_by_id(ctx.db, typeid.suffix(id))
  |> sql_helper.expect_single_row(mapper: feature.from_find_feature_by_id_row)
}

pub fn find_feature_by_name(ctx: Context, name: String) -> Result(Feature) {
  sql.find_feature_by_name(ctx.db, name)
  |> sql_helper.expect_single_row(mapper: feature.from_find_feature_by_name_row)
}
