      Project Overview

This project is part of the MeriSKILL Internship Program and focuses on cleaning, transforming, and enriching a sales dataset using PostgreSQL.

The goal is to prepare raw sales data for analysis by:

Handling missing values

Removing duplicate records

Creating meaningful time-based and categorical features

Ensuring the dataset is analysis-ready and reliable

Dataset Description

      The dataset contains sales transaction records with the following key attributes:

Order ID

Product

Quantity Ordered

Price Each

Order Date

Purchase Address

City

Month

Hour

Sales

     Data Cleaning Steps
1 Initial Data Inspection

Reviewed the dataset structure

Identified NULL values across critical columns

2️ Handling Missing Values

Checked for NULLs in essential fields such as:

Order ID

Product

Quantity Ordered

Price

Order Date

Sales

     Ensured data completeness before transformation

3️ Duplicate Detection & Removal

Identified duplicate records using all transactional fields

Removed duplicates using ROW_NUMBER() while retaining the original record

4️ Feature Engineering

New columns were created to enhance analysis:

Dates – extracted date from timestamp

Season – categorized months into seasons

Month_String – converted numeric month to text

Hour_String – converted numeric hour to text

Period – grouped purchase time into:

Night

Morning

Afternoon

Evening

Weekdays – extracted day of the week from order date

     Tools & Techniques

Database: PostgreSQL

Language: SQL

Techniques Used:

Common Table Expressions (CTEs)

Window Functions (ROW_NUMBER)

Data Type Casting

Conditional Logic (CASE WHEN)

Date & Time Functions



      Key Learnings

Writing clean, readable SQL for real-world datasets

Handling duplicates safely in PostgreSQL

Feature engineering for time-based analysis

Preparing datasets for visualization and business insights

