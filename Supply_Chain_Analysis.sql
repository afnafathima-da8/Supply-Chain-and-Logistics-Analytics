CREATE TABLE supply_chain (
    order_id BIGINT,
    order_date TIMESTAMP,
    shipping_date TIMESTAMP,
    shipping_mode VARCHAR(100),
    delivery_status VARCHAR(100),
    delivery_delay_days INTEGER,
    delivery_performance VARCHAR(50),
    order_region VARCHAR(150),
    order_country VARCHAR(150),
    customer_segment VARCHAR(100),
    product_name TEXT,
    sales NUMERIC(15,2),
    order_quantity INTEGER,
    shipping_duration INTEGER,
    scheduled_shipping_days INTEGER,
    order_month_year VARCHAR(20)
);
--Check total records
SELECT COUNT(*)
FROM supply_chain;
--Display first 10 records
SELECT *
FROM supply_chain
LIMIT 10;
--Check column names and data types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'supply_chain';
--Total Number of Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM supply_chain;
--Total Sales
SELECT ROUND(SUM(sales), 2) AS total_sales
FROM supply_chain;
--Overall Delivery Performance
SELECT
    delivery_performance,
    COUNT(*) AS total_deliveries
FROM supply_chain
GROUP BY delivery_performance;
--Delivery Performance Percentage
SELECT
    delivery_performance,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM supply_chain
GROUP BY delivery_performance;
--Average Delivery Delay
SELECT
    ROUND(AVG(delivery_delay_days), 2) AS average_delivery_delay
FROM supply_chain;

--Which Shipping Mode Has the Highest Delivery Delays?
SELECT
    shipping_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(delivery_delay_days), 2) AS avg_delay_days
FROM supply_chain
GROUP BY shipping_mode
ORDER BY avg_delay_days DESC;
--Which Regions Have the Most Delayed Deliveries?
SELECT
    order_region,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN delivery_performance = 'Late'
        THEN order_id
    END) AS late_orders
FROM supply_chain
GROUP BY order_region
ORDER BY late_orders DESC;

--Average Shipping Duration by Shipping Mode
SELECT
    shipping_mode,
    ROUND(AVG(shipping_duration), 2) AS avg_shipping_days,
    ROUND(AVG(scheduled_shipping_days), 2) AS avg_scheduled_days
FROM supply_chain
GROUP BY shipping_mode
ORDER BY avg_shipping_days DESC;

--Which Countries Have the Highest Order Volume?
SELECT
    order_country,
    COUNT(DISTINCT order_id) AS total_orders
FROM supply_chain
GROUP BY order_country
ORDER BY total_orders DESC
LIMIT 10;

--Which Products Have the Highest Demand?
SELECT
    product_name,
    SUM(order_quantity) AS total_quantity
FROM supply_chain
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 10;


SELECT
    order_month_year,
    COUNT(DISTINCT order_id) AS total_orders
FROM supply_chain
GROUP BY order_month_year
ORDER BY order_month_year;

SELECT
    customer_segment,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales
FROM supply_chain
GROUP BY customer_segment
ORDER BY total_sales DESC;