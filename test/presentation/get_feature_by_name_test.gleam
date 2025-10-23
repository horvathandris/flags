import db_test_helper
import gleam/http
import gleeunit/should
import must
import presentation/router
import service/feature_service
import simplejson
import typeid
import wisp/simulate

pub fn should_return_200_when_feature_exists__test() {
  use ctx <- db_test_helper.with_db()

  // given
  let assert Ok(feature) =
    feature_service.create_feature(ctx, "test-feature", "A test feature.")
  let request =
    simulate.request(http.Get, "/api/v1/features?name=" <> feature.name)

  // when
  let response = router.handle_request(request, ctx)

  // then
  response.status
  |> should.equal(200)

  let assert Ok(response_body) =
    simulate.read_body(response)
    |> simplejson.parse

  simplejson.jsonpath(response_body, "id")
  |> must.exist
  |> must.be_json_string
  |> should.equal(typeid.to_string(feature.id))

  simplejson.jsonpath(response_body, "name")
  |> must.exist
  |> must.be_json_string
  |> should.equal("test-feature")

  simplejson.jsonpath(response_body, "description")
  |> must.exist
  |> must.be_json_string
  |> should.equal("A test feature.")
}

pub fn should_return_404_when_feature_does_not_exist__test() {
  use ctx <- db_test_helper.with_db()

  let request = simulate.request(http.Get, "/api/v1/features?name=non-existent")

  let response = router.handle_request(request, ctx)

  response.status
  |> should.equal(404)
}
