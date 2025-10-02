import db_test_helper
import gleeunit/should
import service/feature_service

pub fn create_feature__test() {
  use ctx <- db_test_helper.with_db()

  // given
  let expected_name = "test_feature"
  let expected_description = "Test feature description"

  // when
  let result =
    feature_service.create_feature(ctx, expected_name, expected_description)

  // then
  let actual =
    result
    |> should.be_ok

  actual.name
  |> should.equal(expected_name)

  actual.description
  |> should.equal(expected_description)
}

pub fn find_feature_by_id__test() {
  use ctx <- db_test_helper.with_db()

  // given
  let expected_name = "test_feature"
  let expected_description = "Test feature description"
  let assert Ok(feature) =
    feature_service.create_feature(ctx, expected_name, expected_description)

  // when
  let result = feature_service.find_feature_by_id(ctx, feature.id)

  // then
  result
  |> should.be_ok
  |> should.equal(feature)
}

pub fn find_feature_by_name__test() {
  use ctx <- db_test_helper.with_db()

  // given
  let expected_name = "test_feature"
  let expected_description = "Test feature description"
  let assert Ok(feature) =
    feature_service.create_feature(ctx, expected_name, expected_description)

  // when
  let result = feature_service.find_feature_by_name(ctx, expected_name)

  // then
  result
  |> should.be_ok
  |> should.equal(feature)
}
