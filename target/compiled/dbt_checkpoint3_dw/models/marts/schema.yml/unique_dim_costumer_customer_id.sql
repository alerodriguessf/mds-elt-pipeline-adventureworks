
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from `ted_dev`.`db_gold`.`dim_costumer`
where customer_id is not null
group by customer_id
having count(*) > 1


