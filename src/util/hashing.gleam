import mumu

const percentage_seed = 73_254_914

/// Takes the identifier and a group ID, and normalizes the
/// hash value to a percentage value between 1 and 100.
pub fn normalize_to_percentage(id: String, group_id: String) -> Int {
  normalize_hash(id <> ":" <> group_id, 100, percentage_seed)
}

const variant_seed = 214_983

/// Takes the identifier and a group ID, and normalizes the
/// hash value to a variant value between 1 and the given count.
pub fn normalize_to_variant(
  id: String,
  group_id: String,
  variant_count: Int,
) -> Int {
  normalize_hash(id <> ":" <> group_id, variant_count, variant_seed)
}

fn normalize_hash(input: String, normalizer: Int, seed: Int) -> Int {
  mumu.hash_with_seed(input, seed) % normalizer + 1
}
