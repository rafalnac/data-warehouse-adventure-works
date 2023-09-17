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
 ![OTLP_diagram](https://github.com/rafalnac/data-warehouse-adventure-works/assets/98704847/0dcb9327-4bcc-4480-bead-2eff687059c6)

- **Data Transformation**: Applying transformations to clean, structure, and prepare data for analytical purposes - 3_Transfom.

- **Data Loading**: Loading the transformed data into a data warehouse for efficient querying and reporting. Data denormalization in order to obtain star schema - 4_Load.
  <br/>Targed data warehouse:
  ![dwh_diagam](https://github.com/rafalnac/data-warehouse-adventure-works/assets/98704847/a8ee9325-770f-47f0-843f-8c4119f3d71a)

- **Azure Data Factory**: Utilizing Azure Data Factory for orchestrating and automating ETL processes. - In development

## Technologies Used
- **Microsoft Azure SQL Database**

- **TSQL**

- **Azure Data Factory**
