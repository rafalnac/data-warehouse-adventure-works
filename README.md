# AdventureWorksLT2022 Data Warehouse

## Introduction

This project aims to transform the AdventureWorksLT2022 database from a transactional system into a data warehouse.
ETL process is performed using TSQL and Azure Data Factory.

## Motivation

The primary motivation behind this project is to demonstrate skills and knowledge in SQL and ETL processes.

## Features
- **Data Structure and Governance**: Creation of schema and tables - '1_DDL'.

- **Data Extraction**: Extracting data from the AdventureWorksLT2022 database - sample database for SQL Server and Azure SQL database - '2_Extract'.
  <br/>Source diagram from OLTP:
  ![OTLP_diagram](https://github.com/rafalnac/data-warehouse-adventure-works/assets/98704847/a4e99186-4329-4134-b487-d6167cd15ecf)

- **Data Transformation**: Applying transformations to clean, structure, and prepare data for analytical purposes - 3_Transfom.

- **Data Loading**: Loading the transformed data into a data warehouse for efficient querying and reporting. Data denormalization in order to obtain star schema - 4_Load.
  <br/>Targed data warehouse:
  ![dwh_diagam](https://github.com/rafalnac/data-warehouse-adventure-works/assets/98704847/c1d724dd-9d02-42a0-8575-4ecd88fe0f2b)

- **Azure Data Factory**: Utilizing Azure Data Factory for orchestrating and automating ETL processes. - In development

## Technologies Used
- **Microsoft Azure SQL Database**

- **TSQL**

- **Azure Data Factory**
