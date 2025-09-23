import domain/feature.{Feature}
import typeid

const feature_typeid_prefix = "feature"

pub fn create_feature(name: String) {
  let assert Ok(id) = typeid.new(feature_typeid_prefix)
  Feature(id:, name:)
}
