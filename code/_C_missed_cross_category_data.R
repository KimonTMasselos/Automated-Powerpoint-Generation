library(tidyverse)  #--> data manipulation and visualization
library(lubridate)  #--> dates manipulation
library(sjmisc)     #--> ???
library(DBI)        #--> connect to databases
library(RPostgres)  #--> connect to PostgreSQL DB
library(rstudioapi) #--> ask users for inputs
library(GetoptLong) #--> for variable interpolation
library(readxl)     #--> for read_excel function
library(arules)
library(gt)
library(webshot2)

eram_categories <- as.integer(unlist(strsplit(eram_category_ids, ",")))

data <- data.frame()


for (i in 1:length(eram_categories)) {
  
  eram_category_id <- eram_categories[i]
  
  # Connect to eRAM Local App database
  con <- dbConnect(Postgres(),
                   dbname = "marketplace_production",
                   host = "35.187.66.46",
                   port = 5432,
                   user = "mplace_user",
                   password = read_file("_eram_local_db_pass.txt")
  )
  
  
  query <- qq(read_file("../queries/category_eram_category_site_id.sql"))
  
  
  # Get Products Appearance in last level Category Pages
  eram_site_id <- dbGetQuery(con, query)[1,1]
  
  
  
  query <- qq(read_file("../queries/missed_cross_category.sql"))
  
  
  # Get Products Appearance in last level Category Pages
  dt <- dbGetQuery(con, query)%>%
    distinct()
  
  # dt <- dt[!duplicated(dt)]
  
  # Disconnect from the database
  dbDisconnect(con)
  
  dt <- dt  %>%
    mutate(total_baskets = n_distinct(basket_id)) %>%
    filter(segment != category) 
  
  total_cats <- dt %>%
    group_by(segment, category_id, category) %>%
    summarize(total_count = n_distinct(basket_id))
  
  cats <- dt %>%
    group_by(segment, basket_id, category_id, category) %>%
    summarize(company_brand = max(company_brand)) %>%
    ungroup() %>%
    filter(company_brand == 0) %>%
    group_by(segment, category_id, category) %>%
    summarize(count = n_distinct(basket_id)) %>%
    merge(total_cats, by = c('segment', 'category_id', 'category')) %>%
    mutate(freq = count / total_count,
           item = category) %>%
    ungroup() %>%
    arrange(desc(count)) %>%
    head(3) %>%
    select(segment, category_id, category, item, count, freq) %>%
    mutate(order = seq.int(3))
  
  # cats <- dt %>%
  #   group_by(segment, basket_id, category_id, category, company_brand) %>%
  #   summarize(c = n())%>%
  #   ungroup() %>%
  #   mutate(c = ifelse(company_brand == T, c, (-1) * c)) %>%
  #   group_by(segment, basket_id, category_id, category) %>%
  #   summarize(c = sum(c, na.rm = T)) %>%
  #   ungroup() %>%
  #   filter(c < 0) %>%
  #   group_by(segment, category_id, category) %>%
  #   summarize(count = n_distinct(basket_id)) %>%
  #   merge(total_cats, by = c('segment', 'category_id', 'category')) %>%
  #   mutate(freq = count / total_count,
  #          item = category) %>%
  #   ungroup() %>%
  #   arrange(desc(count)) %>%
  #   head(3) %>%
  #   select(segment, category_id, category, item, count, freq) 
  #   # mutate(order = seq.int(nrow(cats)))
  
  brands <- dt %>%
    filter(company_brand == FALSE) %>%
    group_by(segment, category_id, category, brand) %>%
    summarize(count = n_distinct(basket_id)) %>%
    slice_max(order_by = count, n = 3, with_ties = FALSE) %>%
    ungroup() 
  
  colnames(brands) <- c('segment', 'category_id', 'category', 'item', 'count')
  
  brands <- brands %>%
    merge(cats, by = c('segment', 'category_id', 'category'), suffixes = c('', '_cat')) %>%
    mutate(freq = count / count_cat) %>%
    select(segment, category_id, category, item, count, freq, order)
  
  final <- rbind(cats, brands) %>%
    arrange(order, desc(count)) %>%
    select(-category_id, -order)
  
  data <- rbind(data, final) %>% 
    mutate(item = str_trunc(item, 100, "center"),
           count = as.numeric(count))
  
  categories <- unique(data$category)
  
  for (cat in categories) {
    
    data %>% 
      ungroup() %>%
      filter(category == cat) %>%
      filter(item != cat) %>%
      select(`Brand` = item, `Baskets` = count, `Frequency` = freq) %>%
      gt() %>%
      # fmt_date(columns = c(From, Until), date_style = "day_m_year") %>% 
      fmt_integer(columns = `Baskets`, locale = "el") %>%
      # fmt_currency(columns = c(`Total Sales Value`, `Average Daily Sales Value`), currency = "EUR", locale = "el") %>%
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
        domain = c(0, max(data[data$category == cat & data$item != cat, 5]))
      ) %>% 
      # data_color(
      #   columns = `Share of Assortment`,
      #   method = "numeric",
      #   palette = c("#EF676A", "white", "#87bf39"),
      #   domain = c(0, max(data$soa) / 2, max(data$soa))
      # ) %>% 
      # tab_style(
      #   style = list(cell_text(color = "#87bf39", weight = "bold")),
      #   locations = cells_body(columns = c(`Estimated Sales Value Uplift`, `Estimated Units Uplift`))
      # ) %>%
      tab_options(
        table.width = px(250),
        table.font.size = 12,   
        column_labels.font.size = 10,    
        column_labels.font.weight = "bold"
        # column_labels.background.color = "#FEB659"
      )  %>%
      gtsave(filename = paste0("../output/missed_cross", which(categories == cat), ".png"), vwidth = 2000, zoom = 2)
    
  }
  
  
  
}
















