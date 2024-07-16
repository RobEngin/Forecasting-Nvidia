# NVIDIA Revenue Forecasting Project

## Overview

This project focuses on forecasting NVIDIA's revenue using various time series analysis and machine learning techniques. We aimed to predict future revenue trends and identify the best predictors for NVIDIA's financial performance.

## Goals

1. Forecast NVIDIA's revenue
2. Discover the best predictors for revenue
3. Compare different forecasting models

## Data Sources

- Statista
- Yahoo Finance
- Y-Charts (scraped using GPT-4)

## Data Preprocessing

We collected and preprocessed data from 1997 to 2024, including:

- Revenue (quarterly)
- Number of employees (yearly, converted to quarterly)
- R&D spending (yearly, converted to quarterly)
- Stock price (daily, converted to quarterly average)
- Net income (quarterly)

Preprocessing steps included:
- Using spline interpolation to convert yearly data to quarterly
- Averaging daily stock prices to quarterly values
- Aligning all time series to a common quarterly timeline

## Exploratory Data Analysis (EDA)

We performed EDA to understand the relationships between different variables:

- Revenue vs. Net Income
- Revenue vs. Stock Price
- Revenue vs. Number of Employees
- Revenue vs. R&D Spending

We also created correlation matrices for both raw and differenced data to identify potential predictors.

## Models Implemented

1. TSLM (Time Series Linear Model)
2. LASSO (Least Absolute Shrinkage and Selection Operator)
3. ARIMAX (AutoRegressive Integrated Moving Average with eXogenous variables)
4. GAM (Generalized Additive Model)

## Key Findings

- The best predictors for NVIDIA's revenue were found to be:
  1. Stock price
  2. Net income
  3. Number of employees
  4. R&D spending

- Model performance comparison (RMSE on test set):
  - TSLM: 0.76
  - ARIMAX: 0.68
  - LASSO: 0.71
  - GAM: 1.00

- ARIMAX performed best overall, with the lowest RMSE on the test set.

## Conclusions

Our analysis revealed strong relationships between NVIDIA's revenue and various financial and operational metrics. The ARIMAX model provided the most accurate forecasts, suggesting that a combination of autoregressive components and exogenous variables is effective for predicting NVIDIA's revenue.

## Tools and Libraries Used

- R
- Libraries: car, readxl, dplyr, lubridate, forecast, ggplot2, glmnet, mgcv, tseries

## Future Work

- Incorporate more external factors such as market trends and competitor data
- Explore deep learning models for time series forecasting
- Extend the analysis to other key financial metrics

## Contributors

- Roberto Vicentini
- Giovanni Piva

---

This project demonstrates skills in data preprocessing, time series analysis, machine learning, and financial forecasting using R and various statistical techniques.
