SELECT
  id,
  name,
  description,
  created_at,
  updated_at
FROM
  features
WHERE
  name = $1;
