-- ===============================
-- 🎯 OBJECTIVE #1: EXPLORE THE LISTINGS TABLE
-- ===============================

-- 🔹 Number of listings per city
SELECT city, COUNT(*) as nb_listings
FROM Listings l
GROUP BY city

-- 🔹The least and most expensive listings

-- Least expensive listing
SELECT *
FROM Listings l
ORDER BY price ASC
LIMIT 1;

-- Most expensive listing
SELECT *
FROM Listings l
ORDER BY price DESC
LIMIT 1;

-- 🔹 Number of listings with two or more bedroom 
SELECT COUNT(*) as nb_listings_with_bedroom 
FROM Listings l
WHERE CAST(bedrooms AS INTEGER) >= 2; AND bedrooms GLOB '[0-9]*'; -- Need for some data cleaning here as the bedrooms field can sometimes integrate text


-- 🔹 Average listing price per city (please do not forget that price is in local currency)
SELECT city, ROUND(AVG(price),2) AS avg_price
FROM listings l
GROUP BY city 
ORDER BY avg_price DESC ;

-- 🔹 Attributes having influence in price (please not that with prices in different currencies, this analysis is thus irrelevant)
SELECT 
  room_type,
  property_type,
  accommodates,
  bedrooms,
  ROUND(AVG(price), 2) AS avg_price
FROM listings
WHERE price IS NOT NULL
GROUP BY room_type, property_type, accommodates, bedrooms
ORDER BY avg_price DESC;

-- 🔹 Focus on the factor "room_type" (can be done with the property / accomodates / bedrooms fields as well)
SELECT 
  room_type,
  ROUND(AVG(CAST(price AS REAL)), 2) AS avg_price,
  COUNT(*) AS nb_listings
FROM listings
WHERE price GLOB '[0-9]*'
GROUP BY room_type
ORDER BY avg_price DESC;


-- ===============================
-- 🎯 OBJECTIVE #2: EXPLORE THE REVIEWS TABLE
-- ===============================

-- 🔹 Date range of the table
SELECT 
  MIN(date) AS first_review_date,
  MAX(date) AS last_review_date
FROM reviews;

-- 🔹 Number of reviews made within this date range
SELECT COUNT(*) AS total_reviews
FROM reviews;

-- 🔹 Number of reviews per month
SELECT 
  SUBSTR(date, 1, 7) AS review_month,  -- extrait YYYY-MM
  COUNT(*) AS nb_reviews
FROM reviews
GROUP BY review_month
ORDER BY review_month;

-- 🔹 Seasonality with the number of reviews
SELECT 
  SUBSTR(date, 6, 2) AS review_month,  -- extrait YYYY-MM
  COUNT(*) AS nb_reviews
FROM reviews
GROUP BY review_month
ORDER BY nb_reviews DESC;

-- 🔹 Top 50 reviewers (by their reviewer_id) 
SELECT 
  reviewer_id,
  COUNT(*) AS nb_reviews
FROM reviews
GROUP BY reviewer_id
ORDER BY nb_reviews DESC
LIMIT 50; -- if we want to reward the biggest contributors of the platform


-- 🔹 Number of listings with more than 20 reviews. 
SELECT COUNT(*) AS nb_listings_with_20_reviews_or_more
FROM (
  SELECT listing_id, COUNT(*) AS nb_reviews
  FROM reviews
  GROUP BY listing_id
  HAVING nb_reviews > 20
);


-- ===============================
-- 🎯 OBJECTIVE #3: SIMULATION AND ANALYZE OF THE CUSTOMER EXPERIENCE
-- ===============================

-- 🔹 Customer experience & conversion - We can approximate a successful customer experience with a good review score, a superhost status and a instant bookable facility
SELECT 
  city,
  COUNT(*) AS nb_listings,
  ROUND(AVG(review_scores_rating), 2) AS avg_rating,
  ROUND(AVG(CASE WHEN host_is_superhost = 't' THEN 1 ELSE 0 END) * 100, 2) AS pct_superhosts,
  ROUND(AVG(CASE WHEN instant_bookable = 't' THEN 1 ELSE 0 END) * 100, 2) AS pct_instant_booking
FROM listings
GROUP BY city;

-- ===============================
-- 🎯 OBJECTIVE #4 : POTENTIAL A/B TESTING 
-- ===============================

-- 🔹 Try to incorporate some A/B testing - A = listings with instant_bookable feature & B = listings without instant_bookable feature 
SELECT 
  instant_bookable,
  ROUND(AVG(review_scores_rating), 2) AS avg_rating,
  COUNT(*) AS nb_listings
FROM listings
WHERE 
  review_scores_rating IS NOT NULL
  AND instant_bookable IN ('t', 'f')
GROUP BY instant_bookable;
