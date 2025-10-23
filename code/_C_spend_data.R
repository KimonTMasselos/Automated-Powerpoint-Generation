

spend_data <- function(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con, currency) {
  
  data <- data.frame()
  
  if (type == 'S') {
    
    eram_segment_id <- segment_id
    
    query <- qq(read_file("../queries/avg_spend_segment.sql"))
    
    dt <- dbGetQuery(con, query)
    
  } else {
    
    eram_category_id <- segment_id
    
    query <- qq(read_file("../queries/avg_spend_category.sql"))
    
    dt <- dbGetQuery(con, query)
    
  }
  
  dt <- dt %>%
    select(segment, level, avg_order_value, avg_order_units, avg_spend, avg_units)
  
  data <- rbind(data, dt) %>%
    arrange(level) %>%
    mutate(str_order_value = map_chr(avg_order_value, ~ num_format(., "currency", F, rounding = 0.01, symbol = currency)),
           str_order_units = map_chr(avg_order_units, ~ num_format(., "number", F)),
           str_spend = map_chr(avg_spend, ~ num_format(., "currency", F, rounding = 0.01, symbol = currency)),
           str_units = map_chr(avg_units, ~ num_format(., "number", F)))
  
  return(data)
  
}