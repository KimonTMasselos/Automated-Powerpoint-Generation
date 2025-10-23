with categories_1 as (
select distinct retailer_categories.id
from company_account_sites
inner join company_account_sites_retailer_categories on company_account_sites_retailer_categories.company_account_site_id = company_account_sites.id
inner join retailer_categories on retailer_categories.id = company_account_sites_retailer_categories.retailer_category_id
where company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}
),

ances_1 as (
select 'something' a, concat('\y(', string_agg(id::varchar, '|'), ')\y') "anc" from categories_1 group by a
),


basketss as (SELECT
        aggregated_basket_items_@{eram_site_id}.basket_id
    FROM
        (select *
        from aggregated_basket_items_@{eram_site_id} current
	@{source})
        "aggregated_basket_items_@{eram_site_id}"
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
                    OR ancestry ~* concat('\y(',@{eram_category_id},')\y'))))



select retailer_categories.name as segment, abi.basket_id, abi.product_id, 
    case when spiderman_enrichment = TRUE then
        case when site_product_name is not null then site_product_name else products.name end
    else 
        products.name
    end as product,
	case when abi.retailer_category_id = @{eram_category_id} then TRUE else FALSE end as category_product
from basketss
inner join aggregated_basket_items_@{eram_site_id} abi on abi.basket_id = basketss.basket_id
inner join products on products.id = abi.product_id
inner join retailer_categories on retailer_categories.id = @{eram_category_id}
inner join sites on sites.id = @{eram_site_id}
where abi.brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id})










