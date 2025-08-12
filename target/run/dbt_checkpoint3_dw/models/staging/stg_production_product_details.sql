
  
  
  
  create or replace view `ted_dev`.`db_silver`.`stg_production_product_details`
  
  as (
    with source as (
    select * 
    from `ted_dev`.`bronze`.`raw_sqlserver_production_product_db`
),

revised as (

    select
        ProductID         as product_id
        , Name              as product_name
        , ProductNumber     as product_number
        , MakeFlag         as is_make
        , FinishedGoodsFlag as is_finished_goods
        , Color             as product_color
        , SafetyStockLevel  as safety_stock_level
        , ReorderPoint      as reorder_point
        , cast(StandardCost as decimal(18,2))      as standard_cost
        , cast(ListPrice as decimal(18,2))         as list_price
        , Size              as product_size
        , SizeUnitMeasureCode as size_unit_measure_code
        , WeightUnitMeasureCode as weight_unit_measure_code
        , Weight            as product_weight
        , DaysToManufacture as days_to_manufacture
        , ProductLine       as product_line
        , Class             as product_class
        , Style             as product_style
        , ProductSubcategoryID as product_subcategory_id
        , ProductModelID    as product_model_id
        , cast(SellStartDate as date)     as sell_start_date
        , cast(SellEndDate as date)       as sell_end_date
        , cast(DiscontinuedDate as date)  as discontinued_date
        , rowguid           as row_guid
        , cast(ModifiedDate as date)      as modified_date

    from source

)

select * from revised
  )
