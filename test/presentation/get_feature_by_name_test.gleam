import db_test_helper
import gleam/http
import gleeunit/should
import presentation/router
import wisp/simulate

pub fn should_return_404_when_feature_does_not_exist__test() {
  use ctx <- db_test_helper.with_db()

  let request = simulate.request(http.Get, "/api/v1/features?name=non-existent")

  let response = router.handle_request(request, ctx)

  response.status
  |> should.equal(404)
}
