with segment_products as (select products.id
from segments
inner join products on products.id = ANY(product_ids)
where segments.id = @{eram_segment_id}),

cat_pages as (select distinct path
from aggregated_page_position_metrics_@{eram_site_id} appm
inner join site_pages on site_pages.id = appm.site_page_id
inner join page_types on page_types.id = site_pages.page_type_id and (page_types.characterization = 'category' or page_types.characterization = 'brand')
where appm.site_id = @{eram_site_id} and appm.date between '@{date_start}' and '@{date_end}'
            AND appm.product_id in (select * from segment_products)),


pages as (select coalesce(site_pages.spiderman_page_title, site_pages.name) "page", site_pages.path, aspm.page_type, sum(sessions) "total_sessions"
from cat_pages 
inner join site_pages on site_pages.path = cat_pages.path and site_pages.path not ilike '%?%'
inner join aggregated_site_page_metrics_@{eram_site_id} aspm on aspm.site_page_id = site_pages.id
where aspm.date BETWEEN '@{date_start}' and '@{date_end}'
group by site_pages.spiderman_page_title, site_pages.name, site_pages.path, aspm.page_type),


tot_assortment as (select path, avg(share) as share
from (select site_pages.path, aspm.date, count(distinct aspm.product_id) filter (where aspm.brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id}) and aspm.product_id in (select * from segment_products)) /
    nullif(max(position) + 1, 1)::float as share
from cat_pages
inner join site_pages on site_pages.path = cat_pages.path and site_pages.path not ilike '%?%'
inner join aggregated_page_position_metrics_@{eram_site_id} aspm on aspm.site_page_id = site_pages.id
where aspm.date BETWEEN '@{date_start}' and '@{date_end}'
group by site_pages.path, aspm.date) a
group by path)


-- top as (select page, path, avg(top_5) as top_5
-- from (select site_pages.name "page", site_pages.path, aspm.date, count(distinct aspm.product_id) filter (where aspm.brand_id in (select brand_id from brands_company_accounts where company_account_id = @{eram_company_account_id}) and aspm.product_id in (select * from segment_products) and position < 5) / 5.0 as top_5
-- from cat_pages
-- inner join site_pages on site_pages.path = cat_pages.path and site_pages.path not ilike '%?%'
-- inner join aggregated_page_position_metrics_@{eram_site_id} aspm on aspm.site_page_id = site_pages.id
-- where aspm.date BETWEEN '@{date_start}' and '@{date_end}'
-- group by site_pages.name, site_pages.path, aspm.date) prods
-- group by page, path)



select segments.name as segment,
    case 
        when direct_navigation_page_title = 'spiderman_page_title_and_name' then 
            case when pages.page not in ('', '(not set)') then pages.page else reverse(split_part(reverse(pages.path), '/', 1)) end
        when direct_navigation_page_title = 'full_path' then
            pages.path
        when direct_navigation_page_title = 'path_last_part' then
            reverse(split_part(reverse(pages.path), '/', 1))
    end as page, 
    max(total_sessions) as sessions, max(tot_assortment.share) as soa
-- , max(top.top_5) as top_5
from pages
left join tot_assortment on tot_assortment.path = pages.path
-- left join top on top.path = pages.path
inner join segments on segments.id = @{eram_segment_id}
inner join sites on sites.id = @{eram_site_id}
where page_type = 'category'
group by segments.name, pages.page, pages.path, direct_navigation_page_title
order by sessions desc



































