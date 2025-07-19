
  
  
  
  create or replace view `ted_dev`.`db_silver`.`stg_sales_territory`
  
  as (
    with source as (
    select * 
    from `ted_dev`.`bronze`.`raw_sqlserver_sales_salesterritory_db`
),

revised as (

    select
        cast(TerritoryID as bigint)                 as territory_id,
        cast(Name as string)                        as territory_name,
        cast(CountryRegionCode as string)           as country_region_code,
        cast(Group as string)                       as territory_group,
        cast(SalesYTD as decimal(18,2))             as sales_ytd,
        cast(SalesLastYear as decimal(18,2))        as sales_last_year,
        cast(CostYTD as decimal(18,2))              as cost_ytd,
        cast(CostLastYear as decimal(18,2))         as cost_last_year,
        cast(rowguid as string)                     as row_guid,
        cast(ModifiedDate as date)                  as modified_date

    from source
)

select * from revised
  )
