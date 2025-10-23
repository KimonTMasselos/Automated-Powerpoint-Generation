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
                    OR ancestry ~* concat('\y(',@{eram_category_id},')\y')))),
        
basks as (select count(distinct basket_id) as baskets
from basketss),


basketss_tot as (SELECT
        aggregated_basket_items_@{eram_site_id}.basket_id
    FROM
        (select *
        from aggregated_basket_items_@{eram_site_id} current
        @{source})
        "aggregated_basket_items_@{eram_site_id}"
    WHERE
        "aggregated_basket_items_@{eram_site_id}"."site_id" = @{eram_site_id}
        AND "aggregated_basket_items_@{eram_site_id}"."date" BETWEEN '@{date_start}' and '@{date_end}'
            
                AND "aggregated_basket_items_@{eram_site_id}"."retailer_category_id" IN (
                SELECT
                    "retailer_categories"."id"
                FROM
                    "retailer_categories"
                WHERE ("retailer_categories"."id" = @{eram_category_id}
                    OR ancestry ~* concat('\y(',@{eram_category_id},')\y')))),
        
basks_tot as (select count(distinct basket_id) as baskets
from basketss_tot)



(select ret.name as segment, 'company' as level, brands.id, brands.name as brands, count(distinct abi.basket_id) / (select baskets from basks limit 1)::float as brand_penetration
from basketss
inner join aggregated_basket_items_@{eram_site_id} abi on abi.basket_id = basketss.basket_id
inner join brands on brands.id = abi.brand_id
inner join retailer_categories ret on ret.id = @{eram_category_id}
group by segment, brands.id, brands.name)


union 


(select ret.name as segment, 'total' as level, brands.id, brands.name as brands, count(distinct abi.basket_id) / (select baskets from basks_tot limit 1)::float as brand_penetration
from basketss_tot
inner join aggregated_basket_items_@{eram_site_id} abi on abi.basket_id = basketss_tot.basket_id
inner join brands on brands.id = abi.brand_id
inner join retailer_categories ret on ret.id = @{eram_category_id}
group by segment, brands.id, brands.name)








