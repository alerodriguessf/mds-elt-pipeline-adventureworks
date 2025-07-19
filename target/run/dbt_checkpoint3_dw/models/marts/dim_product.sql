
  
    
        create or replace table `ted_dev`.`db_gold`.`dim_product`
      
      
  using delta
      
      
      
      
      
      
      
      as
      with base as (
    select 
        product_id,
        product_name,
        is_make,
        is_finished_goods,
        product_color,
        standard_cost,
        list_price,
        product_line,
        product_class,
        product_style,
        product_subcategory_id,
        product_model_id
    from `ted_dev`.`db_silver`.`stg_production_product_details`
)

select * from base
  