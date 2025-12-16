SELECT
  p.product_id,
  p.name,
  SUM(oi.line_total) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status IN ('PAID', 'SHIPPED')
GROUP BY p.product_id, p.name
ORDER BY revenue DESC
LIMIT 5;
