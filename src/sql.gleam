//// This module contains the code to run the sql queries defined in
//// `./src/sql`.
//// > 🐿️ This module was generated automatically using v4.4.1 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import gleam/time/timestamp.{type Timestamp}
import pog

/// A row you get from running the `create_feature` query
/// defined in `./src/sql/create_feature.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.4.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type CreateFeatureRow {
  CreateFeatureRow(
    id: String,
    name: String,
    description: String,
    created_at: Timestamp,
    updated_at: Timestamp,
  )
}

/// Runs the `create_feature` query
/// defined in `./src/sql/create_feature.sql`.
///
/// > 🐿️ This function was generated automatically using v4.4.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_feature(
  db: pog.Connection,
  arg_1: String,
  arg_2: String,
  arg_3: String,
) -> Result(pog.Returned(CreateFeatureRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.string)
    use name <- decode.field(1, decode.string)
    use description <- decode.field(2, decode.string)
    use created_at <- decode.field(3, pog.timestamp_decoder())
    use updated_at <- decode.field(4, pog.timestamp_decoder())
    decode.success(CreateFeatureRow(
      id:,
      name:,
      description:,
      created_at:,
      updated_at:,
    ))
  }

  "INSERT INTO features (id, name, description)
VALUES ($1, $2, $3)
RETURNING id, name, description, created_at, updated_at;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_feature_by_id` query
/// defined in `./src/sql/find_feature_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.4.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindFeatureByIdRow {
  FindFeatureByIdRow(
    id: String,
    name: String,
    description: String,
    created_at: Timestamp,
    updated_at: Timestamp,
  )
}

/// Runs the `find_feature_by_id` query
/// defined in `./src/sql/find_feature_by_id.sql`.
///
/// > 🐿️ This function was generated automatically using v4.4.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_feature_by_id(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(FindFeatureByIdRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.string)
    use name <- decode.field(1, decode.string)
    use description <- decode.field(2, decode.string)
    use created_at <- decode.field(3, pog.timestamp_decoder())
    use updated_at <- decode.field(4, pog.timestamp_decoder())
    decode.success(FindFeatureByIdRow(
      id:,
      name:,
      description:,
      created_at:,
      updated_at:,
    ))
  }

  "SELECT
  id,
  name,
  description,
  created_at,
  updated_at
FROM
  features
WHERE
  id = $1;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_feature_by_name` query
/// defined in `./src/sql/find_feature_by_name.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.4.1 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindFeatureByNameRow {
  FindFeatureByNameRow(
    id: String,
    name: String,
    description: String,
    created_at: Timestamp,
    updated_at: Timestamp,
  )
}

/// Runs the `find_feature_by_name` query
/// defined in `./src/sql/find_feature_by_name.sql`.
///
/// > 🐿️ This function was generated automatically using v4.4.1 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_feature_by_name(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(FindFeatureByNameRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.string)
    use name <- decode.field(1, decode.string)
    use description <- decode.field(2, decode.string)
    use created_at <- decode.field(3, pog.timestamp_decoder())
    use updated_at <- decode.field(4, pog.timestamp_decoder())
    decode.success(FindFeatureByNameRow(
      id:,
      name:,
      description:,
      created_at:,
      updated_at:,
    ))
  }

  "SELECT
  id,
  name,
  description,
  created_at,
  updated_at
FROM
  features
WHERE
  name = $1;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
