

retailers_overview <- function(con_eram, eram_company_account_id, date_start, date_end, date_start_ya, date_end_ya, rets, source) {
  
  rets <- eram_sites %>%
    select(-segment_id, -type, -currency) %>%
    distinct()
  
  dt_overview <- NULL
  for(r in 1:nrow(rets)) {
    eram_site_id <- rets$site_id[r]
    overview_q <- qq(read_file("../queries/retailer_overview.sql"))
    overview <- dbGetQuery(con_eram, overview_q)
    dt_overview <- bind_rows(dt_overview, overview) 
  }
  
  if (nrow(rets) > 1) {
    
    tb_rets <- dt_overview %>% 
      select(-ends_with("units"), -ends_with("orders")) %>% 
      left_join(rets, by = c("retailer")) %>%
      pivot_wider(names_from = period, values_from = c('ttl_sales_value', 'com_sales_value')) %>% 
      rowwise() %>% 
      ## remove past data for total market on efarma.com accounts
      mutate_at(vars(starts_with("ttl_") & ends_with("_p")), ~ ifelse(site_id == 137 & eram_company_account_id != 39, 0, .)) %>% 
      group_by(retailer, plan) %>% 
      summarize_all(sum, na.rm = TRUE) %>% 
      arrange(desc(com_sales_value_c)) %>%
      ungroup() %>%
      mutate(
        retailer = factor(retailer, levels = retailer[order(com_sales_value_c, decreasing = F, na.last = F)]),
        ttl_evo = ifelse(plan != 'collaborate_free', ttl_sales_value_c / ttl_sales_value_p - 1, NA),
        com_evo = com_sales_value_c / com_sales_value_p - 1,
        com_ms = ifelse(plan != 'collaborate_free', com_sales_value_c / ttl_sales_value_c, NA),
        com_ms_d = ifelse(plan != 'collaborate_free', com_ms - (com_sales_value_p / ttl_sales_value_p), NA),
        str_ttl_evo = ifelse(plan != 'collaborate_free', map_chr(ttl_evo, ~ num_format(., "percentage", T)), NA),
        str_com_evo = map_chr(com_evo, ~ num_format(., "percentage", T)),
        str_com_ms = ifelse(plan != 'collaborate_free', map_chr(com_ms, ~ num_format(., "percentage", F)), NA),
        str_com_ms_d = ifelse(plan != 'collaborate_free', map_chr(com_ms_d, ~ num_format(., "point", T)), NA)
      )
  
    ret_chart <- hbar_vis(groups = tb_rets$retailer,
                          barplot_1 = tb_rets$ttl_evo,
                          values_1 = tb_rets$str_ttl_evo,
                          barplot_2 = tb_rets$com_evo,
                          values_2 = tb_rets$str_com_evo,
                          barplot_3 = tb_rets$com_ms,
                          values_3 = tb_rets$str_com_ms,
                          comps_3 = tb_rets$str_com_ms_d)
    
    ggsave(paste0("../output/", eram_company_account_id, "_AC_00.png"), plot = ret_chart, dpi = 96, units = "px", width = 1800, height = 700)
  
  }
  
  return(dt_overview)
  
}

