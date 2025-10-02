import gleam/result
import gleam/time/timestamp.{type Timestamp}
import sql.{type CreateFeatureRow, type FindFeatureByIdRow}
import typeid.{type TypeId}

const feature_typeid_prefix = "feature"

pub type Feature {
  Feature(
    id: TypeId(Feature),
    name: String,
    description: String,
    created_at: Timestamp,
    updated_at: Timestamp,
  )
}

pub fn new_id() -> TypeId(Feature) {
  let assert Ok(id) = typeid.new(feature_typeid_prefix)
  id
}

pub fn from_create_feature_row(
  row row: CreateFeatureRow,
) -> Result(Feature, String) {
  use id <- result.map(typeid.parse(feature_typeid_prefix <> "_" <> row.id))

  Feature(
    id: id,
    name: row.name,
    description: row.description,
    created_at: row.created_at,
    updated_at: row.updated_at,
  )
}

pub fn from_find_feature_by_id_row(
  row row: FindFeatureByIdRow,
) -> Result(Feature, String) {
  use id <- result.map(typeid.parse(feature_typeid_prefix <> "_" <> row.id))

  Feature(
    id: id,
    name: row.name,
    description: row.description,
    created_at: row.created_at,
    updated_at: row.updated_at,
  )
}
