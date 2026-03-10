create table if not exists customers
(
    customer_id   varchar not null
        primary key,
    customer_name varchar,
    segment       varchar,
    country       varchar,
    city          varchar,
    state         varchar,
    postal_code   varchar,
    region        varchar
);

create table if not exists products
(
    product_id   varchar not null
        primary key,
    category     varchar,
    sub_category varchar,
    product_name varchar
);

create table if not exists orders
(
    order_id    varchar not null
        primary key,
    order_date  date,
    ship_date   date,
    ship_mode   varchar,
    customer_id varchar
        references customers
);

create table if not exists order_details
(
    order_id   varchar not null
        references orders,
    product_id varchar not null
        references products,
    quantity   integer
        constraint order_details_quantity_check
            check (quantity > 0),
    sales      numeric
        constraint order_details_sales_check
            check (sales >= (0)::numeric),
    discount   numeric,
    profit     numeric,
    primary key (order_id, product_id)
);



