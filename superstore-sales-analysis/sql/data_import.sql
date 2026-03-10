INSERT INTO customers
SELECT DISTINCT
    "Customer ID",
    "Customer Name",
    segment,
    country,
    city,
    state,
    "Postal Code",
    region
FROM raw_superstore
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO products
SELECT DISTINCT
    "Product ID",
    category,
    "Sub-Category",
    "Product Name"
FROM raw_superstore
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO orders
SELECT DISTINCT
    "Order ID",
    TO_DATE("Order Date", 'MM/DD/YYYY'),
    TO_DATE("Ship Date", 'MM/DD/YYYY'),
    "Ship Mode",
    "Customer ID"
FROM raw_superstore;

INSERT INTO order_details (order_id, product_id, quantity, sales, discount, profit)
SELECT
    "Order ID",
    "Product ID",
    quantity::integer,
    sales::numeric,
    discount::numeric,
    profit::numeric
FROM raw_superstore
ON CONFLICT (order_id, product_id) DO NOTHING;