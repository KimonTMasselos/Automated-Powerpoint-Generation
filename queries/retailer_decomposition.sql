with categories as (
select distinct retailer_categories.id
from company_account_sites
inner join company_account_sites_retailer_categories on company_account_sites_retailer_categories.company_account_site_id = company_account_sites.id
inner join retailer_categories on retailer_categories.id = company_account_sites_retailer_categories.retailer_category_id
where company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}
),

ances as (
select 'something' a, concat('\y(', string_agg(id::varchar, '|'), ')\y') anc from categories group by a
)


(SELECT sites.name AS retailer,
		COALESCE(current.item_id, compare.item_id) as product_id,
       	brands.name as brand,
      	case when brands.id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id}) then TRUE else FALSE end as company_account,
       	products.name as product,
       	sum(current.revenue) AS value,
       	sum(current.quantity) AS units,
       	sum(compare.revenue) AS value_ya,
       	sum(compare.quantity) AS units_ya
FROM
  (SELECT SUM(revenue) AS revenue,
          SUM(quantity) AS quantity,
          item_id
   FROM
     (SELECT SUM(revenue) AS revenue,
             SUM(quantity) AS quantity,
             aggregated_product_metrics.product_id AS item_id
      FROM aggregated_product_metrics
      INNER JOIN products on products.id = aggregated_product_metrics.product_id
      WHERE aggregated_product_metrics.site_id = @{eram_site_id}
        AND aggregated_product_metrics.retailer_category_id IN (
            SELECT
                retailer_categories.id
            FROM
                retailer_categories
            WHERE (ancestry ~* (select anc from ances) or retailer_categories.id in (select * from categories)))
        AND aggregated_product_metrics.date BETWEEN '@{date_start}' and '@{date_end}'
      GROUP BY aggregated_product_metrics.product_id) product_sales
   GROUP BY item_id) current
FULL JOIN
  (SELECT SUM(revenue) AS revenue,
          SUM(quantity) AS quantity,
          item_id
   FROM
     (SELECT SUM(revenue) AS revenue,
             SUM(quantity) AS quantity,
             aggregated_product_metrics.product_id AS item_id
      FROM aggregated_product_metrics
      WHERE aggregated_product_metrics.site_id = @{eram_site_id}
        AND aggregated_product_metrics.retailer_category_id IN (
            SELECT
                retailer_categories.id
            FROM
                retailer_categories
            WHERE (ancestry ~* (select anc from ances) or retailer_categories.id in (select * from categories)))
        AND aggregated_product_metrics.date BETWEEN '@{date_start_ya}' and '@{date_end_ya}'
      GROUP BY item_id) product_sales
   GROUP BY item_id) compare ON compare.item_id = current.item_id
inner join sites on sites.id = @{eram_site_id}
inner join company_account_sites on company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}
inner join products on products.id = COALESCE(current.item_id, compare.item_id)
inner join brands on brands.id = products.brand_id
group by retailer, company_account_sites.plan, current.item_id, compare.item_id, brand, product, company_account)