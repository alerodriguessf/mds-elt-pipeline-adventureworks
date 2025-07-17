with source as (
    select * 
    from {{ source('databricks_dw_aw', 'raw_sqlserver_sales_salesorderheader_db') }}
),

renamed as (

    select
        SalesOrderID         as order_id,
        RevisionNumber       as nm_revisao,
        cast(OrderDate as date)           as order_date,
        cast(DueDate as date)             as due_date,
        cast(ShipDate as date)            as ship_date,
        OnlineOrderFlag    as is_online_order,
        SalesOrderNumber    as order_number,
        PurchaseOrderNumber as purchase_order_number,
        AccountNumber       as account_number,
        CustomerID          as customer_id,
        SalesPersonID       as sales_person_id,
        TerritoryID         as territory_id,
        BillToAddressID     as bill_to_address_id,
        ShipToAddressID     as ship_to_address_id,
        ShipMethodID        as ship_method_id,
        CreditCardID        as credit_card_id,
        CreditCardApprovalCode as credit_card_approval_code,
        CurrencyRateID      as currency_rate_id,
        SubTotal            as sub_total,
        TaxAmt              as tax_amount,
        Freight             as freight,
        TotalDue            as total_due,
        Comment             as comment,
        rowguid            as row_guid,
        ModifiedDate        as modified_date

    from source

)

select * from renamed