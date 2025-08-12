with source as (
    select * 
    from {{ source('databricks_dw_aw', 'raw_sqlserver_sales_currencyrate_db') }}
),

revised as (
    select
        CurrencyRateID as currency_rate_id
        , cast(CurrencyRateDate as date) as currency_rate_date
        , FromCurrencyCode as from_currency_code
        , ToCurrencyCode as to_currency_code
        , cast(AverageRate as decimal(18,2)) as average_rate
        , cast(EndOfDayRate as decimal(18,2)) as end_of_day_rate
        , cast(ModifiedDate as date) as modified_date
    from source
)

select * from revised
