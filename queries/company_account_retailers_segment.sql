select distinct company_account_sites.site_id, plan, company_account_sites.company_data_only, competition_masking, sites.name as retailer, segments.id as segment_id, 'S' as type, sites.currency
from company_accounts
inner join company_account_sites on company_account_sites.company_account_id = company_accounts.id
inner join sites on sites.id = company_account_sites.site_id
inner join segments on segments.company_account_site_id = company_account_sites.id 
where company_accounts.id = @{eram_company_account_id} and segments.id in (@{eram_segment_ids})