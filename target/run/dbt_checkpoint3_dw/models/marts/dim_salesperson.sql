
  
    
        create or replace table `ted_dev`.`db_gold`.`dim_salesperson`
      
      
  using delta
      
      
      
      
      
      
      
      as
      with base as (
    select *
    from `ted_dev`.`db_silver`.`stg_sales_person_details`
),

final as (
    select
        sales_person_id,

        -- Nome completo com segurança contra campos nulos
        trim(
            concat_ws(' ',
                coalesce(first_name, ''),
                coalesce(middle_name, ''),
                coalesce(last_name, '')
            )
        ) as full_name,

        job_title,
        email_address,

        -- Limpeza de número de telefone (tirando hífens)
        regexp_replace(coalesce(phone_number, ''), '-', '') as phone_number,

        -- Garantindo que os valores numéricos estejam bem tratados
        cast(sales_quota as double) as sales_quota,
        cast(sales_ytd as double) as sales_ytd,
        cast(sales_last_year as double) as sales_last_year,

        territory_id,
        territory_group,

        -- Porcentagem da meta batida (com proteção contra divisão por zero ou nulls)
        case
            when sales_quota is not null and sales_quota > 0
                then round((sales_ytd / sales_quota) * 100, 2)
            else null
        end as percentual_meta_batida

    from base
)

select * from final
  