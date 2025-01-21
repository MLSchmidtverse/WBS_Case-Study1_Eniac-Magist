-- Use the Magist database
USE magist;

/*JOIN TABLES
-- Table 1: products, orders, dates*/
CREATE TABLE pod_table SELECT DISTINCT p.product_id AS prod_id,
    n.product_category_name_english AS category,
    ROUND(p.product_length_cm * p.product_height_cm * p.product_width_cm,
            2) AS prod_size,
    p.product_weight_g AS prod_weight,
    o.order_id AS order_id,
    oi.price AS price,
    o.order_purchase_timestamp AS purchase,
    o.order_approved_at AS approved,
    o.order_delivered_customer_date AS deliv_cust,
    o.order_delivered_carrier_date AS deliv_carrier,
    o.order_estimated_delivery_date AS est_deliv,
    TIMESTAMPDIFF(HOUR,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date) AS purchasediff_hrs,
    ROUND(TIMESTAMPDIFF(HOUR,
                o.order_purchase_timestamp,
                o.order_delivered_customer_date) / 24,
            2) AS purchasediff_days,
    TIMESTAMPDIFF(HOUR,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date) AS delivdiff_hrs,
    ROUND(TIMESTAMPDIFF(HOUR,
                o.order_estimated_delivery_date,
                o.order_delivered_customer_date) / 24,
            2) AS delivdiff_days,
    r.review_score AS review_score,
    r.review_id AS review_id FROM
    products p
        LEFT JOIN
    product_category_name_translation n ON p.product_category_name = n.product_category_name
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
        LEFT JOIN
    orders o ON oi.order_id = o.order_id
        LEFT JOIN
    order_reviews r ON o.order_id = r.order_id;

SELECT 
    *
FROM
    pod_table;

-- Table 2: orders, customers, sellers

CREATE TABLE ocs_table SELECT DISTINCT p.product_id AS prod_id,
    oi.order_id AS order_id,
    o.customer_id AS customer_id,
    oi.seller_id AS seller_id,
    s.seller_zip_code_prefix AS seller_zip,
    c.customer_zip_code_prefix AS customer_zip,
    g.city AS seller_city,
    g.state AS seller_state FROM
    products p
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
        LEFT JOIN
    orders o ON oi.order_id = o.order_id
        LEFT JOIN
    sellers s ON oi.seller_id = s.seller_id
        LEFT JOIN
    geo g ON s.seller_zip_code_prefix = g.zip_code_prefix
        LEFT JOIN
    customers c ON o.customer_id = c.customer_id;

SELECT 
    *
FROM
    ocs_table;