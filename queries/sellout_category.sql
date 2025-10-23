WITH
metrics as (
    select
        sites.name as site,
        retailer_categories.name as segment,
        brands.name AS brand,
        sum(revenue) filter(where date between '@{date_start}' and '@{date_end}') as sales_value,
        sum(revenue) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as sales_value_ya,
        sum(quantity) filter(where date between '@{date_start}' and '@{date_end}') as units,
        sum(quantity) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as units_ya
    from (select * from aggregated_product_metrics_@{eram_site_id} @{source}) as pm
        left join sites on sites.id = pm.site_id
        left join brands on brands.id = pm.brand_id
        left join retailer_categories as rc on rc.id = pm.retailer_category_id
        inner join retailer_categories on retailer_categories.id = @{eram_category_id} 
    where 
        ((date between '@{date_start}' and '@{date_end}')
        or (date between '@{date_start_ya}' and '@{date_end_ya}'))
        and (pm.retailer_category_id = @{eram_category_id}
            or rc.ancestry ~* concat('\y', @{eram_category_id}, '\y'))
    group by site, segment, brand
),

category_metrics as (
    select
        sites.name as site,
        retailer_categories.name as segment,
        'Category' AS brand,
        sum(revenue) filter(where date between '@{date_start}' and '@{date_end}') as sales_value,
        sum(revenue) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as sales_value_ya,
        sum(quantity) filter(where date between '@{date_start}' and '@{date_end}') as units,
        sum(quantity) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as units_ya
    from (select * from aggregated_product_metrics_@{eram_site_id} @{source}) as pm
        left join sites on sites.id = pm.site_id
        left join brands on brands.id = pm.brand_id
        left join retailer_categories as rc on rc.id = pm.retailer_category_id
        inner join retailer_categories on retailer_categories.id = @{eram_category_id}
    where
        ((date between '@{date_start}' and '@{date_end}')
        or (date between '@{date_start_ya}' and '@{date_end_ya}'))
        and (pm.retailer_category_id = @{eram_category_id}
            or rc.ancestry ~* concat('\y', @{eram_category_id}, '\y'))
    group by site, segment
)

select site, segment, brand AS brand, sales_value, sales_value_ya, units, units_ya
from metrics

union

select site, segment, 'Category' AS brand, sales_value, sales_value_ya, units, units_ya
from category_metrics