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
    simulate.request(
      http.Get,
      "/api/v1/features/" <> typeid.to_string(feature.id),
    )

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

pub fn should_return_400_when_feature_id_is_invalid__test() {
  use ctx <- db_test_helper.with_db()

  let request = simulate.request(http.Get, "/api/v1/features/some_id")

  let response = router.handle_request(request, ctx)

  response.status
  |> should.equal(400)

  response
  |> simulate.read_body
  |> should.equal("Bad request: Invalid feature ID")
}

pub fn should_return_404_when_feature_does_not_exist__test() {
  use ctx <- db_test_helper.with_db()

  let request =
    simulate.request(http.Get, "/api/v1/features/f_2x4y6z8a0b1c2d3e4f5g6h7j8k")

  let response = router.handle_request(request, ctx)

  response.status
  |> should.equal(404)
}
