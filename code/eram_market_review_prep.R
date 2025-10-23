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
library(scales)
library(officer)
library(png)
library(arules)
library(patchwork)   #--> combine ggplot charts

rm(list = ls()) #--> Clear Environment


# source('_params.R')
source('_formatting.R')
source('_retailers_details.R')
source('_site_id.R')
source('_ppt.R')
source('_trends.R')
source('_barplots.R')
source('_decomposition.R')
source('_decomposition_data.R')
source('_eram_db_connection.R')
source('_AC_retailers_overview.R')
source('_R_retailer_overview.R')
source('_C_categories_data.R')
source('_C_navigation_data.R')
source('_C_search_data.R')
source('_C_spend_data.R')
source('_C_categories_penetration_data.R')
source('_C_channels_data.R')
source('_C_bundles_data.R')
source('_C_missed_cross_data.R')

q <- do.call(file.remove, list(list.files("../output", full.names = TRUE)))

qbrs <- readxl::read_xlsx('../Parameters.xlsx')
qbrs[is.na(qbrs)] <- ''
con_eram <- connect_eramdb(password = read_file("_eram_local_db_pass.txt"))

for (qbr in 1:nrow(qbrs)) {
  
  eram_company_account_id <- qbrs$id[[qbr]]
  eram_category_ids <- qbrs$eram_category_ids[[qbr]]
  eram_segment_ids <- qbrs$eram_segment_ids[[qbr]]
  sources <- qbrs$sources[[qbr]]
  source <- ifelse(sources == '', '', paste0('where omnichannel_source in (', sources, ')'))
  date_start <- qbrs$date_start[[qbr]]
  date_end <- qbrs$date_end[[qbr]]
  date_start_ya <- qbrs$date_start_ya[[qbr]]
  date_end_ya <- qbrs$date_end_ya[[qbr]]
  period <- qbrs$period[[qbr]]
  full_period <- qbrs$full_period[[qbr]]
  
  ## Return Company Account Name
  company_account <- dbGetQuery(con_eram, qq(read_file("../queries/company_name.sql")))[[1]]
  
  dir.create(paste('../../../Reports/', company_account, sep = ''))
  dir.create(paste('../../../Reports/', company_account, '/', year(ymd(date_end)), sep = ''))
  dir.create(paste('../../../Reports/', company_account, '/', year(ymd(date_end)), '/eRAM QBR ', period, sep = ''))
  
  eram_sites <- eram_retailers(eram_company_account_id, eram_category_ids, eram_segment_ids, con_eram)
  
  ## Return Company Brands
  com_brands_q <- qq(read_file("../queries/company_brands.sql"))
  com_brands <- dbGetQuery(con_eram, com_brands_q)
  
  template_pptx <- officer::read_pptx("../ppt/eRAM QBR Template.pptx")
  
  # ---- FIRST SLIDE ----#
  title_slide(template_pptx, company_account, period)
  
  # officer::layout_summary(template_pptx)
  # 
  # officer::layout_properties(x = template_pptx, layout = "Collaborate Overview")
  
  #-- RETAILERS OVERVIEW SLIDE
  dt_overview <- retailers_overview(con_eram, eram_company_account_id, date_start, date_end, date_start_ya, date_end_ya, eram_sites, source)
  
  
  if (length(unique(eram_sites$site_id)) > 1) {
    
    performance_overview(template_pptx, paste0("../output/", eram_company_account_id, "_AC_00.png"))
    
  }
  
  dt_dec <- decomposition_data(con_eram, eram_company_account_id, date_start, date_end, date_start_ya, date_end_ya, eram_sites)
  
  sites <- unique(eram_sites$site_id)
  
  for (r in sites) {
    
    segments <- eram_sites[eram_sites$site_id == r, 6]
    currency <- unique(eram_sites[eram_sites$site_id == r, 'currency'])[1]
    
    eram_site_id <- r
    
    site_details <- eram_sites %>%
      filter(site_id == r)
    
    ## Define Retailer Parameters
    masking <- ifelse(site_details$competition_masking[1] == F, F, T) #--> Masking at the Brand Level?
    competition <- ifelse(site_details$company_data_only[1] == T | site_details$plan[1] == "collaborate_free", F, T) #--> Show competition & category?
    evos <- ifelse(site_details$site_id[1] == 137 & !(eram_company_account_id %in% c(39, 43)), F, T) #--> Show YoY Evolution of competition & category metrics?
    plan <- site_details$plan[1]
    
    l <- retailer_overview(site_details, dt_overview, dt_dec, masking, competition, evos, currency)
    
    dec <- l$tb_deco
    ove <- l$tb_overview
    
    if (competition == T & evos == T) {
      
      market_overview_unmasked(template_pptx, paste0("../output/", eram_company_account_id, "_", r, "_0_1.png"),
                    paste0("../output/", eram_company_account_id, "_", r, "_0_2.png"),
                    paste0("../output/", eram_company_account_id, "_", r, "_0_3.png"),
                    ove, dec)
      
    } else if (competition == T & evos == F) {
      
      market_overview_evos(template_pptx, paste0("../output/", eram_company_account_id, "_", r, "_0_1.png"),
                           paste0("../output/", eram_company_account_id, "_", r, "_0_2.png"),
                           paste0("../output/", eram_company_account_id, "_", r, "_0_3.png"),
                           ove, dec)
      
    } else {
      
      market_overview_masked(template_pptx,
                           paste0("../output/", eram_company_account_id, "_", r, "_0_2.png"),
                           ove, dec)
      
    }
    
    for (segment_id in segments) {
      
      type <- eram_sites[eram_sites$site_id == r & eram_sites$segment_id == segment_id, 7]
      
      seg <- categories_data(eram_company_account_id, date_start, date_end, date_start_ya, date_end_ya, masking, competition, evos, 
                      eram_site_id, segment_id, source, type, con_eram, currency)
      
      category_base_slides(template_pptx, paste0("../output/", eram_company_account_id, "_", r, "_", segment_id, "_01.png"), 
                           paste0("../output/", eram_company_account_id, "_", r, "_", segment_id, "_02.png"), 
                           paste0("../output/", eram_company_account_id, "_", r, "_", segment_id, "_03.png"), seg, competition)
      
      if (plan == 'partner') {
        
        nav_sessions <- navigation_data(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con_eram)
        
        sear_sessions <- search_data(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con_eram)
        
        spend <- spend_data(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con_eram, currency)
        
        category_penetration_data(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con_eram)
        
        channels_data(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con_eram)
        
        bundles_data(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con_eram)
        
        missed_cross_sells_categories <- missed_cross_data(eram_company_account_id, date_start, date_end, eram_site_id, segment_id, source, type, con_eram)
        
        category_partner_ppt(template_pptx, site_details, nav_sessions, sear_sessions, period, spend, missed_cross_sells_categories,
                             paste0('../output/', eram_company_account_id, "_", eram_site_id, "_", segment_id), competition)
        
      }
      
    }
  
  }
  
  end_slides(template_pptx)
  
  print(template_pptx, target = paste0('../ppt/', company_account, ' eRAM QBR ', period, '.pptx'))
  
  print(template_pptx, target = paste0('../../../Reports/', company_account, '/', year(ymd(date_end)), '/eRAM QBR ', period, '/', company_account, ' eRAM QBR ', period, '.pptx'))

}

dbDisconnect(con_eram)








