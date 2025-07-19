
  
    
        create or replace table `ted_dev`.`db_gold`.`dim_ship_method`
      
      
  using delta
      
      
      
      
      
      
      
      as
      with source as (
    select *
    from `ted_dev`.`db_silver`.`stg_sales_ship_method`
),

renamed as (
    select
        ship_method_id,
        ship_method_name,
        ship_base,
        ship_rate,
        cast(modified_date as date) as modified_date
    from source
)

select * from renamed
  