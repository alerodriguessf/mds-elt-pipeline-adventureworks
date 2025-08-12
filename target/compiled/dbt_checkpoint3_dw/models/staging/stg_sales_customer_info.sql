with source as (
    select * 
    from `ted_dev`.`bronze`.`raw_sqlserver_sales_customer_db`
),

revised as (

    select
        CustomerID as customer_id
        , PersonID as person_id
        , StoreID as store_id
        , TerritoryID as territory_id
        , AccountNumber as account_number
        , rowguid as row_guid
        , cast(ModifiedDate as date) as modified_date
    from source

)

select * from revised