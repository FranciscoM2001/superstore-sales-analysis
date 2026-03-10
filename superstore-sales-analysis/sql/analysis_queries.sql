SELECT COUNT(*)
FROM order_details
WHERE profit < 0;

SELECT COUNT(*)
FROM order_details
WHERE sales = 0;

SELECT
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_percent
FROM order_details;

SELECT
    c.region,
    SUM(od.sales) AS revenue,
    SUM(od.profit) AS profit,
    ROUND(SUM(od.profit)/SUM(od.sales)*100,2) AS margin
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY margin DESC;

SELECT
    p.category,
    p.sub_category,
    SUM(od.sales) AS revenue,
    SUM(od.profit) AS profit,
    ROUND(SUM(od.profit)/SUM(od.sales)*100,2) AS margin
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category, p.sub_category
ORDER BY margin ASC;

SELECT
    c.segment,
    SUM(od.sales) AS revenue,
    SUM(od.profit) AS profit,
    ROUND(SUM(od.profit)/SUM(od.sales)*100,2) AS margin
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY margin DESC;

SELECT
    c.segment,
    SUM(od.sales) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(od.sales)/COUNT(DISTINCT o.order_id),2) AS avg_order_value
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.segment;

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount BETWEEN 0.01 AND 0.10 THEN 'Low'
        WHEN discount BETWEEN 0.11 AND 0.30 THEN 'Medium'
        ELSE 'High'
    END AS discount_bucket,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin
FROM order_details
GROUP BY discount_bucket
ORDER BY margin;

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(od.sales) AS revenue
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month),0) * 100,
    2) AS growth_percent
FROM monthly
ORDER BY month;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(od.sales) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC
LIMIT 10;

SELECT
    p.product_name,
    SUM(od.profit) AS total_profit
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit ASC
LIMIT 10;