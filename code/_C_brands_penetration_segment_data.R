library(tidyverse)  #--> data manipulation and visualization
library(lubridate)  #--> dates manipulation
library(sjmisc)     #--> ???
library(DBI)        #--> connect to databases
library(RPostgres)  #--> connect to PostgreSQL DB
library(rstudioapi) #--> ask users for inputs
library(GetoptLong) #--> for variable interpolation
library(readxl)     #--> for read_excel function

eram_segments <- as.integer(unlist(strsplit(eram_segment_ids, ",")))

data <- data.frame()


for (i in 1:length(eram_segments)) {
  
  eram_segment_id <- eram_segments[i]
  
  # Connect to eRAM Local App database
  con <- dbConnect(Postgres(),
                   dbname = "marketplace_production",
                   host = "35.187.66.46",
                   port = 5432,
                   user = "mplace_user",
                   password = read_file("_eram_local_db_pass.txt")
  )
  
  
  query <- qq(read_file("../queries/category_eram_segment_site_id.sql"))
  
  
  # Get Products Appearance in last level Category Pages
  eram_site_id <- dbGetQuery(con, query)[1,1]
  
  
  
  query <- qq(read_file("../queries/brands_penetration_segment.sql"))
  
  
  # Get Products Appearance in last level Category Pages
  dt <- dbGetQuery(con, query)
  
  # Disconnect from the database
  dbDisconnect(con)
  
  dt <- dt %>%
    arrange(desc(brand_penetration)) %>%
    group_by(segment, level) %>%
    slice(1:10) %>%
    select(-id)
  
  
  data <- rbind(data, dt)
  
}
