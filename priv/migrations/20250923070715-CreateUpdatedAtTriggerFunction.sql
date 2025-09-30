--- migration:up
CREATE OR REPLACE FUNCTION update_modified_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = current_timestamp(3);
    RETURN NEW;
END;
$$ language 'plpgsql';

--- migration:down
DROP FUNCTION IF EXISTS update_modified_at_column();

--- migration:end
