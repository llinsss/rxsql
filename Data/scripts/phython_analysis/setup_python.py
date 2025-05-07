# Visualizations for Customer Purchase Analysis
# This script creates visualizations from the analyzed data

# Load required libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(scales)

# Create output directory if it doesn't exist
if (!dir.exists("outputs")) {
  dir.create("outputs")
}

# Load the data files
purchase_data <- read_csv("data/processed_purchase_data.csv")
monthly_sales <- read_csv("data/monthly_sales.csv")
category_sales <- read_csv("data/category_sales.csv")
country_sales <- read_csv("data/country_sales.csv")
purchase_frequency <- read_csv("data/purchase_frequency.csv")
customer_segments <- read_csv("data/customer_segments.csv")
product_popularity <- read_csv("data/product_popularity.csv")

# 1. Monthly Sales Trend
monthly_sales_plot <- ggplot(monthly_sales, aes(x = month, y = total_sales, group = 1)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "steelblue", size = 3) +
  labs(title = "Monthly Sales Trend",
       x = "Month",
       y = "Total Sales ($)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(labels = dollar_format())

ggsave("outputs/monthly_sales_trend.png", monthly_sales_plot, width = 10, height = 6)

# 2. Sales by Category
category_sales_plot <- ggplot(category_sales, aes(x = reorder(category, total_revenue), y = total_revenue)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = dollar(total_revenue)), hjust = -0.1, color = "black", size = 3.5) +
  labs(title = "Revenue by Product Category",
       x = "Category",
       y = "Total Revenue ($)") +
  theme_minimal() +
  coord_flip() +
  scale_y_continuous(labels = dollar_format())

ggsave("outputs/category_sales.png", category_sales_plot, width = 10, height = 6)

# 3. Profit Margin by Category
category_sales <- category_sales %>%
  mutate(profit_margin = total_profit / total_revenue * 100)

profit_margin_plot <- ggplot(category_sales, aes(x = reorder(category, profit_margin), y = profit_margin)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  geom_text(aes(label = sprintf("%.1f%%", profit_margin)), hjust = -0.1, color = "black", size = 3.5) +
  labs(title = "Profit Margin by Product Category",
       x = "Category",
       y = "Profit Margin (%)") +
  theme_minimal() +
  coord_flip() +
  scale_y_continuous(limits = c(0, max(category_sales$profit_margin) * 1.2))

ggsave("outputs/profit_margin_by_category.png", profit_margin_plot, width = 10, height = 6)
# 4. Sales by Country
country_sales_plot <- ggplot(country_sales, aes(x = reorder(country, total_revenue), y = total_revenue)) +
  geom_bar(stat = "identity", fill = "tomato") +
  geom_text(aes(label = dollar(total_revenue)), hjust = -0.1, color = "black", size = 3.5) +
  labs(title = "Revenue by Country",
       x = "Country",
       y = "Total Revenue ($)") +
  theme_minimal() +
  coord_flip() +
  scale_y_continuous(labels = dollar_format())

ggsave("outputs/country_sales.png", country_sales_plot, width = 10, height = 6)
# 5. Customer Segments
customer_segments_plot <- ggplot(customer_segments, aes(x = customer_segment, y = total_spent, fill = customer_segment)) +
  geom_boxplot() +
  labs(title = "Customer Value Segments",
       x = "Segment",
       y = "Total Amount Spent ($)") +
  theme_minimal() +
  scale_y_continuous(labels = dollar_format()) +
  scale_fill_manual(values = c("High Value" = "darkgreen", "Medium Value" = "steelblue", "Low Value" = "tomato"))

ggsave("outputs/customer_segments.png", customer_segments_plot, width = 10, height = 6)

# 6. Top Products by Units Sold
top_products <- product_popularity %>%
  arrange(desc(units_sold)) %>%
  head(10)

product_popularity_plot <- ggplot(top_products, aes(x = reorder(product_name, units_sold), y = units_sold)) +
  geom_bar(stat = "identity", fill = "purple") +
  geom_text(aes(label = units_sold), hjust = -0.1, color = "black", size = 3.5) +
  labs(title = "Top 10 Products by Units Sold",
       x = "Product",
       y = "Units Sold") +
  theme_minimal() +
  coord_flip()

ggsave("outputs/top_products.png", product_popularity_plot, width = 10, height = 6)

# 7. Age Distribution of Customers
age_dist_plot <- ggplot(purchase_data, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Age Distribution of Customers",
       x = "Age",
       y = "Count") +
  theme_minimal()

ggsave("outputs/age_distribution.png", age_dist_plot, width = 10, height = 6)

# 8. Purchase Amount Distribution by Gender
gender_purchase_plot <- ggplot(purchase_data, aes(x = gender, y = total_spent, fill = gender)) +
  geom_boxplot() +
  labs(title = "Purchase Amount Distribution by Gender",
       x = "Gender",
       y = "Purchase Amount ($)") +
  theme_minimal() +
  scale_y_continuous(labels = dollar_format()) +
  scale_fill_manual(values = c("Male" = "lightblue", "Female" = "pink"))

ggsave("outputs/gender_purchases.png", gender_purchase_plot, width = 10, height = 6)

# 9. Category Preferences by Gender
category_gender_plot <- purchase_data %>%
  group_by(gender, category) %>%
  summarize(total_spent = sum(total_spent)) %>%
  ggplot(aes(x = category, y = total_spent, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Category Preferences by Gender",
       x = "Category",
       y = "Total Spent ($)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(labels = dollar_format()) +
  scale_fill_manual(values = c("Male" = "lightblue", "Female" = "pink"))

ggsave("outputs/category_gender_preferences.png", category_gender_plot, width = 10, height = 6)
