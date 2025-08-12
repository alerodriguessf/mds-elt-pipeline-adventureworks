
  
  
  
  create or replace view `ted_dev`.`db_silver`.`stg_sales_ship_method`
  
  as (
    with source as (
    select * 
    from `ted_dev`.`bronze`.`raw_sqlserver_purchasing_shipmethod_db`
),

revised as (

    select
        cast(ShipMethodID as bigint)         as ship_method_id
        , cast(Name as  string)                as ship_method_name
        , cast(ShipBase as decimal (18,2))             as ship_base
        , cast(ShipRate as decimal (18,2))           as ship_rate
        , cast(rowguid as string)             as row_guid
        , cast(ModifiedDate as date)         as modified_date  

    from source
)

select * from revised
  )
