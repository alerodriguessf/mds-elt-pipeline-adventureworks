
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    ship_method_id as unique_field,
    count(*) as n_records

from `ted_dev`.`db_gold`.`dim_ship_method`
where ship_method_id is not null
group by ship_method_id
having count(*) > 1



  
  
      
    ) dbt_internal_test