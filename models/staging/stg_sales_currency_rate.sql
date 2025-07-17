with source as (
    select * 
    from {{ source('databricks_dw_aw', 'raw_sqlserver_sales_currencyrate_db') }}
),

revised as (
    select
        CurrencyRateID as currency_rate_id,
        CurrencyRateDate as currency_rate_date,
        FromCurrencyCode as from_currency_code,
        ToCurrencyCode as to_currency_code,
        AverageRate as average_rate,
        EndOfDayRate as end_of_day_rate,
        ModifiedDate as modified_date
    from source
)

select * from revised
