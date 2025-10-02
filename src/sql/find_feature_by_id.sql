SELECT
  id,
  name,
  description,
  created_at,
  updated_at
FROM
  features
WHERE
  id = $1;
