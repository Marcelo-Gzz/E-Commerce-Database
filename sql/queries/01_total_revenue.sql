SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status IN ('PAID', 'SHIPPED');
