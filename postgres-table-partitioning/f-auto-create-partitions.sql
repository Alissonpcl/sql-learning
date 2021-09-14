create function analytics.parent_table_partition() returns trigger
    language plpgsql
as $$
DECLARE
    partition_date TEXT;
    partition      TEXT;
    startMonth     DATE;
    endMonth       DATE;
BEGIN
    partition_date := to_char(NEW.created_at, 'YYYY_MM');
    partition := TG_RELNAME || '_' || partition_date;
    startMonth := date_trunc('month', NEW.created_at);
    endMonth := (date_trunc('month', NEW.created_at) + interval '1 month')::date;

    IF NOT EXISTS(SELECT relname FROM pg_class WHERE relname = partition) THEN
        RAISE NOTICE 'A partition has been created %',partition;
        -- CRIA A NOVA PARTICAO PARA A DATA DO REGISTRO
        EXECUTE 'CREATE TABLE analytics.' || partition || ' (check (created_at >= ''' || startMonth ||
                ''' and created_at < ''' || endMonth || ''')) INHERITS (analytics.' || TG_RELNAME || ');';

        -- DURANTE OS TESTES REALIZADOS FOI PERCEBIDO QUE A CRIACAO DOS INDICES ABAIXO
        -- E IMPORTANTE PARA UMA PERFORMANCE CONSISTENTE NA CONSULTA DOS REGISTROS
        EXECUTE 'CREATE INDEX ' || partition || '_id_idx ON analytics.' || partition || ' (id);';
        EXECUTE 'CREATE INDEX ' || partition || '_type_idx ON analytics.' || partition || ' (type);';
        EXECUTE 'CREATE INDEX ' || partition || '_customer_date_idx ON analytics.' || partition ||
                ' (i_customer, created_at);';

        -- CRIA UM INDICE UNICO NA TABELA PARA NAO PERMITIR VALORES DUPLICADOS.
        EXECUTE 'CREATE UNIQUE INDEX ' || partition || '_unique_idx ON analytics.' || partition ||
                ' (created_at, type, i_customer);';


    END IF;
    -- INSERE O REGISTRO NA PARTICAO CRIADO ATUALIZANDO A COLUNA CONTENT SE
    -- SE OCORRER CONFLITO NO UNIQUE INDEX
    EXECUTE 'INSERT INTO analytics.' || partition || ' SELECT(analytics.' || TG_RELNAME || ' ' || quote_literal(NEW) ||
            ').*' ||
            ' ON CONFLICT (created_at, type, i_customer) DO UPDATE SET content = excluded.content' ||
            ' RETURNING id;';
    RETURN NULL;
END;
$$;