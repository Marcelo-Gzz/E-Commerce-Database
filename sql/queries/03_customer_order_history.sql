SELECT
  u.full_name,
  o.order_id,
  o.order_date,
  o.status,
  o.total_amount
FROM orders o
JOIN users u ON u.user_id = o.user_id
WHERE u.email = 'ava@example.com'
ORDER BY o.order_date DESC;
