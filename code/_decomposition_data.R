

decomposition_data <- function(con_eram, eram_company_account_id, date_start, date_end, date_start_ya, date_end_ya, rets) {
  
  dt_deco <- NULL
  
  unique_ret <- unique(rets$site_id)
  
  for(r in 1:length(unique_ret)) {
    eram_site_id <- unique_ret[r]
    deco_q <- qq(read_file("../queries/retailer_decomposition.sql"))
    deco <- dbGetQuery(con_eram, deco_q)
    dt_deco <- bind_rows(dt_deco, deco) 
  }
  
  return(dt_deco)
  
}