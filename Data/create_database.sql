CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    signup_date DATE NOT NULL,
    country TEXT NOT NULL,
    age INTEGER,
    gender TEXT
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL
);
 Create purchases table
CREATE TABLE IF NOT EXISTS purchases (
    purchase_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    purchase_date DATE NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data into customers table
INSERT INTO customers (customer_id, name, email, signup_date, country, age, gender)
VALUES
    (1, 'John Smith', 'john.smith@email.com', '2023-01-15', 'USA', 34, 'Male'),
    (2, 'Mary Johnson', 'mary.johnson@email.com', '2023-02-20', 'Canada', 29, 'Female'),
    (3, 'Robert Brown', 'robert.brown@email.com', '2023-01-30', 'UK', 45, 'Male'),
    (4, 'Patricia Davis', 'patricia.davis@email.com', '2023-03-10', 'Australia', 52, 'Female'),
    (5, 'Michael Miller', 'michael.miller@email.com', '2023-02-05', 'USA', 41, 'Male'),
    (6, 'Jennifer Wilson', 'jennifer.wilson@email.com', '2023-04-12', 'Canada', 38, 'Female'),
    (7, 'William Moore', 'william.moore@email.com', '2023-03-25', 'UK', 27, 'Male'),
    (8, 'Elizabeth Taylor', 'elizabeth.taylor@email.com', '2023-05-08', 'Australia', 33, 'Female'),
    (9, 'David Anderson', 'david.anderson@email.com', '2023-04-19', 'USA', 48, 'Male'),
    (10, 'Barbara Thomas', 'barbara.thomas@email.com', '2023-05-22', 'Canada', 36, 'Female');

    Insert sample data into products table
INSERT INTO products (product_id, product_name, category, price, cost)
VALUES
    (101, 'Smartphone X', 'Electronics', 799.99, 450.00),
    (102, 'Laptop Pro', 'Electronics', 1299.99, 800.00),
    (103, 'Wireless Earbuds', 'Electronics', 129.99, 45.00),
    (104, 'Running Shoes', 'Sportswear', 89.99, 30.00),
    (105, 'Yoga Mat', 'Sportswear', 29.99, 10.00),
    (106, 'Coffee Maker', 'Home Appliances', 79.99, 35.00),
    (107, 'Blender', 'Home Appliances', 49.99, 20.00),
    (108, 'Novel Bestseller', 'Books', 24.99, 8.00),
    (109, 'Cookbook', 'Books', 34.99, 12.00),
    (110, 'Office Chair', 'Furniture', 149.99, 70.00);

-- Insert sample data into purchases table
INSERT INTO purchases (purchase_id, customer_id, product_id, purchase_date, quantity)
VALUES
    (1001, 1, 101, '2023-03-15', 1),
    (1002, 2, 103, '2023-04-02', 1),
    (1003, 3, 102, '2023-03-10', 1),
    (1004, 4, 106, '2023-05-20', 1),
    (1005, 5, 104, '2023-04-25', 2),
    (1006, 6, 110, '2023-06-12', 1),
    (1007, 7, 108, '2023-05-30', 3),
    (1008, 8, 105, '2023-07-05', 1),
    (1009, 9, 107, '2023-06-22', 1),
    (1010, 10, 109, '2023-07-15', 1),
    (1011, 1, 103, '2023-05-10', 1),
    (1012, 2, 106, '2023-06-18', 1),
    (1013, 3, 110, '2023-04-05', 1),
    (1014, 4, 108, '2023-07-22', 2),
    (1015, 5, 101, '2023-05-30', 1),
    (1016, 6, 102, '2023-08-14', 1),
    (1017, 7, 105, '2023-06-27', 2),
    (1018, 8, 107, '2023-08-30', 1),
    (1019, 9, 104, '2023-07-08', 1),
    (1020, 10, 103, '2023-09-12', 1),
    (1021, 1, 107, '2023-06-24', 1),
    (1022, 3, 105, '2023-05-15', 1),
    (1023, 5, 109, '2023-07-03', 1),
    (1024, 7, 101, '2023-08-19', 1),
    (1025, 9, 103, '2023-09-01', 2);
