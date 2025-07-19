
    
    

select
    (year_month, territory_id, is_online_order) as unique_field,
    count(*) as n_records

from `ted_dev`.`db_gold`.`fact_sales_summary_monthly`
where (year_month, territory_id, is_online_order) is not null
group by (year_month, territory_id, is_online_order)
having count(*) > 1


