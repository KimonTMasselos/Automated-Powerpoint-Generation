

search_data <- function(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con) {
  
  data <- data.frame()
  
  if (type == 'S') {
    
    eram_segment_id <- segment_id
    
    query <- qq(read_file("../queries/search_segment.sql"))
    
    dt <- dbGetQuery(con, query)
    
  } else {
    
    eram_category_id <- segment_id
    
    query <- qq(read_file("../queries/search_category.sql"))
    
    dt <- dbGetQuery(con, query)
    
  }
  
  ses <- sum(dt$sessions, na.rm = T)
  
  dt <- dt %>%
    filter(nchar(search_term) > 2)
  
  dt <- head(dt, 10)
  
  if (nrow(dt) > 0) {
    
    data <- rbind(data, dt) %>% 
      mutate(sessions = as.numeric(sessions),
             search_term = str_trunc(search_term, 100, "right"))
    
    data %>% 
      select(`Search Term` = search_term, `Pageviews` = sessions, `Share of Assortment` = soa) %>%
      gt() %>%
      fmt_integer(columns = `Pageviews`, locale = "el") %>%
      fmt_percent(columns = `Share of Assortment`, decimals = 1, locale = "el") %>%
      cols_align(columns = `Search Term`, align = "left") %>%
      cols_align(columns = c(`Pageviews`, `Share of Assortment`), align = "center") %>%
      cols_width(
        `Pageviews` ~ "15%",
        `Share of Assortment` ~ "15%"
      ) %>%
      data_color(
        columns = `Share of Assortment`,
        method = "numeric",
        palette = c("white", "#73D5FF"),
        domain = c(0, max(data$soa))
      ) %>% 
      tab_options(
        table.width = px(480),
        table.font.size = 10,   
        column_labels.font.size = 10,    
        column_labels.font.weight = "bold",
        data_row.padding = px(5)  
      ) %>%
      gtsave(filename = paste0("../output/", eram_company_account_id, "_", eram_site_id, "_", segment_id, "_05.png"), vwidth = 2000, zoom = 2)
    
    return(ses)
    
  }
  
  
  
}