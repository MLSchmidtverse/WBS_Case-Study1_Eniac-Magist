-- Use the Magist database
USE magist;

-- How many orders are there in the dataset? --> 99.441
SELECT 
    COUNT(order_id)
FROM
    orders;
    
-- Are orders actually delivered?
SELECT 
    order_status, COUNT(order_id)
FROM
    orders
GROUP BY order_status;
 -- most of them, yes

-- Is Magist having user growth?
SELECT 
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(customer_id)
FROM
    orders
GROUP BY year_ , month_
ORDER BY year_ ASC , month_ ASC;
-- Yes, but there is a strange decline in orders in Sept 2018

-- How many products are there on the products table?
SELECT 
    COUNT(DISTINCT product_id) AS nr_products
FROM
    products;
    -- 32.951
    
    
-- Which are the categories with the most products?
SELECT 
    n.product_category_name_english AS name,
    count(DISTINCT product_id) AS nr_products
FROM
    products p
        LEFT JOIN
    product_category_name_translation n ON p.product_category_name = n.product_category_name
GROUP BY name
ORDER BY nr_products DESC;

/* 1. 3.029 Bed Bath Table
2. 2.867 Sports Leisure
3. 2.657 Furniture Decor
4. 2.444 Health & Beauty
5. 2.335 Housewares
(...)
7. 1.639 Computer Accessoires
(...)
10. 1.134 Telephony
15. 789 Cool Stuff ???
 */

-- How many of those products were present in actual transactions?
SELECT 
    n.product_category_name_english AS name,
    COUNT(DISTINCT p.product_id) AS nr_products,
    COUNT(DISTINCT o.order_id) AS nr_orders
FROM
    products p
        LEFT JOIN
    product_category_name_translation n ON p.product_category_name = n.product_category_name
        LEFT JOIN
    order_items o ON p.product_id = o.product_id
GROUP BY name
ORDER BY nr_orders DESC;

/* 1. 9.417 Bed Bath Table
2. 8.836 Health & Beauty
3. 7.720 Sports Leisure
4. 6.689 Computer Accessoires
5. 6.449 Furniture Decor
(...)
8. 4.199 Telephony
(...)
11. 3.632 Cool Stuff ???
 */

-- What’s the price for the most expensive and cheapest products?

-- Get max & min
SELECT 
    n.product_category_name_english AS name,
    MAX(o.price) AS max_price,
    MIN(o.price) AS min_price
FROM
    products p
        LEFT JOIN
    product_category_name_translation n ON p.product_category_name = n.product_category_name
        LEFT JOIN
    order_items o ON p.product_id = o.product_id
GROUP BY name
ORDER BY max_price DESC;

/* MAX: Housewares, Computers, Art
MIN: Construction Tools, Health & Beauty, Stationary
 */

-- Get price ranges
SELECT 
    n.product_category_name_english AS name,
    ROUND(MAX(o.price) - MIN(o.price),2) AS price_range
FROM
    products p
        LEFT JOIN
    product_category_name_translation n ON p.product_category_name = n.product_category_name
        LEFT JOIN
    order_items o ON p.product_id = o.product_id
GROUP BY name
ORDER BY price_range DESC;

-- What are the highest and lowest payment values?
  SELECT 
    MAX(payment_value) AS max_payment,
    MIN(payment_value) AS min_payment
FROM
    order_payments
WHERE
    payment_value > 0;

/* MAX: 13.664,10€
MIN: 0,01 €
 */
    
SELECT 
    payment_value
FROM
    order_payments
ORDER BY payment_value ASC;