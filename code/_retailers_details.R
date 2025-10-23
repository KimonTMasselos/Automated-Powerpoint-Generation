

eram_retailers <- function(eram_company_account_id, eram_category_ids, eram_segment_ids, con) {
  
  retailers <- data.frame()
  
  if (eram_category_ids != '') {
    
    query <- qq(read_file("../queries/company_account_retailers_category.sql"))
    retailers <- dbGetQuery(con, query)
    
  }
  
  if (eram_segment_ids != '') {
    
    query <- qq(read_file("../queries/company_account_retailers_segment.sql"))
    seg_rets <- dbGetQuery(con, query)
    
    retailers <- rbind(retailers, seg_rets)
    
  }
  
  return(retailers)
  
}