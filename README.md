# 🍽️ SQL Case Study – Airbnb Listings & Reviews Analysis

This project uses an open-source dataset on Airbnb Listings & Reviews. (Source: Maven Analytics)
The data provide informations for 250,000+ listings in 10 major cities, including information about hosts, pricing, location, and room type, along with over 5 million historical reviews.
The goal of the project is to demonstrate skills in **data modeling** and **SQL querying**.


## 📂 Folder Contents

- `cs_airbnb_analysis.sql`: SQL script containing all queries.

There were also supposed to have the 3 following files, but I can't download them of Github due to their size (>100 MB). However, you can download the two csv files on [Maven Analytics](https://mavenanalytics.io/data-playground) by looking for the Airbnb Listings & Reviews dataset. 
- `Listings.csv`: List of Airbnb listings with their different features (price, location, bedrooms, ratings, etc.)
- `Reviews.csv`: List of Reviews from users (with ID, and date).
- `cs_airbnb.db`: SQLite database used for the project.

## 📌 Objectives

- Build a clean relational database using DBeaver.
- Manipulate data using SQL queries.
- Perform simple analyses in the two tables : major differences in the Airbnb market between cities, attributes having the biggest influence over the price, trends or seasonality in the review, etc.
- Incorporate some customer experience analysis
- Initiation to A/B testing with a self-made case

## 🧠 Tools Used

- SQLite  
- DBeaver  
- Git / GitHub

## 📷 Sample Query

```sql
-- 🔹 Top 50 reviewers (by their reviewer_id) 
SELECT 
  reviewer_id,
  COUNT(*) AS nb_reviews
FROM reviews
GROUP BY reviewer_id
ORDER BY nb_reviews DESC
LIMIT 50; -- if we want to reward the biggest contributors of the platform

-- 🔹 Focus on the "room_type" factor (can be done with the property / accomodates / bedrooms fields as well)
SELECT 
  room_type,
  ROUND(AVG(CAST(price AS REAL)), 2) AS avg_price,
  COUNT(*) AS nb_listings
FROM listings
WHERE price GLOB '[0-9]*'
GROUP BY room_type
ORDER BY avg_price DESC;
