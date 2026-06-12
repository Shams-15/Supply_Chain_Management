# 🚚 Supply Chain Analytics using PostgreSQL

## 📌 Project Overview

This project analyzes a global Supply Chain dataset using PostgreSQL to uncover insights related to sales performance, profitability, customer behavior, product demand, shipping efficiency, and operational risks.

The project demonstrates the use of SQL for data transformation, aggregation, business analysis, and dashboard-ready reporting through reusable analytical views.

---

## 🎯 Objectives

- Analyze sales and profitability trends.
- Identify top-performing customers and products.
- Evaluate category and department performance.
- Monitor shipping efficiency and delivery risks.
- Perform customer segmentation using RFM analysis.
- Detect potential customer churn.
- Create dashboard-ready views for business reporting.

---

## 🛠️ Technologies Used

- PostgreSQL

---

## 📂 Dataset Information

The dataset contains information related to:

- Customers
- Products
- Orders
- Sales
- Profitability
- Shipping & Delivery
- Geographic Markets

### Key Attributes

| Category | Columns |
|-----------|----------|
| Customer | customer_id, customer_segment, customer_country |
| Product | product_name, category_name, department_name |
| Sales | sales, order_profit_per_order |
| Shipping | shipping_mode, delivery_status |
| Geography | market, order_country, order_region |
| Orders | order_id, order_date |

---

## 🔄 Data Preparation

Converted text-based date columns into PostgreSQL timestamp format for time-series analysis.

```sql
CREATE TABLE supply AS
SELECT
    TO_TIMESTAMP(order_date,'MM/DD/YYYY HH24:MI') AS order_date_ts,
    TO_TIMESTAMP(shipping_date,'MM/DD/YYYY HH24:MI') AS shipping_date_ts,
    *
FROM Supply_Chain;
```

---

## 📊 SQL Concepts Applied

- Aggregate Functions (`SUM`, `AVG`, `COUNT`, `MAX`)
- Window Functions (`ROW_NUMBER`)
- Common Table Expressions (CTEs)
- Conditional Aggregation (`FILTER`)
- Date Functions (`DATE_TRUNC`, `CURRENT_DATE`)
- Views
- Grouping & Sorting
- Business KPI Calculations

---

## 📈 Analytical Views Created

| View Name | Purpose |
|------------|----------|
| vw_supply_chain_kpis | Executive KPI Dashboard |
| vw_monthly_sales | Monthly Revenue & Profit Trends |
| vw_customer_sales | Customer Performance Analysis |
| vw_top_customers | Highest Revenue Customers |
| vw_product_performance | Product-Level Performance |
| vw_top_products | Best Selling Products |
| vw_category_analysis | Category Performance |
| vw_department_analysis | Department Performance |
| vw_shipping_performance | Shipping Efficiency |
| vw_late_delivery | Late Delivery Analysis |
| vw_delivery_risk | Delivery Risk Monitoring |
| vw_country_sales | Country-Level Sales |
| vw_region_performance | Regional Performance |
| vw_market_analysis | Market Performance |
| vw_profitability | Product Profitability |
| vw_loss_products | Loss-Making Products |
| vw_rfm_analysis | Customer Segmentation |
| vw_product_demand | Demand Analysis |
| vw_daily_orders | Daily Order Trends |
| vw_supply_chain_dashboard | Executive Dashboard |
| vw_top_product_per_category | Top Product by Category |
| vw_customer_churn_risk | Churn Risk Detection |

---

## 📌 Key Business Insights

- Identified top-performing customers and products.
- Tracked monthly revenue and profit trends.
- Evaluated regional and market performance.
- Measured shipping efficiency and delivery delays.
- Detected products generating losses.
- Segmented customers using RFM metrics.
- Identified customers at risk of churn.
- Built dashboard-ready reporting structures.

---

## 📊 Potential Dashboard Metrics

- Total Sales
- Total Profit
- Total Orders
- Top Customers
- Top Products
- Monthly Revenue Trends
- Regional Sales Performance
- Shipping Performance
- Delivery Risk Analysis
- Customer Churn Monitoring

---

## 🚀 Future Enhancements

- Demand Forecasting using Machine Learning
- Customer Lifetime Value (CLV) Analysis
- Inventory Optimization
- Delivery Delay Prediction Models
- Automated ETL Pipelines
- Interactive Power BI Dashboard

---

## 🏆 Project Outcome

Developed an end-to-end Supply Chain Analytics solution using PostgreSQL by transforming raw transactional data into actionable business insights.

The project demonstrates:

- Advanced SQL Querying
- Data Aggregation & Reporting
- Window Functions
- KPI Development
- Customer Analytics
- Supply Chain Performance Analysis
- Business Intelligence Readiness
