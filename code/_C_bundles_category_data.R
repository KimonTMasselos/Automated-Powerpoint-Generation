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
  
  
  
  query <- qq(read_file("../queries/bundles_category.sql"))
  
  
  # Get Products Appearance in last level Category Pages
  dt <- dbGetQuery(con, query)
  
  # Disconnect from the database
  dbDisconnect(con)
  
  
  transactions <- split(dt$product_id, dt$basket_id)
  transactions <- lapply(transactions, as.character)
  transactions <- as(transactions, "transactions")
  
  # Adjust the support and confidence thresholds
  basket_rules <- apriori(transactions, parameter = list(support = 0.005, confidence = 0.01, target = "rules", maxlen = 2))
  
  # Convert the rules to a data frame and extract the desired information
  basket_analysis_results <- as(basket_rules, "data.frame")
  
  # Split the rules into separate columns for product A and product B
  rule_parts <- strsplit(as.character(basket_analysis_results$rules), " => ")
  product_X <- sapply(rule_parts, function(x) gsub("\\{|\\}", "", x[1]))
  product_Y <- sapply(rule_parts, function(x) gsub("\\{|\\}", "", x[2]))
  
  # Combine the extracted data into a new data frame
  basket_analysis <- data.frame(Product_X = product_X,
                                Product_Y = product_Y,
                                Support = basket_analysis_results$support,
                                Confidence = basket_analysis_results$confidence,
                                Lift = basket_analysis_results$lift,
                                Count = basket_analysis_results$count) %>%
    filter(Product_X != '')
  
  basket_analysis <- basket_analysis %>%
    rowwise() %>%
    mutate(dedup = paste0(min(`Product_X`, `Product_Y`), max(`Product_X`, `Product_Y`)))
  
  
  
  basket_analysis <- tibble::rowid_to_column(basket_analysis, "ID")
  
  demo <- basket_analysis %>%
    group_by(dedup) %>%
    summarise(id = min(ID))
  
  basket_analysis <- basket_analysis %>%
    filter(ID %in% demo$id) %>%
    select(Product_X, Product_Y, Count) %>%
    arrange(desc(Count)) %>%
    ungroup()
  
  products <- dt %>%
    group_by(segment, product_id, product, category_product) %>%
    summarize(baskets = n_distinct(basket_id))
  
  # basket_analysis <- basket_analysis 
  
  
  basket_analysis <- basket_analysis %>%
    merge(products, by.x = c('Product_X'), by.y = c('product_id'))
  
  basket_analysis <- basket_analysis %>%
    merge(products, by.x = c('Product_Y'), by.y = c('product_id')) %>%
    filter(category_product.x == T | category_product.y == T) %>%
    rowwise() %>%
    mutate(product_a = ifelse(baskets.x > baskets.y, product.x, product.y),
           product_b = ifelse(baskets.x <= baskets.y, product.x, product.y),
           baskets_a = ifelse(baskets.x > baskets.y, baskets.x, baskets.y),
           baskets_b = ifelse(baskets.x <= baskets.y, baskets.x, baskets.y),
           cat_a = ifelse(baskets.x > baskets.y, category_product.x, category_product.y),
           cat_b = ifelse(baskets.x <= baskets.y, category_product.x, category_product.y)) %>%
    mutate(product_x = ifelse(cat_a != T, product_b, product_a),
           product_y = ifelse(cat_a != T, product_a, product_b),
           baskets_x = ifelse(cat_a != T, baskets_b, baskets_a),
           baskets_y = ifelse(cat_a != T, baskets_a, baskets_b),
           freq = Count / baskets_x) %>%
    arrange(desc(Count)) %>%
    head(10) %>%
    mutate(segment = products[[1]][1]) %>%
    select(segment, product_x, product_y, Count, freq)
  
  data <- rbind(data, basket_analysis) %>% 
    mutate(product_x = str_trunc(product_x, 100, "center"),
           product_y = str_trunc(product_y, 100, "center"),
           Count = as.numeric(Count))
  
  data %>% 
    ungroup() %>%
    select(`Product X` = product_x, `Product Y` = product_y, `Baskets` = Count, `Frequency` = freq) %>%
    gt() %>%
    # fmt_date(columns = c(From, Until), date_style = "day_m_year") %>% 
    fmt_integer(columns = `Baskets`, locale = "el") %>%
    # fmt_currency(columns = c(`Total Sales Value`, `Average Daily Sales Value`), currency = "EUR", locale = "el") %>%
    fmt_percent(columns = `Frequency`, decimals = 1, locale = "el") %>%
    cols_align(columns = c(`Product X`, `Product Y`), align = "left") %>%
    cols_align(columns = c(`Baskets`, `Frequency`), align = "center") %>%
    cols_width(
      `Baskets` ~ "10%",
      `Frequency` ~ "10%"
    ) %>%
    cols_label(
      `Product X` = "Customers who shopped...",
      `Product Y` = "Also shopped...",
      `Frequency` = "Frequency"
    ) %>%
    tab_style(
      style = list(
        cell_text(color = "#2A438C")
      ),
      locations = cells_column_labels(columns = `Product X`)
    ) %>%
    tab_style(
      style = list(
        cell_text(color = "#73D5FF")
      ),
      locations = cells_column_labels(columns = `Product Y`)
    ) %>%
    data_color(
      columns = `Frequency`,
      method = "numeric",
      palette = c("white", "#73D5FF"),
      domain = c(min(data$freq), max(data$freq))
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
      table.width = px(880),
      table.font.size = 12,   
      column_labels.font.size = 10,    
      column_labels.font.weight = "bold",
      data_row.padding = px(5)
      # column_labels.background.color = "#FEB659"
    )  %>%
    gtsave(filename = "../output/bundles.png", vwidth = 2000, zoom = 2)
  
}