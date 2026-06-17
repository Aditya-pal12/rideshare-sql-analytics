# 🚗 Ride-Sharing Analytics Platform — MySQL

Advanced SQL portfolio project simulating an Ola/Uber-style 
ride-sharing platform.

## 📊 Database Schema
- 6 tables: users, vehicles, rides, payments, ratings, promotions
- Proper foreign keys and constraints

## 🔍 Queries Covered
| # | Query | Concept |
|---|-------|---------|
| Q1 | Top Drivers by Revenue | JOINs + GROUP BY |
| Q2 | Surge Pricing Analysis | Window Functions (RANK, AVG OVER) |
| Q3 | Rider Retention Segments | CTE Chaining |
| Q4 | Running Revenue Total | Cumulative + Rolling Avg |
| Q5 | Driver Performance Scorecard | Multi-CTE + CASE WHEN |
| Q6 | Payment Method Pivot | Conditional Aggregation |
| Q7 | Peak Hour Analysis | HOUR() + Time Bucketing |
| Q8 | Churn Detection | DATEDIFF + Risk Scoring |
| Q9 | Indexing Strategy | Composite Indexes |
| Q10 | Dynamic Fare Calculator | Stored Procedure |

## 🛠️ Tech Stack
- MySQL 8.0+
- Concepts: CTEs, Window Functions, Stored Procedures, 
  Indexing, Views

## 📁 Files
- `ola_uber_sql_project.sql` — Full schema + data + queries

## 🚀 How to Run
1. Open MySQL Workbench or any MySQL client
2. Run `ola_uber_sql_project.sql`
3. Execute individual queries to see results
