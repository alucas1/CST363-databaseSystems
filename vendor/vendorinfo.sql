 -- Author: Alberto Lucas
 -- Date: 01/19/2021
 -- Class: CST363
 -- Description: e5.1 Exercises from chapter 5
 
 -- 1  Display the RegionID, RegionName and number of stores in each region.
SELECT r.regionid,
       r.regionname,
       Count(*) AS storesinregion
FROM   region r
       INNER JOIN store s
               ON r.regionid = s.regionid
GROUP  BY r.regionid;

-- 2 Display CategoryID and average price of products in that category.
SELECT categoryid,
       Avg(productprice) AS averageproductprice
FROM   product
GROUP  BY categoryid;

-- 3 Display CategoryID and number of items purchased in that category.
SELECT c.categoryid,
       Sum(i.quantity) AS itemspurchased
FROM   category c
       INNER JOIN product p
               ON c.categoryid = p.categoryid
       INNER JOIN includes i
               ON p.productid = i.productid
GROUP  BY c.categoryid;

-- 4 Display RegionID, RegionName and total amount of sales as AmountSpent
SELECT r.regionid,
       r.regionname,
       Sum(p.productprice * i.quantity) AS AmountSpent
FROM   region r
       INNER JOIN store s
               ON r.regionid = s.regionid
       INNER JOIN salestransaction st
               ON s.storeid = st.storeid
       INNER JOIN includes i
               ON st.tid = i.tid
       INNER JOIN product p
               ON i.productid = p.productid
GROUP  BY r.regionid;

-- 5 Display the TID and total number of items in the sale
--    for all sales where the total number of items is greater than 3
SELECT tid,
       Sum(quantity) AS totalsaleitems
FROM   includes i
GROUP  BY tid
HAVING Sum(quantity) > 3;

-- 6 For vendor whose product sales exceeds $700, display the
--    VendorID, VendorName and total amount of sales as "TotalSales"
SELECT v.vendorid,
       v.vendorname,
       Sum(i.quantity * p.productprice) AS TotalSales
FROM   vendor v
       INNER JOIN product p
               ON v.vendorid = p.vendorid
       INNER JOIN includes i
               ON p.productid = i.productid
GROUP  BY vendorid
HAVING Sum(i.quantity * p.productprice) > 700;

-- 7 Display the ProductID, Productname and ProductPrice
--    of the cheapest product.
SELECT productid,
       productname,
       productprice
FROM   product
WHERE  productprice = (SELECT Min(productprice)
                       FROM   product);

-- 8 Display the ProductID, Productname and VendorName
--    for products whose price is below average price of all products
--    sorted by productid.
SELECT productid,
       productname,
       vendorname
FROM   product p
       INNER JOIN vendor v
               ON p.vendorid = v.vendorid
WHERE  productprice < (SELECT Avg(productprice)
                       FROM   product)
ORDER  BY productid;

-- 9 Display the ProductID and Productname from products that
--    have sold more than 2 (total quantity).  Sort by ProductID
SELECT p.productid,
       p.productname
FROM   product p
       INNER JOIN includes i
               ON p.productid = i.productid
GROUP  BY productid
HAVING Sum(quantity) > 2
ORDER  BY productid;

-- 10 Display the ProductID for the product that has been 
--    sold the most (highest total quantity across all
--    transactions). 
WITH productssold(productid, totalsold)
     AS (SELECT productid,
                Sum(quantity)
         FROM   includes
         GROUP  BY productid)
SELECT productid
FROM   productssold
WHERE  totalsold = (SELECT Max(totalsold)
                    FROM   productssold);

-- 11 Rewrite query 30 in chapter 5 using a join.
-- Query 30 text: For each product that has more than three items sold within 
-- all sales transactions, retrieve the product id, product name, and product price.
WITH morethanthreesold(productid)
     AS (SELECT productid
         FROM   includes
         GROUP  BY productid
         HAVING Sum(quantity) > 3)
SELECT p.productid,
       p.productname,
       p.productprice
FROM   product p
       INNER JOIN morethanthreesold mt3
               ON mt3.productid = p.productid;
               
-- 12 Rewrite query 31 using a join.
-- Query 31 text: For each product whose items were sold in more than one sales 
-- transaction, retrieve the product id, product name, and product price.
SELECT p.productid,
       p.productname,
       p.productprice
FROM   product p
       INNER JOIN (SELECT productid
                   FROM   includes
                   GROUP  BY productid
                   HAVING Count(tid) > 1) AS multipleSoldInOneSale
               ON p.productid = multipleSoldInOneSale.productid;
               
-- 13 create a view over the product, salestransaction, includes, customer, store, region tables
--     with columns: tdate, productid, productname, productprice, quantity, customerid, customername, 
--                   storeid, storezip, regionname
CREATE VIEW full_sales_info
AS
  SELECT st.tdate,
         p.productid,
         p.productname,
         p.productprice,
         i.quantity,
         c.customerid,
         c.customername,
         s.storeid,
         s.storezip,
         r.regionname
  FROM   product p
         INNER JOIN includes i
                 ON p.productid = i.productid
         INNER JOIN salestransaction st
                 ON i.tid = st.tid
         INNER JOIN customer c
                 ON st.customerid = c.customerid
         INNER JOIN store s
                 ON st.storeid = s.storeid
         INNER JOIN region r
                 ON s.regionid = r.regionid;

-- 14 Using the view created in question 13
--   Display ProductID, ProductName, ProductPrice  
--   for products sold in zip code "60600" sorted by ProductID
SELECT productid,
       productname,
       productprice
FROM   full_sales_info
WHERE  storezip = '60600'
ORDER  BY productid;

-- 15 Using the view from question 13 
--    display CustomerName and TDate for any customer buying a product "Easy Boot"
SELECT customername,
       tdate
FROM   full_sales_info
WHERE  productname = 'Easy Boot';

-- 16 Using the view from question 13
--    display RegionName and total amount of sales in each region as "AmountSpent"
SELECT regionname,
       Sum(productprice * quantity) AS AmountSpent
FROM   full_sales_info
GROUP  BY regionname;  