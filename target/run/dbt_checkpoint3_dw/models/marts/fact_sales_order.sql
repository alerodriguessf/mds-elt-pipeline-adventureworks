
  
    
        create or replace table `ted_dev`.`db_gold`.`fact_sales_order`
      
      
  using delta
      
      
      
      
      
      
      
      as
      with order_detail as (
    select *
    from `ted_dev`.`db_silver`.`stg_sales_order_detail`
),

order_header as (
    select *
    from `ted_dev`.`db_silver`.`stg_sales_order_header`
),

joined as (
    select
        -- IDs principais
        od.order_id,
        od.order_detail_id,

        -- Produto e oferta
        od.product_id,

        -- Cliente e vendedor
        oh.customer_id,
        oh.sales_person_id,
        oh.territory_id,

        -- Datas relevantes
        oh.order_date,
        oh.due_date,
        oh.ship_date,

        -- Informações de envio e pagamento
        oh.ship_method_id,
        oh.currency_rate_id,

        -- Quantidade e preço
        od.order_quantity,
        od.unit_price,
        od.unit_price_discount,
        od.line_total,

        -- Receita bruta ajustada (sem considerar impostos ou frete)
        (od.order_quantity * od.unit_price * (1 - od.unit_price_discount)) as gross_revenue,

        -- Flags e rastreabilidade
        oh.is_online_order,
        current_timestamp() as ingestion_timestamp

    from order_detail od
    left join order_header oh
        on od.order_id = oh.order_id
)

select * from joined
  