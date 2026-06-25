# # Retail Promotions Analytics | SQL & Power BI

## Project Overview

This project analyzes the effectiveness of retail promotional campaigns using SQL and Power BI. The objective is to evaluate how different promotion types impact revenue, sales volume, product performance, and store performance, enabling data-driven business decisions.

The analysis focuses on measuring key promotional metrics such as Incremental Revenue (IR), Incremental Sold Units (ISU), campaign effectiveness, product category performance, and store-level insights.

---

## Business Problem

Retail businesses frequently launch promotional campaigns to increase sales and customer engagement. However, not all promotions generate the same impact.

This project aims to answer:

* Which promotional campaigns generated the highest revenue?
* Which products benefited the most from promotions?
* Which stores performed best during promotional periods?
* Which promotion types delivered the highest return?
* How much incremental revenue and sales volume were generated?

---

## Dataset Information

The project utilizes four primary tables:

### Fact Table

**fact_events**

* Product Code
* Store ID
* Campaign ID
* Base Price
* Promo Type
* Quantity Sold Before Promotion
* Quantity Sold After Promotion

### Dimension Tables

#### dim_products

* Product Code
* Product Name
* Category

#### dim_stores

* Store ID
* City

#### dim_campaigns

* Campaign ID
* Campaign Name

---

## Tools & Technologies

* SQL (MySQL)
* Power BI
* DAX
* Data Modeling
* Data Visualization
* Business Intelligence

---

## Key Performance Indicators (KPIs)

### Revenue Metrics

* Total Revenue Before Promotion
* Total Revenue After Promotion
* Incremental Revenue (IR)
* Incremental Revenue Percentage (IR%)

### Sales Metrics

* Total Units Sold Before Promotion
* Total Units Sold After Promotion
* Incremental Sold Units (ISU)
* Incremental Sold Units Percentage (ISU%)

### Campaign Metrics

* Campaign Performance
* Promotion Type Effectiveness
* Category-wise Growth
* Store-wise Performance

---

## SQL Analysis Performed

### Ad-Hoc Business Requests

#### 1. High-Value BOGOF Products

Identified products with a base price greater than ₹500 running under BOGOF promotions.

#### 2. Store Count by City

Calculated the number of stores operating in each city.

#### 3. Campaign Revenue Performance

Compared total revenue before and after promotions for each campaign.

#### 4. Diwali Campaign Category Ranking

Ranked categories based on Incremental Sold Units Percentage (ISU%).

#### 5. Top 5 Products by Incremental Revenue Percentage

Identified products generating the highest revenue uplift during promotions.

---

### Store Performance Analysis

#### Top Stores by Incremental Revenue

Determined stores contributing the highest additional revenue.

#### Bottom Stores by Incremental Sold Units

Identified stores with the lowest promotional impact.

---

### Promotion Type Analysis

#### Top Promotion Types by Revenue

Evaluated which promotional strategies generated maximum revenue uplift.

#### Bottom Promotion Types by ISU

Analyzed promotions with the least impact on sales volume.

---

### Product & Category Analysis

#### Category Sales Lift

Measured sales growth across product categories.

#### Best Performing Products

Identified products responding exceptionally well to promotions.

#### Poor Performing Products

Detected products showing minimal promotional impact.

---

## Power BI Dashboard Features

### Executive Dashboard

* Total Revenue
* Total Orders
* Incremental Revenue
* Incremental Units Sold
* Campaign Performance Overview

### Campaign Analysis Dashboard

* Revenue Before vs After Promotion
* Campaign Comparison
* Promotion Effectiveness

### Product Analysis Dashboard

* Top Products by Revenue
* Category Performance
* Product Growth Analysis

### Store Analysis Dashboard

* Top & Bottom Performing Stores
* City-wise Store Distribution
* Store Revenue Contribution

### Promotion Insights Dashboard

* Promotion Type Comparison
* Incremental Revenue by Promotion
* Incremental Sold Units by Promotion

---

## DAX Measures

### Total Revenue

```DAX
Total Revenue =
SUMX(
    fact_events,
    fact_events[Base Price] * fact_events[Quantity Sold After Promo]
)
```

### Total Revenue Before Promotion

```DAX
Revenue Before Promo =
SUMX(
    fact_events,
    fact_events[Base Price] * fact_events[Quantity Sold Before Promo]
)
```

### Incremental Revenue

```DAX
Incremental Revenue =
[Total Revenue] - [Revenue Before Promo]
```

### Total Orders

```DAX
Total Orders =
SUM(fact_events[Quantity Sold After Promo])
```

### Incremental Sold Units

```DAX
ISU =
SUM(fact_events[Quantity Sold After Promo])
-
SUM(fact_events[Quantity Sold Before Promo])
```

---

## Business Insights

* Promotional campaigns significantly increased revenue and sales volume.
* Certain product categories responded more positively than others.
* BOGOF and discount-based promotions generated strong customer engagement.
* Store-level analysis highlighted top-performing locations for future campaign investments.
* Incremental Revenue and ISU metrics provided clear measurement of promotion effectiveness.

---

## Project Outcomes

✔ Improved understanding of promotional performance

✔ Identified high-performing products and categories

✔ Measured campaign ROI using revenue uplift metrics

✔ Enabled data-driven promotional planning

✔ Delivered interactive business intelligence dashboards

---

## Repository Structure

```text
Retail-Promotions-Analytics/
│
├── Retail.pbix
├── retails.sql.sql
├── Dataset/
├── Dashboard Screenshots/
├── README.md
└── Documentation/
```

---

**Vikash Kr Madheshiya**

Data Analyst | SQL | Power BI | Excel | Python

