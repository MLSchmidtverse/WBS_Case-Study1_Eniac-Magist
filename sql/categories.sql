-- Use the Magist database
USE magist;

/*CATEGORY CREATION
--Overcategories*/
SELECT 
    CASE
        WHEN
            n.product_category_name_english IN ('computers' , 'computers_accessories',
                'tablets_printing_image',
                'electronics',
                'telephony',
                'watches_gifts',
                'audio')
        THEN
            'Apple_Tech'
        WHEN
            n.product_category_name_english IN ('small_appliances' , 'consoles_games',
                'fixed_telephony',
                'pc_gamer',
                'signaling_and_security',
                'security_and_services',
                'auto',
                'construction_tools_construction',
                'construction_tools_lights',
                'construction_tools_safety',
                'costruction_tools_garden',
                'costruction_tools_tools',
                'garden_tools',
                'home_construction',
                'agro_industry_and_commerce',
                'air_conditioning')
        THEN
            'Other_Tech'
        WHEN
            n.product_category_name_english IN ('furniture_bedroom' , 'furniture_decor',
                'furniture_living_room',
                'furniture_mattress_and_upholstery',
                'home_confort',
                'home_comfort_2',
                'home_appliances',
                'home_appliances_2',
                'bed_bath_table',
                'housewares',
                'kitchen_dining_laundry_garden_furniture',
                'office_furniture',
                'portable_kitchen_food_processors',
                'small_appliances_home_oven_and_coffee')
        THEN
            'House_and_Furniture'
        WHEN
            n.product_category_name_english IN ('baby' , 'diapers_and_hygiene',
                'fashio_female_clothing',
                'fashion_bags_accessories',
                'fashion_childrens_clothes',
                'fashion_male_clothing',
                'fashion_shoes',
                'fashion_sport',
                'fashion_underwear_beach',
                'health_beauty',
                'luggage_accessories',
                'pet_shop',
                'sports_leisure',
                'perfumery')
        THEN
            'Fashion_Lifestyle_Family'
        ELSE 'Supplies_and_Other'
    END AS Overcategory,
    ROUND(COUNT(DISTINCT p.product_id) * 100 / 32951,
            2) AS percentage,
    COUNT(DISTINCT p.product_id) AS nr_products,
    COUNT(DISTINCT o.order_id) AS nr_orders,
    ROUND(MIN(oi.price), 2) AS min,
    ROUND(MAX(oi.price), 2) AS max
FROM
    products p
        LEFT JOIN
    product_category_name_translation n ON p.product_category_name = n.product_category_name
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
        LEFT JOIN
    orders o ON oi.order_id = o.order_id
GROUP BY Overcategory;

-- In Apple Tech: find expensive products

SELECT 
    n.product_category_name_english AS category,
    ROUND(AVG(oi.price), 2) AS avg_price,
    ROUND(MIN(oi.price), 2) AS min,
    ROUND(MAX(oi.price), 2) AS max
FROM
    products p
        LEFT JOIN
    product_category_name_translation n ON p.product_category_name = n.product_category_name
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
        LEFT JOIN
    orders o ON oi.order_id = o.order_id
WHERE
    n.product_category_name_english IN ('computers' , 'computers_accessories',
        'tablets_printing_image',
        'electronics',
        'telephony',
        'watches_gifts',
        'audio')
GROUP BY category;

-- Nr Products

SELECT 
    n.product_category_name_english AS category,
    COUNT(DISTINCT p.product_id) AS nr_products,
    COUNT(DISTINCT o.order_id) AS nr_orders
FROM
    products p
        LEFT JOIN
    product_category_name_translation n ON p.product_category_name = n.product_category_name
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
        LEFT JOIN
    orders o ON oi.order_id = o.order_id
WHERE
    n.product_category_name_english IN ('computers' , 'computers_accessories',
        'tablets_printing_image',
        'electronics',
        'telephony',
        'watches_gifts',
        'audio')
GROUP BY category;

SELECT 
    n.product_category_name_english AS category,
    COUNT(DISTINCT p.product_id) AS nr_products,
    CASE
        WHEN
            oi.price < 25
        THEN
            COUNT(DISTINCT p.product_id) END AS '<25€',
	CASE
        WHEN
            oi.price BETWEEN 25 AND 50
        THEN
            COUNT(DISTINCT p.product_id) END AS '25-50€',
	CASE
        WHEN
            oi.price BETWEEN 51 AND 100
        THEN
            COUNT(DISTINCT p.product_id) END AS '51-100€',
	CASE
        WHEN
            oi.price BETWEEN 101 AND 200
        THEN
            COUNT(DISTINCT p.product_id) END AS '101-200€',
	CASE
        WHEN
            oi.price BETWEEN 201 AND 500
        THEN
            COUNT(DISTINCT p.product_id) END AS '201-500€',
	CASE
        WHEN
            oi.price BETWEEN 501 AND 1000
        THEN
            COUNT(DISTINCT p.product_id) END AS '501-1000€',
	CASE
        WHEN
            oi.price BETWEEN 1001 AND 2000
        THEN
            COUNT(DISTINCT p.product_id) END AS '1001-2000€',
	CASE
        WHEN
            oi.price BETWEEN 2001 AND 3000
        THEN
            COUNT(DISTINCT p.product_id) END AS '2001-3000€',
	CASE
        WHEN
            oi.price >3000
        THEN
            COUNT(DISTINCT p.product_id) END AS '>3000€'
FROM
    products p
        LEFT JOIN
    product_category_name_translation n ON p.product_category_name = n.product_category_name
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
        LEFT JOIN
    orders o ON oi.order_id = o.order_id
WHERE n.product_category_name_english IN ('computers' , 'computers_accessories',
                'tablets_printing_image',
                'electronics',
                'telephony',
                'watches_gifts',
                'audio')
GROUP BY category;