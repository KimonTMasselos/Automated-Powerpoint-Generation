WITH
metrics as (
    select
        sites.name as site,
        retailer_categories.name as segment,
        brands.name AS brand,
        count(distinct basket_id) filter(where date between '@{date_start}' and '@{date_end}') as orders,
        count(distinct basket_id) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as orders_ya,
        count(distinct basket_id) filter(where date between '@{date_start}' and '@{date_end}' and from_analytics IS TRUE and omnichannel_source::text like 'eshop') as br_orders,
        count(distinct basket_id) filter(where date between '@{date_start_ya}' and '@{date_end_ya}' and from_analytics IS TRUE and omnichannel_source::text like 'eshop') as br_orders_ya
    from (select * from aggregated_basket_items_@{eram_site_id} @{source}) as pm
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
        count(distinct basket_id) filter(where date between '@{date_start}' and '@{date_end}') as orders,
        count(distinct basket_id) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as orders_ya,
        count(distinct basket_id) filter(where date between '@{date_start}' and '@{date_end}' and from_analytics IS TRUE and omnichannel_source::text like 'eshop') as br_orders,
        count(distinct basket_id) filter(where date between '@{date_start_ya}' and '@{date_end_ya}' and from_analytics IS TRUE and omnichannel_source::text like 'eshop') as br_orders_ya
    from (select * from aggregated_basket_items_@{eram_site_id} @{source}) as pm
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

select site, segment, brand AS brand, orders, orders_ya, br_orders, br_orders_ya
from metrics

union 

select site, segment, 'Category' AS brand, orders, orders_ya, br_orders, br_orders_ya
from category_metrics