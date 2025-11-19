# E-Commerce-Database
small relational database for an online store.


ERD

```mermaid
erDiagram
    USERS {
        INT      user_id PK
        VARCHAR  email
        VARCHAR  full_name
        TIMESTAMP created_at
        BOOLEAN  is_active
    }

    PRODUCTS {
        INT       product_id PK
        VARCHAR   name
        TEXT      description
        NUMERIC   price
        VARCHAR   sku
        BOOLEAN   is_active
        TIMESTAMP created_at
    }

    ORDERS {
        INT       order_id PK
        INT       user_id FK
        VARCHAR   status
        TIMESTAMP order_date
        NUMERIC   total_amount
        TEXT      shipping_address
        TEXT      billing_address
    }

    ORDER_ITEMS {
        INT       order_item_id PK
        INT       order_id FK
        INT       product_id FK
        INT       quantity
        NUMERIC   unit_price
        NUMERIC   line_total
    }

    INVENTORY {
        INT       product_id PK, FK
        INT       quantity_in_stock
        TIMESTAMP last_updated
    }

    %% Relationships
    USERS ||--o{ ORDERS      : "places"
    ORDERS ||--o{ ORDER_ITEMS: "contains"
    PRODUCTS ||--o{ ORDER_ITEMS : "appears in"
    PRODUCTS ||--|| INVENTORY   : "has"
