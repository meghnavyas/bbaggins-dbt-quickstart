with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        o.customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(o.order_id) as number_of_orders,
        sum(amount) as lifetime_value

    from orders o
    join {{ ref('stg_payments') }} p
        on o.order_id = p.order_id

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(lifetime_value, 0) as lifetime_value

    from customers

    left join customer_orders using (customer_id)

)

select * from final
