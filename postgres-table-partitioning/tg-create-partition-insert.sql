create trigger tg-create-partition-insert
    before insert
    on analytics.crescimento_base
    for each row
execute procedure analytics.parent_table_partition();

