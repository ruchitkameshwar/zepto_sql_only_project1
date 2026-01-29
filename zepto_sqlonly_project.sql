drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discounttedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
SELECT COUNT (*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category is NUll
OR
mrp is NUll
OR
discountPercent is NUll
OR
zepto.discounttedsellingprice is NUll
OR
weightInGms IS NULL
OR
availableQuantity is NUll
OR
outOfStock is NUll
OR
quantity IS NULL;


--different product catageroies

SELECT DISTINCT category
FROM zepto
ORDER BY category;

--peroducts in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
From zepto
Group BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAving count(sku_id) > 1
ORDER BY count(sku_id) DESC;


--data cleaning

--product with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR zepto.discounttedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discounttedsellingprice = zepto.discounttedsellingprice/100.0;

SELECT mrp, zepto.discounttedsellingprice FROM zepto

--Q1- Find the top 10 best valued products based on the discounted percentage.

SELECT DISTINCT name, mrp, discountPercent
From zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2 What are the products with HIGH mrp but OUT stock

SELECT DISTINCT name, mrp
FROM zepto
Where outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

-- Q3 Calculate Eastimited Revenue for each category
Select category,
SUM(zepto.discounttedsellingprice + availableQuantity) AS total_revenue
FROM zepto
group by category
Order by total_revenue;

--Q4 Find All products where mrp is greater than 500 Rupees and discount is less than 10%.

 SELECT DISTINCT name, mrp, discountPercent
 FROM zepto
 WHERE 	mrp > 500 AND discountPercent < 10
 ORDER BY mrp DESC, discountPercent DESC;

-- Q5 Identify the top categories offering the highest average discount percentage.

SELECT category,
ROUND(AVG(zepto.discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6 FIND the price per gram for products above 100mg and sort by best value.

SELECT DISTINCT name, weightInGms, zepto.discounttedsellingprice,
ROUND(zepto.discounttedsellingprice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7 Group the Products into categories like low, medium, bluk.

SELECT DISTINCT name , weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
WHEN weightInGms < 5000 THEN 'Medium'
ELSE 'Bulk'
END AS weight_category
FROM zepto;


-- Q8 What is the total Inventory Weight Per CATEGORY

SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


