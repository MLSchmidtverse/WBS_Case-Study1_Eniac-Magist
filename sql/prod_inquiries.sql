-- Use the Magist database
USE magist;

/*PRODUCT INQUIRIES
--What categories of tech products does Magist have?*/
SELECT 
    COUNT(DISTINCT (oi.product_id)) AS tech_products_sold
FROM
    order_items oi
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    product_category_name_english = 'audio'
        OR product_category_name_english = 'electronics'
        OR product_category_name_english = 'computers_accessories'
        OR product_category_name_english = 'watches_gifts'
        OR product_category_name_english = 'computers'
        OR product_category_name_english = 'tablets_printing_image'
        OR product_category_name_english = 'telephony';
	-- 4716

-- What percentage does that represent from the overall number of products sold?
SELECT 
    COUNT(DISTINCT (product_id)) AS products_sold
FROM
    order_items;
	-- 32951
    
SELECT 4716 / 32951;
	-- 0.1431, therefore 14%

-- What’s the average price of the products being sold?
SELECT 
    ROUND(AVG(price), 2)
FROM
    order_items;
	-- 120.65

-- Are expensive tech products popular? *
SELECT COUNT(oi.product_id), 
	CASE 
		WHEN price > 1000 THEN "Expensive"
		WHEN price > 100 THEN "Mid-range"
		ELSE "Cheap"
	END AS "price_range"
FROM order_items oi
LEFT JOIN products p
	ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation pt
	USING (product_category_name)
WHERE pt.product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY price_range
ORDER BY 1 DESC;
	-- 11361 cheap
    -- 4263 mid-range
    -- 174 expensive