
  
  
  
  create or replace view `ted_dev`.`db_silver`.`stg_person_person_details`
  
  as (
    with source as (
    select * 
    from `ted_dev`.`bronze`.`raw_sqlserver_person_person_db`
),

revised as (

    select
        BusinessEntityID as person_id,
        PersonType as person_type,
        cast(NameStyle as boolean) as name_style,
        Title as title,
        FirstName as first_name,
        MiddleName as middle_name,
        LastName as last_name,
        Suffix as suffix,
        EmailPromotion as email_promotion,
        AdditionalContactInfo as additional_contact_info,
        Demographics as demographics,
        rowguid as row_guid,
        cast(ModifiedDate as date) as modified_date
    from source

)

select * from revised
  )
