-- Use the Magist database
USE magist;

/*SELLER INQUIRIES
--How many months of data are included in the magist database?*/
SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp)) AS months_data
FROM
    orders;
	-- 25 months
    
-- How many sellers are there?
SELECT 
    COUNT(DISTINCT seller_id)
FROM
    sellers;
	-- 3095
    
-- How many Tech sellers are there? 
SELECT 
    COUNT(DISTINCT seller_id)
FROM
    sellers
        LEFT JOIN
    order_items USING (seller_id)
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'watches_gifts',
        'computers',
        'tablets_printing_image',
        'telephony');
	-- 516

-- What percentage of overall sellers are Tech sellers?
SELECT (516 / 3095) * 100;
	-- 16.67%
    
 -- What is the total amount earned by all sellers?
	-- we use price from order_items and not payment_value from order_payments as an order may contain tech and non tech product. With payment_value we can't distinguish between items in an order
SELECT 
    SUM(oi.price) AS total
FROM
    order_items oi
        LEFT JOIN
    orders o USING (order_id)
WHERE
    o.order_status NOT IN ('unavailable' , 'canceled');
    -- 13494400.74
    
-- the average monthly income of all sellers?
SELECT 13494400.74/ 3095 / 25;
	-- 174.40

-- What is the total amount earned by all Tech sellers?
SELECT 
    SUM(oi.price) AS total
FROM
    order_items oi
        LEFT JOIN
    orders o USING (order_id)
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    o.order_status NOT IN ('unavailable' , 'canceled')
        AND pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'watches_gifts',
        'computers',
        'tablets_printing_image',
        'telephony');
	-- 2863089.54
    
-- the average monthly income of Tech sellers?
SELECT 2863089.54 / 454 / 25;
	-- 252.26