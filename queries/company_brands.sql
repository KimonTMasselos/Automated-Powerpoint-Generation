SELECT brand_id, brands.name
FROM brands_company_accounts
left join brands on brands.id = brand_id
WHERE company_account_id = @{eram_company_account_id}