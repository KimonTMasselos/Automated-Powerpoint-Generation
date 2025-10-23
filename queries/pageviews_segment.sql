with
categories_1 as (
  select distinct retailer_categories.id
  from company_account_sites
  inner join company_account_sites_retailer_categories on company_account_sites_retailer_categories.company_account_site_id = company_account_sites.id
  inner join retailer_categories on retailer_categories.id = company_account_sites_retailer_categories.retailer_category_id
  where company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}
),

ances_1 as (
  select 'something' a, concat('\y(', string_agg(id::varchar, '|'), ')\y') anc from categories_1 group by a
),

prs as (
        SELECT DISTINCT segment, product_id FROM (
        SELECT name as segment, unnest(product_ids) AS product_id
        FROM segments
        WHERE segments.id IN (@{eram_segment_id})
    ) as ids
),

cats as (
  select products.retailer_category_id
  from segments
  inner join products on products.id = ANY(product_ids)
  where 
    segments.id = @{eram_segment_id} and
    products.retailer_category_id IN (
                    SELECT
                        retailer_categories.id
                    FROM
                        retailer_categories
                    WHERE (retailer_categories.id IN (select * from categories_1)
                        OR ancestry ~* (select anc from ances_1)))
),

current as (
    SELECT
      site,
      segment,
      product_pageviews.omnichannel_source,
      brand_id,
      brands.name as brand,
      COALESCE(SUM(consolidated_product_sessions), 0) + COALESCE(SUM(category_sessions), 0) AS sessions
    FROM (
            SELECT
                sites.name as site,
                segment,
                retailer_category_id,
                omnichannel_source,
                pm.brand_id,
                SUM(consolidated_product_sessions) AS consolidated_product_sessions
            FROM aggregated_product_pageview_metrics_@{eram_site_id} as pm
            inner join prs on prs.product_id = pm.product_id
            left join sites on sites.id = pm.site_id
            WHERE
              pm.date BETWEEN '@{date_start}' and '@{date_end}'
            GROUP BY
              site, segment,
              pm.retailer_category_id,
              omnichannel_source,
              pm.brand_id) AS product_pageviews
    LEFT JOIN (
        SELECT
            retailer_category_id,
            SUM(sessions) AS category_sessions,
            omnichannel_source
        FROM
            aggregated_site_page_metrics_@{eram_site_id}
        WHERE
            aggregated_site_page_metrics_@{eram_site_id}.site_id = @{eram_site_id}
            AND aggregated_site_page_metrics_@{eram_site_id}.date BETWEEN '@{date_start}' and '@{date_end}'
            AND aggregated_site_page_metrics_@{eram_site_id}.retailer_category_id IN (select * from cats)
            GROUP BY
                aggregated_site_page_metrics_@{eram_site_id}.retailer_category_id, omnichannel_source)
                category_pageviews ON category_pageviews.retailer_category_id = product_pageviews.retailer_category_id and category_pageviews.omnichannel_source = product_pageviews.omnichannel_source
    inner join brands on brands.id = brand_id
        GROUP BY
            site, segment,
            product_pageviews.omnichannel_source,
            brands.name,
            brand_id),

current_cat as (
    SELECT
      site,
      segment,
      product_pageviews.omnichannel_source,
      COALESCE(SUM(consolidated_product_sessions), 0) + COALESCE(SUM(category_sessions), 0) AS sessions
    FROM (
            SELECT
                sites.name as site,
                segment,
                retailer_category_id,
                omnichannel_source,
                SUM(consolidated_product_sessions) AS consolidated_product_sessions
            FROM aggregated_product_pageview_metrics_@{eram_site_id} as pm
            inner join prs on prs.product_id = pm.product_id
            left join sites on sites.id = pm.site_id
            WHERE
              pm.date BETWEEN '@{date_start}' and '@{date_end}'
            GROUP BY
              site, segment,
              pm.retailer_category_id,
              omnichannel_source) AS product_pageviews
    LEFT JOIN (
        SELECT
            retailer_category_id,
            SUM(sessions) AS category_sessions,
            omnichannel_source
        FROM
            aggregated_site_page_metrics_@{eram_site_id}
        WHERE
            aggregated_site_page_metrics_@{eram_site_id}.site_id = @{eram_site_id}
            AND aggregated_site_page_metrics_@{eram_site_id}.date BETWEEN '@{date_start}' and '@{date_end}'
            AND aggregated_site_page_metrics_@{eram_site_id}.retailer_category_id IN (select * from cats)
            GROUP BY
                aggregated_site_page_metrics_@{eram_site_id}.retailer_category_id, omnichannel_source)
                category_pageviews ON category_pageviews.retailer_category_id = product_pageviews.retailer_category_id and category_pageviews.omnichannel_source = product_pageviews.omnichannel_source
        GROUP BY
            site, segment,
            product_pageviews.omnichannel_source),

