

channels_data <- function(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con) {
  
  data <- data.frame()
  
  if (type == 'S') {
    
    eram_segment_id <- segment_id
    
    query <- qq(read_file("../queries/channels_segment.sql"))
    
    dt <- dbGetQuery(con, query)
    
  } else {
    
    eram_category_id <- segment_id
    
    query <- qq(read_file("../queries/channels_category.sql"))
    
    dt <- dbGetQuery(con, query)
    
  }
  
  dt <- dt %>%
    arrange(desc(perc)) %>%
    group_by(segment, level) %>%
    slice(1:5)
  
  data <- rbind(data, dt) %>% 
    mutate(channel = str_trunc(channel, 50, "center"))
  
  if (nrow(data) > 1) {
    
    data %>% 
      filter(level == 'company') %>%
      ungroup() %>%
      select(`Source Medium` = channel, `Distribution %` = perc) %>%
      gt() %>%
      fmt_percent(columns = `Distribution %`, decimals = 1, locale = "el") %>%
      cols_align(columns = `Source Medium`, align = "left") %>%
      cols_align(columns = c(`Distribution %`), align = "center") %>%
      cols_width(
        `Distribution %` ~ "25%"
      ) %>%
      tab_options(
        table.width = px(480),
        table.font.size = 11,   
        column_labels.font.size = 10,    
        column_labels.font.weight = "bold",
        column_labels.background.color = "#73D5FF",
        data_row.padding = px(5)
      )  %>%
      gtsave(filename = paste0("../output/", eram_company_account_id, "_", eram_site_id, "_", segment_id, "_08.png"), vwidth = 2000, zoom = 2)
    
    
    
    data %>% 
      filter(level == 'total') %>%
      ungroup() %>%
      select(`Source Medium` = channel, `Distribution %` = perc) %>%
      gt() %>%
      fmt_percent(columns = `Distribution %`, decimals = 1, locale = "el") %>%
      cols_align(columns = `Source Medium`, align = "left") %>%
      cols_align(columns = c(`Distribution %`), align = "center") %>%
      cols_width(
        `Distribution %` ~ "25%"
      ) %>%
      tab_options(
        table.width = px(480),
        table.font.size = 11,   
        column_labels.font.size = 10,    
        column_labels.font.weight = "bold",
        column_labels.background.color = "#2A438C",
        data_row.padding = px(5)
      )  %>%
      gtsave(filename = paste0("../output/", eram_company_account_id, "_", eram_site_id, "_", segment_id, "_09.png"), vwidth = 2000, zoom = 2)
    
  }
  
}