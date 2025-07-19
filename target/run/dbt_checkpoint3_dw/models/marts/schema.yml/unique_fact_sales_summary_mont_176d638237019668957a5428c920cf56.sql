
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    (year_month, territory_id, is_online_order) as unique_field,
    count(*) as n_records

from `ted_dev`.`db_gold`.`fact_sales_summary_monthly`
where (year_month, territory_id, is_online_order) is not null
group by (year_month, territory_id, is_online_order)
having count(*) > 1



  
  
      
    ) dbt_internal_test