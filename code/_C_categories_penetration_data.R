

category_penetration_data <- function(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con) {
  
  data <- data.frame()
  
  if (type == 'S') {
    
    eram_segment_id <- segment_id
    
    query <- qq(read_file("../queries/categories_penetration_segment.sql"))
    
    dt <- dbGetQuery(con, query)
    
  } else {
    
    eram_category_id <- segment_id
    
    query <- qq(read_file("../queries/categories_penetration_category.sql"))
    
    dt <- dbGetQuery(con, query)
    
  }
  
  dt <- dt %>%
    filter(cat_penetration != 1) %>%
    arrange(desc(cat_penetration)) %>%
    group_by(segment, level) %>%
    slice(1:5) %>%
    select(-id)
  
  
  data <- rbind(data, dt) %>% 
    mutate(category = str_trunc(category, 55, "center"))
  
  data %>% 
    filter(level == 'company') %>%
    ungroup() %>%
    select(`Category` = category, `Basket Penetration` = cat_penetration) %>%
    gt() %>%
    fmt_percent(columns = `Basket Penetration`, decimals = 1, locale = "el") %>%
    cols_align(columns = `Category`, align = "left") %>%
    cols_align(columns = c(`Basket Penetration`), align = "center") %>%
    cols_width(
      `Basket Penetration` ~ "25%"
    ) %>%
    tab_options(
      table.width = px(480),
      table.font.size = 11,   
      column_labels.font.size = 10,    
      column_labels.font.weight = "bold",
      column_labels.background.color = "#73D5FF",
      data_row.padding = px(5)
    )  %>%
    gtsave(filename = paste0("../output/", eram_company_account_id, "_", eram_site_id, "_", segment_id, "_06.png"), vwidth = 2000, zoom = 2)
  
  
  
  data %>% 
    filter(level == 'total') %>%
    ungroup() %>%
    select(`Category` = category, `Basket Penetration` = cat_penetration) %>%
    gt() %>%
    fmt_percent(columns = `Basket Penetration`, decimals = 1, locale = "el") %>%
    cols_align(columns = `Category`, align = "left") %>%
    cols_align(columns = c(`Basket Penetration`), align = "center") %>%
    cols_width(
      `Basket Penetration` ~ "25%"
    ) %>%
    tab_options(
      table.width = px(480),
      table.font.size = 11,   
      column_labels.font.size = 10,    
      column_labels.font.weight = "bold",
      column_labels.background.color = "#2A438C",
      data_row.padding = px(5)
    )  %>%
    gtsave(filename = paste0("../output/", eram_company_account_id, "_", eram_site_id, "_", segment_id, "_07.png"), vwidth = 2000, zoom = 2)
  
}