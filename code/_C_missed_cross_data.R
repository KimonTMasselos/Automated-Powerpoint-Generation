

missed_cross_data <- function(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con) {
  
  data <- data.frame()
  
  if (type == 'S') {
    
    eram_segment_id <- segment_id
    
    query <- qq(read_file("../queries/missed_cross_segment.sql"))
    
    dt <- dbGetQuery(con, query) %>%
      distinct()
    
  } else {
    
    eram_category_id <- segment_id
    
    query <- qq(read_file("../queries/missed_cross_category.sql"))
    
    dt <- dbGetQuery(con, query) %>%
      distinct()
    
  }
  
  dt <- dt  %>%
    mutate(total_baskets = n_distinct(basket_id)) %>%
    filter(segment != category) 
  
  total_cats <- dt %>%
    group_by(segment, category_id, category) %>%
    summarize(total_count = n_distinct(basket_id))
  
  cats <- dt %>%
    group_by(segment, basket_id, category_id, category) %>%
    summarize(company_brand = max(company_brand)) %>%
    ungroup() 
  
  unique_combs <- unique(paste(cats$category, cats$company_brand))
  
  if (length(unique_combs) >= 6) {
    
    cats <- cats %>%
      filter(company_brand == 0) %>%
      group_by(segment, category_id, category) %>%
      summarize(count = n_distinct(basket_id)) %>%
      merge(total_cats, by = c('segment', 'category_id', 'category')) %>%
      mutate(freq = count / total_count,
             item = category) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      filter(category != 'Not For Sale') %>%
      head(3) %>%
      select(segment, category_id, category, item, count, freq, total_count) %>%
      mutate(order = seq.int(nrow(.)))
    
    brands <- dt %>%
      filter(company_brand == FALSE) %>%
      group_by(segment, category_id, category, brand) %>%
      summarize(count = n_distinct(basket_id)) %>%
      slice_max(order_by = count, n = 3, with_ties = FALSE) %>%
      ungroup() 
    
    colnames(brands) <- c('segment', 'category_id', 'category', 'item', 'count')
    
    brands <- brands %>%
      merge(cats, by = c('segment', 'category_id', 'category'), suffixes = c('', '_cat')) %>%
      mutate(freq = count / total_count,
             item = paste0(item, " ")) %>%
      select(segment, category_id, category, item, count, freq, order)
    
    final <- rbind(select(cats, -total_count), brands) %>%
      arrange(order, desc(count)) %>%
      select(-category_id, -order)
    
    data <- rbind(data, final) %>% 
      mutate(item = str_trunc(item, 100, "center"),
             count = as.numeric(count))
    
    categories <- unique(data$category)
    
    if (length(categories) >= 3) {
      
      for (cat in categories) {
        
        temp <- data %>% 
          ungroup() %>%
          filter(category == cat) %>%
          distinct() %>%
          filter(item != category)
        
        temp %>%
          select(`Brand` = item, `Baskets` = count, `Frequency` = freq) %>%
          gt() %>%
          fmt_integer(columns = `Baskets`, locale = "el") %>%
          fmt_percent(columns = `Frequency`, decimals = 1, locale = "el") %>%
          cols_align(columns = `Brand`, align = "left") %>%
          cols_align(columns = c(`Baskets`, `Frequency`), align = "center") %>%
          cols_width(
            `Frequency` ~ "22.5%",
            `Baskets` ~ "22.5%"
          ) %>%
          data_color(
            columns = `Frequency`,
            method = "numeric",
            palette = c("white", "#2A438C"),
            domain = c(0, max(temp$freq))
          ) %>% 
          tab_options(
            table.width = px(250),
            table.font.size = 11,   
            column_labels.font.size = 10,    
            column_labels.font.weight = "bold"
          )  %>%
          gtsave(filename = paste0("../output/", eram_company_account_id, "_", eram_site_id, "_", segment_id, "_1", which(categories == cat), ".png"), vwidth = 2000, zoom = 2)
        
      }
      
      cats <- cats %>%
        select(-total_count) %>%
        mutate(str_freq = map_chr(freq, ~ num_format(., "percentage", F, rounding = 1)))
      
      return(cats)
      
    }
    
    
    
  }
  
  
  
}