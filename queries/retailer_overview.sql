with cats as (
  select distinct retailer_categories.id
  from company_account_sites
    inner join company_account_sites_retailer_categories on company_account_sites_retailer_categories.company_account_site_id = company_account_sites.id
    inner join retailer_categories on retailer_categories.id = company_account_sites_retailer_categories.retailer_category_id
  where company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}
),

ances as (
  select 'regex' as a, concat('\y(', string_agg(id::varchar, '|'), ')\y') as anc
  from cats
  group by a
),

com_cats as (
    SELECT distinct id, name, analytics_hierarchy
    FROM retailer_categories
    WHERE
        id IN (select * from cats)
        OR ancestry ~* (select anc from ances)
),

com_brands as (
    SELECT brand_id
    FROM brands_company_accounts
    WHERE company_account_id = @{eram_company_account_id}
),

rev as (
  SELECT
    case
      when date BETWEEN '@{date_start}' and '@{date_end}' then 'c'
      else 'p'
    end as period,
    extract('month' from date) as month,
    site_id,
    sum(revenue) AS ttl_sales_value,
    sum(quantity) as ttl_units,
    sum(revenue) filter(where brand_id in (SELECT brand_id FROM com_brands)) AS com_sales_value,
    sum(quantity) filter(where brand_id in (SELECT brand_id FROM com_brands)) as com_units
  FROM (select * from aggregated_product_metrics_@{eram_site_id} @{source}) as pm
      INNER JOIN com_cats on com_cats.id = pm.retailer_category_id
  WHERE
    date BETWEEN '@{date_start}' and '@{date_end}'
    OR date BETWEEN '@{date_start_ya}' and '@{date_end_ya}'
  GROUP BY
    period,
    month,
    site_id
),

ord as (
  SELECT
    case
      when date BETWEEN '@{date_start}' and '@{date_end}' then 'c'
      else 'p'
    end as period,
    extract('month' from date) as month,
    site_id,
    count(distinct basket_id) AS ttl_orders,
    count(distinct basket_id) filter(where brand_id in (SELECT brand_id FROM com_brands)) AS com_orders
  FROM (select * from aggregated_basket_items_@{eram_site_id} @{source}) as bi
      INNER JOIN com_cats on com_cats.id = bi.retailer_category_id
  WHERE
    date BETWEEN '@{date_start}' and '@{date_end}'
    OR date BETWEEN '@{date_start_ya}' and '@{date_end_ya}'
  GROUP BY
    period,
    month,
    site_id
)

SELECT
  rev.period,
  rev.month,
  sites.name as retailer,
  ttl_sales_value,
  ttl_units,
  ttl_orders,
  com_sales_value,
  com_units,
  com_orders
from rev
  left join ord on ord.period = rev.period and ord.month = rev.month and ord.site_id = rev.site_id
  left join sites on sites.id = rev.site_id