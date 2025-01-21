-- Use the Magist database
USE magist;

/*DELIVERY INQUIRIES
--What’s the average time between the order being placed and the product being delivered?*/
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date,
            order_purchase_timestamp))
FROM
    orders
WHERE order_status = 'delivered';
	-- 12.5030

-- How many orders are delivered on time vs orders delivered with a delay?
SELECT 
    CASE
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) > 0
        THEN
            'Delayed'
        ELSE 'On time'
    END AS delivery_status,
    COUNT(DISTINCT order_id) AS orders_count
FROM
    orders
WHERE
    order_status = 'delivered'
        AND order_estimated_delivery_date IS NOT NULL
        AND order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;
	-- on time 89805
    -- delayed 6665

-- Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT 
    CASE
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) >= 100
        THEN
            '> 100 day Delay'
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) >= 7
                AND DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) < 100
        THEN
            '1 week to 100 day delay'
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) > 3
                AND DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) < 7
        THEN
            '4-7 day delay'
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) >= 1
                AND DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) <= 3
        THEN
            '1-3 day delay'
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) > 0
                AND DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) < 1
        THEN
            'less than 1 day delay'
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) <= 0
        THEN
            'On time'
    END AS 'delay_range',
    AVG(product_weight_g) AS weight_avg,
    COUNT(DISTINCT a.order_id) AS orders_count,
    AVG(product_length_cm * product_height_cm * product_width_cm) AS prod_size
FROM
    orders a
        LEFT JOIN
    order_items b USING (order_id)
        LEFT JOIN
    products c USING (product_id)
WHERE
    order_estimated_delivery_date IS NOT NULL
        AND order_delivered_customer_date IS NOT NULL
        AND order_status = 'delivered'
GROUP BY delay_range;