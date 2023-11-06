-- Existing Structure:
-- task 1:
SELECT * FROM customers
LIMIT 10;

SELECT * FROM orders
LIMIT 10;

SELECT * FROM books
LIMIT 10;

-- task 2:
SELECT * FROM pg_Indexes
WHERE tablename = 'customers';

SELECT * FROM pg_Indexes
WHERE tablename = 'books';

SELECT * FROM pg_Indexes
WHERE tablename = 'orders';

-- Partial Index:
-- task 3:
--EXPLAIN ANALYZE SELECT customer_id, quantity
--FROM orders
--WHERE quantity > 18;

-- task 4:
--CREATE INDEX orders_customer_id_quantity_idx
--ON orders(customer_id, quantity);

-- task 5:
--EXPLAIN ANALYZE SELECT customer_id, quantity
--FROM orders
--WHERE quantity > 18;

-- Primary Key:
-- task 6:
ALTER TABLE customers
ADD CONSTRAINT customers_pkey
PRIMARY KEY (customer_id);

EXPLAIN ANALYZE SELECT * FROM customers
WHERE customer_id < 100;

SELECT * FROM pg_Indexes
WHERE tablename = 'customers';

-- task 7:
CLUSTER customers USING customers_pkey;

SELECT * FROM customers
ORDER BY customer_id
LIMIT 10;

-- task 8:
CREATE INDEX orders_customer_id_book_id_idx ON orders(customer_id, book_id);

SELECT customer_id, book_id
FROM orders
LIMIT 10;

-- task 9:
DROP INDEX IF EXISTS orders_customer_id_book_id_idx;

CREATE INDEX orders_customer_id_book_id_quantity_idx 
ON orders(customer_id, book_id, quantity);

SELECT customer_id, book_id, quantity
FROM orders
WHERE customer_id < 10
ORDER BY customer_id;

-- combining Indexes:
-- task 10:
CREATE INDEX books_author_title_idx 
ON books(author, title);

SELECT * FROM pg_Indexes
WHERE tablename = 'books';

-- An ounce of prevention is worth a pound of cure:
-- task 11:
EXPLAIN ANALYZE SELECT * FROM orders
WHERE (quantity * price_base) > 100;
-- planning time: 0.036 ms
-- execution time: 33.717 ms

-- task 12:
CREATE INDEX orders_total_price_idx
ON orders ((quantity * price_base));

-- task 13:
EXPLAIN ANALYZE SELECT * FROM orders
WHERE (quantity * price_base) > 100;
-- planning time: 0.175 ms
-- execution time: 15.826 ms

-- Application:
-- task 14:
SELECT *
FROM pg_indexes
WHERE tablename IN ('customers', 'books', 'orders')
ORDER BY tablename, indexname;

DROP INDEX IF EXISTS books_author_idx;
--DROP INDEX IF EXISTS orders_customer_id_quantity;

EXPLAIN ANALYZE SELECT * FROM customers
WHERE last_name = 'Cooper';
-- planning time: 0.043 ms
-- execution time: 9.785 ms

CREATE INDEX customers_last_name_first_name_email_address ON customers (last_name, first_name, email_address);

EXPLAIN ANALYZE SELECT * FROM customers
WHERE last_name = 'Cooper';
-- planning time: 0.129 ms
-- execution time: 0.968 ms











