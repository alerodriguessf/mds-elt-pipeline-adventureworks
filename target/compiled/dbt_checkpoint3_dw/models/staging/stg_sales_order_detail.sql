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
        UnitPrice           as unit_price,
        UnitPriceDiscount   as unit_price_discount,
        LineTotal           as line_total,
        rowguid            as row_guid,
        ModifiedDate        as modified_date
    from source

)

select * from revised