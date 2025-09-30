--- migration:up
CREATE TABLE IF NOT EXISTS features (
  id          VARCHAR(26)              NOT NULL PRIMARY KEY,
  name        TEXT                     NOT NULL,
  description TEXT                     NOT NULL,
  created_at  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER update_feature_modtime
AFTER UPDATE ON features
FOR EACH ROW
EXECUTE FUNCTION update_modified_at_column();

--- migration:down
DROP TABLE IF EXISTS features;

--- migration:end
