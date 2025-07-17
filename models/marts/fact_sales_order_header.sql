with base as (
    select
        id_pedido,
        id_cliente as cliente_id
    from {{ ref('stg_sales_order_header') }}
)
select * from base

