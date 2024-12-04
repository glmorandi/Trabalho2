CREATE TABLE IF NOT EXISTS migrations_log (
    id SERIAL PRIMARY KEY,
    migration_version INT NOT NULL UNIQUE,
    executed_at TIMESTAMP DEFAULT NOW()
);

/* Cria tabela nova */
CREATE TABLE IF NOT EXISTS tabela_nova (
    id SERIAL PRIMARY KEY,
    migration_version INT NOT NULL UNIQUE,
    executed_at TIMESTAMP DEFAULT NOW()
);

DO $$
DECLARE
    current_version INT;
    next_version INT;
BEGIN
    SELECT COALESCE(MAX(migration_version), 0) INTO current_version FROM migrations_log;

    next_version := current_version + 1;

    INSERT INTO migrations_log (migration_version) VALUES (next_version);
END $$;
