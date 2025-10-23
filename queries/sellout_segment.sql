with categories as (
select distinct retailer_categories.id
from company_account_sites
inner join company_account_sites_retailer_categories on company_account_sites_retailer_categories.company_account_site_id = company_account_sites.id
inner join retailer_categories on retailer_categories.id = company_account_sites_retailer_categories.retailer_category_id
where company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}
),

ances as (
select 'something' a, concat('\y(', string_agg(id::varchar, '|'), ')\y') "anc" from categories group by a
),

prods as (
    SELECT DISTINCT segment, product_id 
    FROM (
        SELECT name as segment, unnest(product_ids) AS product_id
        FROM segments
        WHERE segments.id IN (@{eram_segment_id})
    ) as ids
    inner join products on products.id = product_id
    inner join retailer_categories on retailer_categories.id = products.retailer_category_id
    where ("retailer_categories"."id" in (select * from categories)
                    or ancestry ~* (select anc from ances))
),

metrics as (
    select
        sites.name as site,
        prods.segment,
        brands.name AS brand,
        sum(revenue) filter(where date between '@{date_start}' and '@{date_end}') as sales_value,
        sum(revenue) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as sales_value_ya,
        sum(quantity) filter(where date between '@{date_start}' and '@{date_end}') as units,
        sum(quantity) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as units_ya
    from (select * from aggregated_product_metrics_@{eram_site_id} @{source}) as pm
        inner join prods on prods.product_id = pm.product_id
        left join sites on sites.id = pm.site_id
        left join brands on brands.id = pm.brand_id
    where
        site_id = @{eram_site_id}
        and (date between '@{date_start}' and '@{date_end}' or date between '@{date_start_ya}' and '@{date_end_ya}')
    group by site, segment, brand
),

category_metrics as (
    select
        sites.name as site,
        prods.segment,
        'Category' AS brand,
        sum(revenue) filter(where date between '@{date_start}' and '@{date_end}') as sales_value,
        sum(revenue) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as sales_value_ya,
        sum(quantity) filter(where date between '@{date_start}' and '@{date_end}') as units,
        sum(quantity) filter(where date between '@{date_start_ya}' and '@{date_end_ya}') as units_ya
    from (select * from aggregated_product_metrics_@{eram_site_id} @{source}) as pm
        inner join prods on prods.product_id = pm.product_id
        left join sites on sites.id = pm.site_id
        left join brands on brands.id = pm.brand_id
    where
        site_id = @{eram_site_id}
        and (date between '@{date_start}' and '@{date_end}' or date between '@{date_start_ya}' and '@{date_end_ya}')
    group by site, segment
)

select site, segment, brand AS brand, sales_value, sales_value_ya, units, units_ya
from metrics

union

select site, segment, 'Category' AS brand, sales_value, sales_value_ya, units, units_ya
from category_metrics