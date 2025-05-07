 p.purchase_date
"
purchase_data <- run_query(conn, purchase_data_query)
head(purchase_data)

# 5. Calculate key metrics using SQL
cat("\n--- Sales by Category ---\n")
category_sales_query <- "
SELECT 
    pr.category,
    COUNT(*) as num_purchases,
    SUM(p.quantity) as total_units_sold,
    SUM(pr.price * p.quantity) as total_revenue,
    SUM((pr.price - pr.cost) * p.quantity) as total_profit
FROM 
    purchases p
JOIN 
    products pr ON p.product_id = pr.product_id
GROUP BY 
    pr.category
ORDER BY 
    total_revenue DESC
"
category_sales <- run_query(conn, category_sales_query)
print(category_sales)

cat("\n--- Sales by Country ---\n")
country_sales_query <- "
SELECT 
    c.country,
    COUNT(*) as num_purchases,
    COUNT(DISTINCT c.customer_id) as num_customers,
    SUM(pr.price * p.quantity) as total_revenue,
    SUM(pr.price * p.quantity) / COUNT(DISTINCT c.customer_id) as avg_revenue_per_customer
FROM 
    purchases p
JOIN 
    customers c ON p.customer_id = c.customer_id
JOIN 
    products pr ON p.product_id = pr.product_id
GROUP BY 
    c.country
ORDER BY 
    total_revenue DESC
"
country_sales <- run_query(conn, country_sales_query)
print(country_sales)

# 6. Customer purchase frequency
cat("\n--- Customer Purchase Frequency ---\n")
purchase_frequency_query <- "
SELECT 
    c.customer_id,
    c.name,
    COUNT(*) as num_purchases,
    SUM(pr.price * p.quantity) as total_spent,
    MIN(p.purchase_date) as first_purchase,
    MAX(p.purchase_date) as last_purchase
FROM 
    purchases p
JOIN 
    customers c ON p.customer_id = c.customer_id
JOIN 
    products pr ON p.product_id = pr.product_id
GROUP BY 
    c.customer_id
ORDER BY 
    num_purchases DESC
"
purchase_frequency <- run_query(conn, purchase_frequency_query)
print(purchase_frequency)

# 7. Customer segmentation by purchase value
cat("\n--- Customer Value Segmentation ---\n")
customer_segmentation_query <- "
WITH customer_value AS (
    SELECT 
        c.customer_id,
        c.name,
        SUM(pr.price * p.quantity) as total_spent
    FROM 
        purchases p
    JOIN 
        customers c ON p.customer_id = c.customer_id
    JOIN 
        products pr ON p.product_id = pr.product_id
    GROUP BY 
        c.customer_id
)
SELECT 
    customer_id,
    name,
    total_spent,
    CASE 
        WHEN total_spent >= 1000 THEN 'High Value'
        WHEN total_spent >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_segment
FROM 
    customer_value
ORDER BY 
    total_spent DESC
"
customer_segments <- run_query(conn, customer_segmentation_query)
print(customer_segments)

# 8. Product popularity
cat("\n--- Product Popularity ---\n")
product_popularity_query <- "