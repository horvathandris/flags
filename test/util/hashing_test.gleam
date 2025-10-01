import gleeunit/should
import util/hashing

pub fn normalize_to_percentage__test() {
  hashing.normalize_to_percentage("123", "gr1")
  |> should.equal(9)

  hashing.normalize_to_percentage("999", "groupX")
  |> should.equal(22)
}

pub fn normalize_to_variant__test() {
  hashing.normalize_to_variant("123", "gr1", 3)
  |> should.equal(3)

  hashing.normalize_to_variant("999", "groupX", 2)
  |> should.equal(2)
}
