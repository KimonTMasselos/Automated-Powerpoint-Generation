with categories_1 as (
select distinct retailer_categories.id
from company_account_sites
inner join company_account_sites_retailer_categories on company_account_sites_retailer_categories.company_account_site_id = company_account_sites.id
inner join retailer_categories on retailer_categories.id = company_account_sites_retailer_categories.retailer_category_id
where company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}
),

ances_1 as (
select 'something' a, concat('\y(', string_agg(id::varchar, '|'), ')\y') "anc" from categories_1 group by a
)




(SELECT
    retailer_categories.name AS segment,
    'company' as level,
    sum(current.revenue) AS sales_value,
    sum(current.quantity) AS units,
    sum(current.revenue) / sum(baskets.orders) AS avg_spend,
    sum(current.quantity) / sum(baskets.orders) AS avg_units,
    sum(baskets.orders) AS orders,
    sum(avg_order_value) AS avg_order_value,
    sum(baskets.avg_order_units * baskets.orders) / sum(baskets.orders) AS avg_order_units
FROM (
    SELECT
        SUM(revenue) AS revenue,
        SUM(quantity) AS quantity,
        product_sales.omnichannel_source
    FROM (
        SELECT
            SUM(revenue) AS revenue,
            SUM(quantity) AS quantity,
            "aggregated_product_metrics_@{eram_site_id}"."retailer_category_id",
            omnichannel_source
        FROM (select * from "aggregated_product_metrics_@{eram_site_id}" @{source}) "aggregated_product_metrics_@{eram_site_id}"
        WHERE
            "aggregated_product_metrics_@{eram_site_id}"."site_id" = @{eram_site_id}
            AND "aggregated_product_metrics_@{eram_site_id}"."date" BETWEEN '@{date_start}' and '@{date_end}'
            
            and "aggregated_product_metrics_@{eram_site_id}".brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id})
            
                AND "aggregated_product_metrics_@{eram_site_id}"."retailer_category_id" IN (
                SELECT
                    "retailer_categories"."id"
                FROM
                    "retailer_categories"
                WHERE ("retailer_categories"."id" = @{eram_category_id}
                    OR ancestry ~* concat('\y(',@{eram_category_id},')\y')))
        GROUP BY
            "aggregated_product_metrics_@{eram_site_id}"."retailer_category_id",
            omnichannel_source) product_sales
        GROUP BY
            product_sales.omnichannel_source)
    CURRENT
    FULL OUTER JOIN (
    SELECT
        COUNT(DISTINCT aggregated_basket_metrics_@{eram_site_id}.basket_id) AS orders,
        COUNT(DISTINCT aggregated_basket_metrics_@{eram_site_id}.basket_id) FILTER (WHERE aggregated_basket_metrics_@{eram_site_id}.from_analytics IS TRUE) AS orders_for_buy_rate,
        AVG(aggregated_basket_metrics_@{eram_site_id}.revenue) AS avg_order_value,
        AVG(aggregated_basket_metrics_@{eram_site_id}.quantity) AS avg_order_units,
        aggregated_basket_metrics_@{eram_site_id}.omnichannel_source
    FROM (select * from aggregated_basket_metrics_@{eram_site_id} @{source}) aggregated_basket_metrics_@{eram_site_id}
    WHERE
        basket_id in (select distinct basket_id
                        from "aggregated_basket_items_@{eram_site_id}"
                        WHERE
                                "aggregated_basket_items_@{eram_site_id}"."site_id" = @{eram_site_id}
                                AND "aggregated_basket_items_@{eram_site_id}"."date" BETWEEN '@{date_start}' and '@{date_end}'
                                    and aggregated_basket_items_@{eram_site_id}.brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id})
                                    
                                        AND "aggregated_basket_items_@{eram_site_id}"."retailer_category_id" IN (
                                        SELECT
                                            "retailer_categories"."id"
                                        FROM
                                            "retailer_categories"
                                        WHERE ("retailer_categories"."id" = @{eram_category_id}
                                            OR ancestry ~* concat('\y(',@{eram_category_id},')\y')))
                                AND "aggregated_basket_items_@{eram_site_id}"."site_id" = @{eram_site_id})
    GROUP BY
        aggregated_basket_metrics_@{eram_site_id}.omnichannel_source)
        baskets ON baskets.omnichannel_source = current.omnichannel_source
    
        
