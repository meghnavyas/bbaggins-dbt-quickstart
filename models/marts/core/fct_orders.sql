select
    A.order_id,
    customer_id,
    amount

from {{ ref('stg_orders') }} A
inner join {{ ref('stg_payments') }}  B
    on A.order_id = B.order_id

    