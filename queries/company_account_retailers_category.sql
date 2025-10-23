select distinct company_account_sites.site_id, plan, company_account_sites.company_data_only, competition_masking, sites.name as retailer, retailer_categories.id as segment_id, 'C' as type, sites.currency
from company_accounts
inner join company_account_sites on company_account_sites.company_account_id = company_accounts.id
inner join sites on sites.id = company_account_sites.site_id
inner join retailer_categories on retailer_categories.site_id = sites.id 
where company_accounts.id = @{eram_company_account_id} and retailer_categories.id in (@{eram_category_ids})