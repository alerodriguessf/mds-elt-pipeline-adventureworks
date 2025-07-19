with orders as (
    select
        ord.order_id,
        ord.territory_id,
        terr.territory_name,
        date_trunc('month', ord.order_date) as year_month,
        ord.is_online_order,
        ord.total_due,
        ord.freight,
        ord.tax_amount
    from {{ ref('stg_sales_order_header') }} ord
    left join {{ ref('stg_sales_territory') }} terr
        on ord.territory_id = terr.territory_id
),

order_items as (
    select
        order_id,
        sum(order_quantity) as total_items
    from {{ ref('stg_sales_order_detail') }}
    group by order_id
),

joined as (
    select
        o.year_month,
        o.territory_id,
        o.territory_name,
        o.is_online_order,
        o.total_due,
        o.freight,
        o.tax_amount,
        i.total_items
    from orders o
    left join order_items i
        on o.order_id = i.order_id
),

aggregated as (
    select
        year_month,
        territory_id,
        territory_name,
        is_online_order,
        count(*) as total_orders,
        sum(total_items) as total_items_sold,
        sum(total_due) as revenue,
        sum(freight) as freight_total,
        sum(tax_amount) as tax_total,
        round(sum(total_due) / nullif(count(*), 0), 2) as average_order_value
    from joined
    group by
        year_month,
        territory_id,
        territory_name,
        is_online_order
)

select * from aggregated
