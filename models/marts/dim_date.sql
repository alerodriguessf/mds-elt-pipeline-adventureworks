{% set start_date = '2000-01-01' %}
{% set end_date = '2030-12-31' %}

with date_spine as (

    select
        sequence(to_date('{{ start_date }}'), to_date('{{ end_date }}'), interval 1 day) as date_array

),

exploded as (

    select explode(date_array) as date_day
    from date_spine

),

final as (

    select
        date_day,
        year(date_day) as year,
        month(date_day) as month,
        day(date_day) as day,
        quarter(date_day) as quarter,
        weekofyear(date_day) as week_of_year,
        dayofweek(date_day) as day_of_week,
        date_format(date_day, 'E') as day_name,
        case when dayofweek(date_day) IN (1, 7) then true else false end as is_weekend

    from exploded

)

select * from final