INNER JOIN retailer_categories on retailer_categories.id = @{eram_category_id}
INNER JOIN sites on sites.id = @{eram_site_id}
INNER JOIN company_account_sites on company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}

group by sites.name,
    company_account_sites.plan,
    company_account_sites.competition_masking_sku,
    retailer_categories.name)
    
    
union


(SELECT
    retailer_categories.name AS segment,
    'total' as level,
    sum(current.revenue) AS sales_value,
    sum(current.quantity) AS units,
    sum(current.revenue) / sum(baskets.orders) AS avg_spend,
    sum(current.quantity) / sum(baskets.orders) AS avg_units,
    sum(baskets.orders) AS orders,
    sum(baskets.avg_order_value * baskets.orders) / sum(baskets.orders) AS avg_order_value,
    sum(baskets.avg_order_units * baskets.orders) / sum(baskets.orders) AS avg_order_units
FROM (
    SELECT
        SUM(revenue) AS revenue,
        SUM(quantity) AS quantity,
        product_sales.omnichannel_source
    FROM (
        SELECT
            SUM(revenue) AS revenue,
            SUM(quantity) AS quantity,
            "aggregated_product_metrics_@{eram_site_id}"."retailer_category_id",
            omnichannel_source
        FROM (select * from "aggregated_product_metrics_@{eram_site_id}" @{source}) "aggregated_product_metrics_@{eram_site_id}"
        WHERE
            "aggregated_product_metrics_@{eram_site_id}"."site_id" = @{eram_site_id}
            AND "aggregated_product_metrics_@{eram_site_id}"."date" BETWEEN '@{date_start}' and '@{date_end}'
            
                AND "aggregated_product_metrics_@{eram_site_id}"."retailer_category_id" IN (
                SELECT
                    "retailer_categories"."id"
                FROM
                    "retailer_categories"
                WHERE ("retailer_categories"."id" = @{eram_category_id}
                    OR ancestry ~* concat('\y(',@{eram_category_id},')\y')))
        GROUP BY
            "aggregated_product_metrics_@{eram_site_id}"."retailer_category_id",
            omnichannel_source) product_sales
        GROUP BY
            product_sales.omnichannel_source)
    CURRENT
    FULL OUTER JOIN (
    SELECT
        COUNT(DISTINCT aggregated_basket_metrics_@{eram_site_id}.basket_id) AS orders,
        COUNT(DISTINCT aggregated_basket_metrics_@{eram_site_id}.basket_id) FILTER (WHERE aggregated_basket_metrics_@{eram_site_id}.from_analytics IS TRUE) AS orders_for_buy_rate,
        AVG(aggregated_basket_metrics_@{eram_site_id}.revenue) AS avg_order_value,
        AVG(aggregated_basket_metrics_@{eram_site_id}.quantity) AS avg_order_units,
        aggregated_basket_metrics_@{eram_site_id}.omnichannel_source
    FROM (select * from aggregated_basket_metrics_@{eram_site_id} @{source}) aggregated_basket_metrics_@{eram_site_id}
    WHERE
        basket_id in (select distinct basket_id
                        from "aggregated_basket_items_@{eram_site_id}"
                        WHERE
                                "aggregated_basket_items_@{eram_site_id}"."site_id" = @{eram_site_id}
                                AND "aggregated_basket_items_@{eram_site_id}"."date" BETWEEN '@{date_start}' and '@{date_end}'
                                    
                                        AND "aggregated_basket_items_@{eram_site_id}"."retailer_category_id" IN (
                                        SELECT
                                            "retailer_categories"."id"
                                        FROM
                                            "retailer_categories"
                                        WHERE ("retailer_categories"."id" = @{eram_category_id}
                                            OR ancestry ~* concat('\y(',@{eram_category_id},')\y')))
                                AND "aggregated_basket_items_@{eram_site_id}"."site_id" = @{eram_site_id})
    GROUP BY
        aggregated_basket_metrics_@{eram_site_id}.omnichannel_source)
        baskets ON baskets.omnichannel_source = current.omnichannel_source
    
        
INNER JOIN retailer_categories on retailer_categories.id = @{eram_category_id}
INNER JOIN sites on sites.id = @{eram_site_id}
INNER JOIN company_account_sites on company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}
group by sites.name,
    company_account_sites.plan,
    company_account_sites.competition_masking_sku,
    retailer_categories.name)
    
