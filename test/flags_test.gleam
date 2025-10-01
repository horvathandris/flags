import flags
import gleeunit
import gleeunit/should

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn main__test() {
  flags.main()
  |> should.equal(Nil)
}
