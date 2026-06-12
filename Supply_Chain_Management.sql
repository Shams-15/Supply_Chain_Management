Create table Supply_Chain(
    Type VARCHAR(50),
    days_for_shipping_real INTEGER,
    days_for_shipment_scheduled INTEGER,
    benefit_per_order NUMERIC(18,2),
    sales_per_customer NUMERIC(18,2),
    delivery_status VARCHAR(100),
    late_delivery_risk INTEGER,

    category_id INTEGER,
    category_name VARCHAR(255),

    customer_city VARCHAR(255),
    customer_country VARCHAR(255),
    customer_email VARCHAR(255),
    customer_fname VARCHAR(255),
    customer_id INTEGER,
    customer_lname VARCHAR(255),
    customer_password VARCHAR(255),
    customer_segment VARCHAR(100),
    customer_state VARCHAR(255),
    customer_street TEXT,
    customer_zipcode VARCHAR(20),

    department_id INTEGER,
    department_name VARCHAR(255),

    latitude NUMERIC(12,8),
    longitude NUMERIC(12,8),

    market VARCHAR(100),

    order_city VARCHAR(255),
    order_country VARCHAR(255),
    order_customer_id INTEGER,

    order_date  TEXT,
    order_id INTEGER,

    order_item_cardprod_id INTEGER,
    order_item_discount NUMERIC(18,2),
    order_item_discount_rate NUMERIC(10,4),
    order_item_id INTEGER,
    order_item_product_price NUMERIC(18,2),
    order_item_profit_ratio NUMERIC(18,6),
    order_item_quantity INTEGER,

    sales NUMERIC(18,2),
    order_item_total NUMERIC(18,2),
    order_profit_per_order NUMERIC(18,2),

    order_region VARCHAR(255),
    order_state VARCHAR(255),
    order_status VARCHAR(100),
    order_zipcode VARCHAR(20),

    product_card_id INTEGER,
    product_category_id INTEGER,
    product_description TEXT,
    product_image TEXT,
    product_name VARCHAR(500),
    product_price NUMERIC(18,2),
    product_status INTEGER,

    shipping_date TEXT,
    shipping_mode VARCHAR(100)
);

CREATE TABLE supply AS
SELECT
    TO_TIMESTAMP(order_date,'MM/DD/YYYY HH24:MI') AS order_date_ts,
    TO_TIMESTAMP(shipping_date,'MM/DD/YYYY HH24:MI') AS shipping_date_ts,
	*
FROM Supply_Chain;

--Executive KPI Dashboard View
CREATE OR REPLACE VIEW vw_supply_chain_kpis AS
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(order_profit_per_order) AS total_profit,
    AVG(order_profit_per_order) AS avg_profit_per_order,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_card_id) AS total_products
FROM supply;

SELECT * FROM vw_supply_chain_kpis;

-- Revenue by Month

CREATE OR REPLACE VIEW vw_monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date_ts) AS month,
    SUM(sales) AS revenue,
    SUM(order_profit_per_order) AS profit
FROM supply
GROUP BY 1
ORDER BY 1;

-- Customer Analysis

CREATE OR REPLACE VIEW vw_customer_sales AS
SELECT
    customer_id,
    customer_fname || ' ' || customer_lname AS customer_name,
    customer_segment,
    COUNT(order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(order_profit_per_order) AS total_profit
FROM supply
GROUP BY
customer_id,
customer_name,
customer_segment;

-- Top Customers

CREATE OR REPLACE VIEW vw_top_customers AS
SELECT
    customer_id,
    customer_fname || ' ' || customer_lname AS customer_name,
    SUM(sales) revenue
FROM supply
GROUP BY
customer_id,
customer_name
ORDER BY revenue DESC;

-- Product Performance
CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    product_card_id,
    product_name,
    SUM(order_item_quantity) qty_sold,
    SUM(sales) revenue,
    SUM(order_profit_per_order) profit
FROM supply
GROUP BY
product_card_id,
product_name;

-- Top Selling Products

CREATE OR REPLACE VIEW vw_top_products AS
SELECT
    product_name,
    SUM(order_item_quantity) units_sold,
    SUM(sales) revenue
FROM supply
GROUP BY product_name
ORDER BY revenue DESC;

-- Category Analysis

CREATE OR REPLACE VIEW vw_category_analysis AS
SELECT
    category_name,
    SUM(order_item_quantity) quantity,
    SUM(sales) revenue,
    SUM(order_profit_per_order) profit
FROM supply
GROUP BY category_name;

-- Department Performance

CREATE OR REPLACE VIEW vw_department_analysis AS
SELECT
    department_name,
    SUM(sales) revenue,
    SUM(order_profit_per_order) profit
FROM supply
GROUP BY department_name;

-- Shipping Performance

CREATE OR REPLACE VIEW vw_shipping_performance AS
SELECT
    shipping_mode,
    COUNT(*) total_shipments,
    AVG(
        shipping_date_ts::date -
        order_date_ts::date
    ) avg_shipping_days
FROM supply
GROUP BY shipping_mode;

-- Late Delivery Analysis

CREATE OR REPLACE VIEW vw_late_delivery AS
SELECT
    delivery_status,
    COUNT(*) orders,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) percentage