compare as (
        SELECT
            site,
            segment,
            product_pageviews.omnichannel_source,
            brand_id,
            brands.name as brand,
            COALESCE(SUM(consolidated_product_sessions), 0) + COALESCE(SUM(category_sessions), 0) AS sessions
        FROM (
            SELECT
                sites.name as site,
                segment,
                retailer_category_id,
                omnichannel_source,
                pm.brand_id,
                SUM(consolidated_product_sessions) AS consolidated_product_sessions
            FROM
                aggregated_product_pageview_metrics_@{eram_site_id} as pm
            inner join prs on prs.product_id = pm.product_id
            left join sites on sites.id = pm.site_id
        WHERE
            pm.date BETWEEN '@{date_start_ya}' and '@{date_end_ya}'
        GROUP BY
            site, segment,
            pm.retailer_category_id,
            omnichannel_source,
            pm.brand_id) AS product_pageviews
    LEFT JOIN (
        SELECT
            retailer_category_id,
            SUM(sessions) AS category_sessions,
            omnichannel_source
        FROM
            aggregated_site_page_metrics_@{eram_site_id}
        WHERE
            aggregated_site_page_metrics_@{eram_site_id}.site_id = @{eram_site_id}
            AND aggregated_site_page_metrics_@{eram_site_id}.date BETWEEN '@{date_start_ya}' and '@{date_end_ya}'
            AND aggregated_site_page_metrics_@{eram_site_id}.retailer_category_id IN (select * from cats)
            GROUP BY
                aggregated_site_page_metrics_@{eram_site_id}.retailer_category_id, omnichannel_source)
                category_pageviews ON category_pageviews.retailer_category_id = product_pageviews.retailer_category_id and category_pageviews.omnichannel_source = product_pageviews.omnichannel_source
    inner join brands on brands.id = brand_id
        GROUP BY
            site, segment,
            product_pageviews.omnichannel_source,
            brands.name,
            brand_id),

compare_cat as (
        SELECT
            site,
            segment,
            product_pageviews.omnichannel_source,
            COALESCE(SUM(consolidated_product_sessions), 0) + COALESCE(SUM(category_sessions), 0) AS sessions
        FROM (
            SELECT
                sites.name as site,
                segment,
                retailer_category_id,
                omnichannel_source,
                SUM(consolidated_product_sessions) AS consolidated_product_sessions
            FROM
                aggregated_product_pageview_metrics_@{eram_site_id} as pm
            inner join prs on prs.product_id = pm.product_id
            left join sites on sites.id = pm.site_id
        WHERE
            pm.date BETWEEN '@{date_start_ya}' and '@{date_end_ya}'
        GROUP BY
            site, segment,
            pm.retailer_category_id,
            omnichannel_source) AS product_pageviews
    LEFT JOIN (
        SELECT
            retailer_category_id,
            SUM(sessions) AS category_sessions,
            omnichannel_source
        FROM
            aggregated_site_page_metrics_@{eram_site_id}
        WHERE
            aggregated_site_page_metrics_@{eram_site_id}.site_id = @{eram_site_id}
            AND aggregated_site_page_metrics_@{eram_site_id}.date BETWEEN '@{date_start_ya}' and '@{date_end_ya}'
            AND aggregated_site_page_metrics_@{eram_site_id}.retailer_category_id IN (select * from cats)
            GROUP BY
                aggregated_site_page_metrics_@{eram_site_id}.retailer_category_id, omnichannel_source)
                category_pageviews ON category_pageviews.retailer_category_id = product_pageviews.retailer_category_id and category_pageviews.omnichannel_source = product_pageviews.omnichannel_source
        GROUP BY
            site, segment,
            product_pageviews.omnichannel_source)

select
  current.site,
  current.segment,
  current.brand, 
  sum(current.sessions) as pageviews,
  sum(compare.sessions) as pageviews_ya
from current
left join compare on compare.brand_id = current.brand_id and current.omnichannel_source = compare.omnichannel_source
group by current.site, current.segment, current.brand

UNION

select
  current_cat.site,
  current_cat.segment,
  'Category' as brand, 
  sum(current_cat.sessions) as pageviews,
  sum(compare_cat.sessions) as pageviews_ya
from current_cat
left join compare_cat on current_cat.omnichannel_source = compare_cat.omnichannel_source
group by current_cat.site, current_cat.segment, brand