with source as (
    select * 
    from `ted_dev`.`bronze`.`raw_sqlserver_production_product_db`
),

revised as (

    select
        ProductID         as product_id,
        Name              as product_name,
        ProductNumber     as product_number,
        MakeFlag         as is_make,
        FinishedGoodsFlag as is_finished_goods,
        Color             as product_color,
        SafetyStockLevel  as safety_stock_level,
        ReorderPoint      as reorder_point,
        StandardCost      as standard_cost,
        ListPrice         as list_price,
        Size              as product_size,
        SizeUnitMeasureCode as size_unit_measure_code,
        WeightUnitMeasureCode as weight_unit_measure_code,
        Weight            as product_weight,
        DaysToManufacture as days_to_manufacture,
        ProductLine       as product_line,
        Class             as product_class,
        Style             as product_style,
        ProductSubcategoryID as product_subcategory_id,
        ProductModelID    as product_model_id,
        SellStartDate     as sell_start_date,
        SellEndDate       as sell_end_date,
        DiscontinuedDate  as discontinued_date,
        rowguid           as row_guid,
        ModifiedDate      as modified_date

    from source

)

select * from revised