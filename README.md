# Chocolate Sales Analysis and Profit Prediction

## Project Overview

This project presents an end-to-end analysis of chocolate sales data using
SQL, Python, Power BI and Machine Learning.

The objective is to analyze sales, revenue and profit performance, identify
important business trends, build an interactive Power BI dashboard, and
predict profit using a Random Forest regression model.

## Tools and Technologies

- Python
- Pandas
- NumPy
- Matplotlib
- Scikit-learn
- PostgreSQL
- Power BI
- Jupyter Notebook

## Project Workflow

Raw Data
   ↓
Data Cleaning & EDA
   ↓
SQL Analysis
   ↓
Power BI Dashboard
   ↓
Machine Learning
   ↓
Profit Prediction

## 1. Data Cleaning and EDA

Python was used for data exploration and preparation.

The analysis included:

- Checking data types
- Checking missing values
- Checking duplicate records
- Descriptive statistics
- Sales and profit analysis
- Brand analysis
- Category analysis
- Store-type analysis
- City and country analysis
- Monthly and yearly trends
- Customer analysis

## 2. SQL Analysis

PostgreSQL was used to perform business-oriented analysis.

SQL techniques used include:

- SELECT and filtering
- JOINs
- GROUP BY
- Aggregate functions
- CASE WHEN
- Subqueries
- CTEs
- Window functions
- LAG()
- RANK()
- Monthly revenue growth
- Profit margin analysis

## 3. Power BI Dashboard

An interactive Power BI dashboard was created to analyze:

- Total Revenue
- Total Profit
- Quantity Sold
- Profit Margin
- Monthly sales trends
- Brand performance
- Category performance
- Store performance
- Geographic performance

The dashboard helps convert the SQL and Python analysis into
business-friendly visual insights.

## 4. Machine Learning

A Random Forest Regression model was developed to predict profit.

### Features

- Brand
- Category
- City
- Store Type
- Month
- Day of Week
- Loyalty Member

### Target

- Profit

Categorical variables were encoded before training the model.

The model was evaluated using appropriate regression metrics such as
MAE, RMSE and R².

A separate time-based approach was also considered by using 2023 data
for training and 2024 data for prediction.

## Key Business Objectives

The project aims to answer questions such as:

- Which brands and categories perform best?
- Which stores and locations generate the most revenue?
- How does profit change over time?
- Which customer and store characteristics are associated with higher profit?
- Can profit be predicted using available sales and customer features?

## Dataset

The raw datasets are not included in this repository due to their large
file size.

To run the notebooks locally, place the required CSV files inside the
`data/` directory.

The notebooks use relative paths and therefore do not depend on
machine-specific file locations.

## Repository Structure

```text
Sales_Analysis_and_Prediction/
│
├── data/
│   └── Dataset files (not included in GitHub)
│
├── notebooks/
│   ├── chocolate_sales_eda.ipynb
│   └── ch_sales_prediction.ipynb
│
├── sql/
│   └── chocolate_sales.sql
│
├── dashboard/
│   └── Chocolate Sales.pdf
│
├── README.md
├── requirements.txt
└── .gitignore
