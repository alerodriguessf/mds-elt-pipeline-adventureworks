
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    email_address as unique_field,
    count(*) as n_records

from `ted_dev`.`db_gold`.`dim_salesperson`
where email_address is not null
group by email_address
having count(*) > 1



  
  
      
    ) dbt_internal_test