
  
    
        create or replace table `ted_dev`.`db_gold`.`dim_costumer`
      
      
  using delta
      
      
      
      
      
      
      
      as
      with customer as (
    select *
    from `ted_dev`.`db_silver`.`stg_sales_customer_info`
),

person as (
    select *
    from `ted_dev`.`db_silver`.`stg_person_person_details`
),

territory as (
    select *
    from `ted_dev`.`db_silver`.`stg_sales_territory`
),

joined as (
    select
        cust.customer_id,
        cust.person_id,
        
        -- Nome completo formatado
        concat_ws(' ',
            per.first_name,
            per.middle_name,
            per.last_name
        ) as full_name,

        -- Informações do território
        cust.territory_id,
        terr.territory_name,
        terr.territory_group,
        terr.country_region_code

    from customer cust
    left join person per
        on cust.person_id = per.person_id

    left join territory terr
        on cust.territory_id = terr.territory_id
)

select * from joined
  