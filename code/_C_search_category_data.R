library(tidyverse)  #--> data manipulation and visualization
library(lubridate)  #--> dates manipulation
library(sjmisc)     #--> ???
library(DBI)        #--> connect to databases
library(RPostgres)  #--> connect to PostgreSQL DB
library(rstudioapi) #--> ask users for inputs
library(GetoptLong) #--> for variable interpolation
library(readxl)     #--> for read_excel function
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
  
  
  
  query <- qq(read_file("../queries/search_category.sql"))
  
  
  # Get Products Appearance in last level Category Pages
  dt <- dbGetQuery(con, query)
  
  # Disconnect from the database
  dbDisconnect(con)
  
  dt <- head(dt, 10)
  
  data <- rbind(data, dt) %>% 
    mutate(sessions = as.numeric(sessions),
           search_term = str_trunc(search_term, 100, "center"))
  
  data %>% 
    select(`Search Term` = search_term, `Sessions` = sessions, `Share of Assortment` = soa) %>%
    gt() %>%
    # fmt_date(columns = c(From, Until), date_style = "day_m_year") %>% 
    fmt_integer(columns = `Sessions`, locale = "el") %>%
    # fmt_currency(columns = c(`Total Sales Value`, `Average Daily Sales Value`), currency = "EUR", locale = "el") %>%
    fmt_percent(columns = `Share of Assortment`, decimals = 1, locale = "el") %>%
    cols_align(columns = `Search Term`, align = "left") %>%
    cols_align(columns = c(`Sessions`, `Share of Assortment`), align = "center") %>%
    cols_width(
      `Sessions` ~ "16.7%",
      `Share of Assortment` ~ "16.7%"
    ) %>%
    data_color(
      columns = `Share of Assortment`,
      method = "numeric",
      palette = c("white", "#73D5FF"),
      domain = c(0, max(data$soa))
    ) %>% 
    # tab_style(
    #   style = list(cell_text(color = "#87bf39", weight = "bold")),
    #   locations = cells_body(columns = c(`Estimated Sales Value Uplift`, `Estimated Units Uplift`))
    # ) %>%
    tab_options(
      table.width = px(480),
      table.font.size = 12,   
      column_labels.font.size = 10,    
      column_labels.font.weight = "bold",
      data_row.padding = px(5)  
    ) %>%
    gtsave(filename = "../output/top_search_terms.png", vwidth = 2000, zoom = 2)
  
}
