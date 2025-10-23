import db_test_helper
import gleam/http
import gleeunit/should
import presentation/router
import wisp/simulate

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
