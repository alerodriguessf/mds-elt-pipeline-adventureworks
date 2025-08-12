
  
  
  
  create or replace view `ted_dev`.`db_silver`.`stg_sales_person_details`
  
  as (
    with source as (
    select * 
    from `ted_dev`.`bronze`.`raw_sqlserver_sales_vsalesperson_db`
),

revised as (

    select
        BusinessEntityID as sales_person_id
        , Title as title
        , FirstName as first_name
        , MiddleName as middle_name
        , LastName as last_name
        , Suffix as suffix
        , JobTitle as job_title
        , PhoneNumber as phone_number
        , PhoneNumberType as phone_number_type
        , EmailAddress as email_address
        , EmailPromotion as email_promotion
        , AddressLine1 as address_line_1
        , AddressLine2 as address_line_2
        , City as city
        , StateProvinceName as state_province_name
        , PostalCode as postal_code
        , CountryRegionName as country_region_name
        , TerritoryName as territory_id
        , TerritoryGroup as territory_group
        , cast(SalesQuota as decimal (18,2)) as sales_quota
        , cast(SalesYTD as decimal (18,2)) as sales_ytd
        , cast(SalesLastYear as decimal (18,2)) as sales_last_year
    from source
)

select * from revised
  )
