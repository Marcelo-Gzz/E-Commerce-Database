SELECT
  p.product_id,
  p.name,
  i.quantity_in_stock
FROM inventory i
JOIN products p ON p.product_id = i.product_id
WHERE i.quantity_in_stock <= 50
ORDER BY i.quantity_in_stock ASC;
