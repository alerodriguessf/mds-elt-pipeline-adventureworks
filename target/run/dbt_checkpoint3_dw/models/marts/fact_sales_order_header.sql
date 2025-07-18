
  
    
        create or replace table `ted_dev`.`db_gold`.`fact_sales_order_header`
      
      
  using delta
      
      
      
      
      
      
      
      as
      with base as (
    select
        id_pedido,
        id_cliente as cliente_id
    from `ted_dev`.`db_silver`.`stg_sales_order_header`
)
select * from base
  