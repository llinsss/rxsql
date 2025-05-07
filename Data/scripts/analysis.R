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
SELECT 
    pr.product_id,
    pr.product_name,
    pr.category,
    COUNT(*) as num_purchases,
    SUM(p.quantity) as units_sold,
    SUM(pr.price * p.quantity) as total_revenue
FROM 
    purchases p
JOIN 
    products pr ON p.product_id = pr.product_id
GROUP BY 
    pr.product_id
ORDER BY 
    units_sold DESC
"
product_popularity <- run_query(conn, product_popularity_query)
print(product_popularity)

# 9. Now use R for more advanced analysis
# Convert purchase_date to proper date format
purchase_data$purchase_date <- as.Date(purchase_data$purchase_date)

# Add month field for time series analysis
purchase_data$month <- format(purchase_data$purchase_date, "%Y-%m")

# Monthly sales trends
cat("\n--- Monthly Sales Trends ---\n")
monthly_sales <- purchase_data %>%
  group_by(month) %>%
  summarize(
    total_sales = sum(total_spent),
    num_purchases = n(),
    avg_order_value = total_sales / num_purchases
  )
print(monthly_sales)

# Age group analysis
cat("\n--- Age Group Analysis ---\n")
purchase_data$age_group <- cut(purchase_data$age, 
                              breaks = c(0, 25, 35, 45, 55, 100),
                              labels = c("18-25", "26-35", "36-45", "46-55", "56+"))

age_analysis <- purchase_data %>%
  group_by(age_group) %>%
  summarize(
    num_purchases = n(),
    total_spent = sum(total_spent),
    avg_order_value = total_spent / num_purchases
  )
print(age_analysis)

# Gender analysis
cat("\n--- Gender Analysis ---\n")
gender_analysis <- purchase_data %>%
  group_by(gender) %>%
  summarize(
    num_customers = n_distinct(customer_id),
    num_purchases = n(),
    total_spent = sum(total_spent),
    avg_spent_per_customer = total_spent / num_customers
  )
print(gender_analysis)
# Product category preferences by demographic
cat("\n--- Category Preferences by Gender ---\n")
category_by_gender <- purchase_data %>%
  group_by(gender, category) %>%
  summarize(
    num_purchases = n(),
    total_spent = sum(total_spent)
  ) %>%
  arrange(gender, desc(total_spent))
print(category_by_gender)

cat("\n--- Category Preferences by Age Group ---\n")
category_by_age <- purchase_data %>%
  group_by(age_group, category) %>%
  summarize(
    num_purchases = n(),
    total_spent = sum(total_spent)
  ) %>%
  arrange(age_group, desc(total_spent))
print(category_by_age)

# Save processed data for visualization
write.csv(purchase_data, "data/processed_purchase_data.csv", row.names = FALSE)
write.csv(monthly_sales, "data/monthly_sales.csv", row.names = FALSE)
write.csv(category_sales, "data/category_sales.csv", row.names = FALSE)
write.csv(country_sales, "data/country_sales.csv", row.names = FALSE)
write.csv(purchase_frequency, "data/purchase_frequency.csv", row.names = FALSE)
write.csv(customer_segments, "data/customer_segments.csv", row.names = FALSE)
write.csv(product_popularity, "data/product_popularity.csv", row.names = FALSE)

# Close the database connection
dbDisconnect(conn)
cat("\nAnalysis completed and data saved to CSV files.\n")