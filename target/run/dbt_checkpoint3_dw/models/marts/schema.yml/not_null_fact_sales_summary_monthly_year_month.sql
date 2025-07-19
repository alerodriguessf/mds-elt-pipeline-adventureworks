
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select year_month
from `ted_dev`.`db_gold`.`fact_sales_summary_monthly`
where year_month is null



  
  
      
    ) dbt_internal_test