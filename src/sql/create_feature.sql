INSERT INTO features (id, name, description)
VALUES ($1, $2, $3)
RETURNING id, name, description, created_at, updated_at;
