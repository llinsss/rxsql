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
