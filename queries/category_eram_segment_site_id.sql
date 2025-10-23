select distinct site_id
from segments
inner join company_account_sites on company_account_sites.id = segments.company_account_site_id
where segments.id = @{eram_segment_id}