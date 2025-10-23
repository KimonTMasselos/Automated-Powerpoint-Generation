with segment_products as (select products.id
from segments
inner join products on products.id = ANY(product_ids)
where segments.id = @{eram_segment_id}),

categories_1 as (
select distinct retailer_categories.id
from company_account_sites
inner join company_account_sites_retailer_categories on company_account_sites_retailer_categories.company_account_site_id = company_account_sites.id
inner join retailer_categories on retailer_categories.id = company_account_sites_retailer_categories.retailer_category_id
where company_account_sites.site_id = @{eram_site_id} and company_account_sites.company_account_id = @{eram_company_account_id}
),

ances_1 as (
select 'something' a, concat('\y(', string_agg(id::varchar, '|'), ')\y') "anc" from categories_1 group by a
),

comp_categories as (
select distinct retailer_category_id
from aggregated_product_metrics_@{eram_site_id} apm 
where date between '@{date_start}' and '@{date_end}' and brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id})
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
        and aggregated_basket_items_@{eram_site_id}.product_id in (select * from segment_products)
            and aggregated_basket_items_@{eram_site_id}.brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id})
            
                AND "aggregated_basket_items_@{eram_site_id}"."retailer_category_id" IN (
                    SELECT
                        "retailer_categories"."id"
                    FROM
                        "retailer_categories"
                    WHERE ("retailer_categories"."id" IN (select * from categories_1)
                        OR ancestry ~* (select anc from ances_1))))



select ret.name as segment, abi.basket_id, abi.retailer_category_id as category_id, retailer_categories.name as category, abi.brand_id, brands.name as brand, 
        case when abi.brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id}) then TRUE else FALSE end as company_brand
from basketss
inner join aggregated_basket_items_@{eram_site_id} abi on abi.basket_id = basketss.basket_id
inner join brands on brands.id = abi.brand_id
inner join retailer_categories on retailer_categories.id = abi.retailer_category_id
inner join segments ret on ret.id = @{eram_segment_id}
where abi.retailer_category_id in (select * from comp_categories)