FROM supply
GROUP BY delivery_status;

-- Delivery Risk View

CREATE OR REPLACE VIEW vw_delivery_risk AS
SELECT
    late_delivery_risk,
    COUNT(*) orders
FROM supply
GROUP BY late_delivery_risk;

-- Geographic Sales Analysis

CREATE OR REPLACE VIEW vw_country_sales AS
SELECT
    order_country,
    SUM(sales) revenue,
    SUM(order_profit_per_order) profit
FROM supply
GROUP BY order_country;

-- Regional Performance

CREATE OR REPLACE VIEW vw_region_performance AS
SELECT
    order_region,
    SUM(sales) revenue,
    SUM(order_profit_per_order) profit
FROM supply
GROUP BY order_region;

-- Market Analysis

CREATE OR REPLACE VIEW vw_market_analysis AS
SELECT
    market,
    SUM(sales) revenue,
    SUM(order_profit_per_order) profit
FROM supply
GROUP BY market;

-- Profitability Analysis

CREATE OR REPLACE VIEW vw_profitability AS
SELECT
    product_name,
    SUM(order_profit_per_order) total_profit
FROM supply
GROUP BY product_name
ORDER BY total_profit DESC;

-- Loss-Making Products

CREATE OR REPLACE VIEW vw_loss_products AS
SELECT
    product_name,
    SUM(order_profit_per_order) profit
FROM supply
GROUP BY product_name
HAVING SUM(order_profit_per_order) < 0;

-- RFM Customer Segmentation

CREATE OR REPLACE VIEW vw_rfm_analysis AS
SELECT
    customer_id,
    MAX(order_date_ts) last_order,
    CURRENT_DATE - MAX(order_date_ts::date) recency,
    COUNT(order_id) frequency,
    SUM(sales) monetary
FROM supply
GROUP BY customer_id;

-- Inventory Demand Forecast Base

CREATE OR REPLACE VIEW vw_product_demand AS
SELECT
    product_name,
    DATE_TRUNC('month',order_date_ts) demand_month,
    SUM(order_item_quantity) total_demand
FROM supply
GROUP BY
product_name,
demand_month;

-- Daily Order Trend

CREATE OR REPLACE VIEW vw_daily_orders AS
SELECT
    order_date_ts::date present_order_date,
    COUNT(order_id) total_orders,
    SUM(sales) revenue
FROM supply
GROUP BY present_order_date;

-- Supply Chain Executive Dashboard

CREATE OR REPLACE VIEW vw_supply_chain_dashboard AS
SELECT
    market,
    order_region,
    COUNT(DISTINCT order_id) total_orders,
    SUM(sales) revenue,
    SUM(order_profit_per_order) profit,
    AVG(order_item_quantity) avg_quantity,
    COUNT(*) FILTER
        (WHERE late_delivery_risk = 1)
        AS late_orders
FROM supply
GROUP BY
market,
order_region;

--Top Product per Category

CREATE OR REPLACE VIEW vw_top_product_per_category AS
WITH cte AS (
SELECT
category_name,
product_name,
SUM(sales) revenue,
ROW_NUMBER() OVER(
PARTITION BY category_name
ORDER BY SUM(sales) DESC
) rn
FROM supply
GROUP BY category_name, product_name
)
SELECT *
FROM cte
WHERE rn = 1;

--Customer Churn Risk

CREATE OR REPLACE VIEW vw_customer_churn_risk AS
SELECT
customer_id,
MAX(order_date_ts) last_purchase,
CURRENT_DATE -
MAX(order_date_ts::date) days_since_purchase
FROM supply
GROUP BY customer_id
HAVING CURRENT_DATE -
MAX(order_date_ts::date) > 90;

SELECT * FROM vw_category_analysis;

SELECT * FROM vw_country_sales;

SELECT * FROM vw_customer_churn_risk;

SELECT * FROM vw_customer_sales;

SELECT * FROM vw_daily_orders;

SELECT * FROM vw_delivery_risk;

SELECT * FROM vw_department_analysis;

SELECT * FROM vw_late_delivery;

SELECT * FROM vw_loss_products;

SELECT * FROM vw_market_analysis;

SELECT * FROM vw_monthly_sales;

SELECT * FROM vw_product_demand;

SELECT * FROM vw_product_performance;

SELECT * FROM vw_profitability;

SELECT * FROM vw_region_performance;

SELECT * FROM vw_rfm_analysis;

SELECT * FROM vw_shipping_performance;

SELECT * FROM vw_supply_chain_dashboard;

SELECT * FROM vw_supply_chain_kpis;

SELECT * FROM vw_top_customers;

SELECT * FROM vw_top_products_per_category;

SELECT * FROM vw_top_products;
