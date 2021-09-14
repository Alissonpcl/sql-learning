create table analytics.parent_table
(
    id         serial       not null
        constraint crescimento_base_pk
            primary key,
    created_at date         not null,
    type       varchar(255) not null,
    i_customer  integer,
    content    jsonb
);