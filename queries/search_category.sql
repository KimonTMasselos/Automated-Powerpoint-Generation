with sear_terms as (select distinct search_terms.id, search_terms.name
from aggregated_search_term_position_metrics_@{eram_site_id} astpm 
inner join search_terms on search_terms.id = astpm.search_term_id and (search_terms.search_type != 'irrelevant' or search_terms.search_type is null)
where astpm.site_id = @{eram_site_id} and astpm.date between '@{date_start}' and '@{date_end}'
            AND astpm.retailer_category_id = @{eram_category_id}),

cats as (
    select distinct id
    from retailer_categories
    where (id = @{eram_category_id} or ancestry ~* concat('\y', @{eram_category_id}, '\y')) and site_id = @{eram_site_id}
),


tot_sessions as (select sear_terms.id, sear_terms.name as search_term, sum(sessions) as total_sessions
from sear_terms
inner join aggregated_search_term_metrics_@{eram_site_id} astm on astm.search_term_id = sear_terms.id
where astm.site_id = @{eram_site_id} and astm.date between '@{date_start}' and '@{date_end}'
group by sear_terms.id, sear_terms.name),


tot_assortment as (select id, search_term, avg(share) as share
from (select sear_terms.id, sear_terms.name "search_term", astpm.date, count(distinct astpm.product_id) filter (where astpm.brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id}) and astpm.retailer_category_id in (select * from cats)) /
    nullif(max(position) + 1, 1)::float as share
from sear_terms
inner join aggregated_search_term_position_metrics_@{eram_site_id} astpm on astpm.search_term_id = sear_terms.id
where astpm.date BETWEEN '@{date_start}' and '@{date_end}'
group by sear_terms.id, sear_terms.name, astpm.date) a
group by id, search_term)

-- top as (select id, search_term, avg(top_5) as top_5
-- from (select sear_terms.id, sear_terms.name "search_term", astpm.date, count(distinct astpm.product_id) filter (where astpm.brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id}) and astpm.retailer_category_id in (select * from cats) and position < 5) / 5.0 as top_5
-- from sear_terms
-- inner join aggregated_search_term_position_metrics_@{eram_site_id} astpm on astpm.search_term_id = sear_terms.id
-- where astpm.date BETWEEN '@{date_start}' and '@{date_end}'
-- group by sear_terms.id, sear_terms.name, astpm.date) prods
-- group by id, search_term)


select retailer_categories.name as segment, tot_sessions.search_term, total_sessions as sessions, share as soa
-- , top_5
from tot_sessions
left join tot_assortment on tot_assortment.id = tot_sessions.id
-- left join top on top.id = tot_sessions.id
inner join retailer_categories on retailer_categories.id = @{eram_category_id}
order by sessions desc











