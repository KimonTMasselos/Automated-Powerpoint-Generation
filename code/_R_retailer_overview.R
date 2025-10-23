

# ---- RETAILER OVERVIEW ----
retailer_overview <- function(site_details, dt_overview, dt_dec, masking, competition, evos, currency) {
  
  tb_overview <- dt_overview %>% 
    filter(retailer == site_details$retailer[1]) %>% 
    pivot_wider(names_from = period, values_from = c(ttl_sales_value, com_sales_value, ttl_units, com_units, ttl_orders, com_orders)) %>%
    rowwise() %>% 
    ## remove past data on efarma.com accounts
    mutate_at(vars(starts_with("ttl_") & ends_with("_p")), ~ ifelse(evos == T, ., 0)) %>% 
    group_by(retailer) %>% 
    summarize_all(sum, na.rm = TRUE) %>% 
    mutate(
      value_ttl = ttl_sales_value_c,
      value_pp_ttl = ttl_sales_value_p, 
      value_com = com_sales_value_c,
      value_pp_com = com_sales_value_p,
      units_ttl = ttl_units_c,
      units_pp_ttl = ttl_units_p,
      units_com = com_units_c,
      units_pp_com = com_units_p, 
      orders_ttl = ttl_orders_c,
      orders_pp_ttl = ttl_orders_p,
      orders_com = com_orders_c,
      orders_pp_com = com_orders_p
    ) %>% 
    transmute(
      val = num_format(value_ttl, "currency", F, symbol = currency),
      val_e = num_format(value_ttl / value_pp_ttl - 1, "percentage", T),
      unt = num_format(units_ttl, "number", F),
      unt_e = num_format(units_ttl / units_pp_ttl - 1, "percentage", T),
      ord = num_format(orders_ttl, "number", F),
      ord_e = num_format(orders_ttl / orders_pp_ttl - 1, "percentage", T),
      prc = num_format(value_ttl / units_ttl, "currency", F, symbol = currency),
      prc_e = num_format((value_ttl / units_ttl) / (value_pp_ttl / units_pp_ttl) - 1, "percentage", T),
      val_c = num_format(value_com, "currency", F, symbol = currency),
      val_ce = num_format(value_com / value_pp_com - 1, "percentage", T),
      unt_c = num_format(units_com, "number", F),
      unt_ce = num_format(units_com / units_pp_com - 1, "percentage", T),
      ord_c = num_format(orders_com, "number", F),
      ord_ce = num_format(orders_com / orders_pp_com - 1, "percentage", T),
      prc_c = num_format(value_com / units_com, "currency", F, symbol = currency),
      prc_ce = num_format((value_com / units_com) / (value_pp_com / units_pp_com) - 1, "percentage", T),
      val_s = num_format(value_com / value_ttl, "percentage", F),
      val_sd = num_format((value_com / value_ttl) - (value_pp_com / value_pp_ttl), "point", T),
      unt_s = num_format(units_com / units_ttl, "percentage", F),
      unt_sd = num_format((units_com / units_ttl) - (units_pp_com / units_pp_ttl), "point", T),
      pen = num_format(orders_com / orders_ttl, "percentage", F),
      pen_d = num_format((orders_com / orders_ttl) - (orders_pp_com / orders_pp_ttl), "point", T),
      prc_i = num_format((value_com / units_com) - (value_ttl / units_ttl), "currency", F, symbol = currency),
      prc_id = num_format(((value_com / units_com) - (value_ttl / units_ttl)) - ((value_pp_com / units_pp_com) - (value_pp_ttl / units_pp_ttl)), "currency", T, symbol = currency)
    ) %>% 
    pivot_longer(cols = everything(), names_to = "variable", values_to = "value")
  
  dt_trend <- dt_overview %>% 
    filter(retailer == site_details$retailer[1]) %>% 
    select(-retailer, -ends_with("units"), -ends_with("orders")) %>% 
    pivot_wider(names_from = period, values_from = c(ttl_sales_value, com_sales_value)) %>% 
    transmute(
      month = ymd(paste("2023", month, "1", sep = "-")),
      market_sales = ttl_sales_value_c,
      market_sales_ya = ttl_sales_value_p,
      company_sales = com_sales_value_c,
      company_sales_ya = com_sales_value_p,
      ms_sales = com_sales_value_c / ttl_sales_value_c,
      ms_sales_ya = com_sales_value_p / ttl_sales_value_p)
  
  market_trend <- monthly_trend(dt_trend$month, dt_trend$market_sales, dt_trend$market_sales_ya, "market", evos = evos)
  your_trend <- monthly_trend(dt_trend$month, dt_trend$company_sales, dt_trend$company_sales_ya, "you")
  ms_trend <- monthly_trend(dt_trend$month, dt_trend$ms_sales, dt_trend$ms_sales_ya, "ms", evos = evos)
  
  tb_deco <- market_overview_decomposition(filter(dt_dec, retailer == site_details$retailer[1]))
  
  if (competition == T) {
    
    ggsave(paste0("../output/", eram_company_account_id, "_", site_details$site_id[1], "_0", "_1.png"), plot = market_trend, dpi = 96, units = "px", width = 550, height = 326)
    ggsave(paste0("../output/", eram_company_account_id, "_", site_details$site_id[1], "_0", "_3.png"), plot = ms_trend, dpi = 96, units = "px", width = 550, height = 326) 
    
  }
  
  ggsave(paste0("../output/", eram_company_account_id, "_", site_details$site_id[1], "_0", "_2.png"), plot = your_trend, dpi = 96, units = "px", width = 550, height = 326)
  
  return(list("tb_deco" = tb_deco, "tb_overview" = tb_overview))
  
}