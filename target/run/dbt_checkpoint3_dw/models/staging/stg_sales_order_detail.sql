
  
  
  
  create or replace view `ted_dev`.`db_silver`.`stg_sales_order_detail`
  
  as (
    with source as (
    select * 
    from `ted_dev`.`bronze`.`raw_sqlserver_sales_salesorderdetail_db`
),

revised as (

    select
        SalesOrderID         as order_id,
        SalesOrderDetailID  as order_detail_id,
        CarrierTrackingNumber as tracking_number,
        OrderQty            as order_quantity,
        ProductID           as product_id,
        SpecialOfferID      as special_offer_id,
        cast(UnitPrice as decimal (18,2))           as unit_price,
        cast(UnitPriceDiscount as decimal(18,2))   as unit_price_discount,
        cast(LineTotal as decimal(18,2))           as line_total,
        rowguid            as row_guid,
        cast(ModifiedDate as date)        as modified_date
    from source

)

select * from revised
  )
