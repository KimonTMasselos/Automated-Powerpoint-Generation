

categories_data <- function(eram_company_account_id, date_start, date_end, date_start_ya, date_end_ya, masking, competition, evos, 
                            eram_site_id, segment_id, source, type, con_eram, currency) {
  
  if(type == "C") {
    eram_category_id = segment_id
    cat_qs <- qq(read_file("../queries/sellout_category.sql"))
    cat_qb <- qq(read_file("../queries/baskets_category.sql"))
    cat_qp <- qq(read_file("../queries/pageviews_category.sql"))
  } else {
    eram_segment_id = segment_id
    cat_qs <- qq(read_file("../queries/sellout_segment.sql"))
    cat_qb <- qq(read_file("../queries/baskets_segment.sql"))
    cat_qp <- qq(read_file("../queries/pageviews_segment.sql"))
  }
  
  cat_s <- dbGetQuery(con_eram, cat_qs)
  cat_b <- dbGetQuery(con_eram, cat_qb)
  cat_p <- dbGetQuery(con_eram, cat_qp)
  
  dt_cat <- cat_s %>% 
    left_join(cat_b, by = c("site", "segment", "brand")) %>% 
    left_join(cat_p, by = c("site", "segment", "brand")) %>%
    filter(!is.na(brand))
  
  tb_cat <- dt_cat %>% 
    mutate(
      value_evo = sales_value / sales_value_ya - 1,
      value_ms = ifelse(brand == "Category", NA, sales_value / sales_value[brand == "Category"]),
      value_ms_d = value_ms - ifelse(brand == "Category", NA, sales_value_ya / sales_value_ya[brand == "Category"]),
      units_evo = units / units_ya - 1,
      units_ms = ifelse(brand == "Category", NA, units / units[brand == "Category"]),
      units_ms_d = units_ms - ifelse(brand == "Category", NA, units_ya / units_ya[brand == "Category"]),
      pen = ifelse(brand == "Category", NA, orders / orders[brand == "Category"]),
      pen_d = pen - ifelse(brand == "Category", NA, orders_ya / orders_ya[brand == "Category"]),
      avg_spend = sales_value / orders,
      avg_spend_ya = sales_value_ya / orders_ya,
      avg_spend_d = avg_spend - avg_spend_ya,
      avg_units = units / orders,
      avg_units_ya = units_ya / orders_ya,
      avg_units_d = avg_units - avg_units_ya,
      avg_item_price = sales_value / units,
      avg_item_price_ya = sales_value_ya / units_ya,
      avg_item_price_d = avg_item_price - avg_item_price_ya,
      pageviews_evo = pageviews / pageviews_ya - 1,
      orders_evo = orders / orders_ya - 1,
      buy_rate = ifelse(br_orders <= pageviews & pageviews > 0, br_orders / pageviews, NA),
      buy_rate_ya = ifelse(br_orders_ya <= pageviews_ya & pageviews_ya > 0, br_orders_ya / pageviews_ya, NA),
      buy_rate_d = buy_rate - buy_rate_ya,
      company_brand = ifelse(brand %in% com_brands$name, T, F),
      brand_rank = row_number(-sales_value)
    ) %>% 
    filter(brand == "Category" | (brand_rank < 12 & value_ms >= 0.01) | (company_brand == T & value_ms >= 0.001)) %>% 
    mutate(
      brand = ifelse(brand == "Category" & !(segment %in% dt_cat$brand), str_replace_all(segment, "_", " "), brand),
      brand = factor(brand, levels = brand[order(sales_value, decreasing = F)])
    ) %>% 
    rowwise() %>% 
    ## remove evolution for efarma.com accounts
    mutate_at(vars(ends_with("_evo") | ends_with("_d")), ~ ifelse(evos == F & company_brand == F, NA, .)) %>% 
    mutate(
      str_value_evo = map_chr(value_evo, ~ num_format(., "percentage", T)),
      str_value_ms = map_chr(value_ms, ~ num_format(., "percentage", F)),
      str_value_ms_d = map_chr(value_ms_d, ~ num_format(., "point", T)),
      str_units_evo = map_chr(units_evo, ~ num_format(., "percentage", T)),
      str_units_ms = map_chr(units_ms, ~ num_format(., "percentage", F)),
      str_units_ms_d = map_chr(units_ms_d, ~ num_format(., "point", T)),
      str_pen = map_chr(pen, ~ num_format(., "percentage", F)),
      str_pen_d = map_chr(pen_d, ~ num_format(., "point", T)),
      str_avg_spend = map_chr(avg_spend, ~ num_format(., "currency", F, symbol = currency)),
      str_avg_spend_d = map_chr(avg_spend_d, ~ num_format(., "currency", T, symbol = currency)),
      str_avg_units = map_chr(avg_units, ~ num_format(., "number", F)),
      str_avg_units_d = map_chr(avg_units_d, ~ num_format(., "number", T)),
      str_avg_item_price = map_chr(avg_item_price, ~ num_format(., "currency", F, symbol = currency)),
      str_avg_item_price_d = map_chr(avg_item_price_d, ~ num_format(., "currency", T, symbol = currency)),
      str_pageviews_evo = map_chr(pageviews_evo, ~ num_format(., "percentage", T)),
      str_orders_evo = map_chr(orders_evo, ~ num_format(., "percentage", T)),
      str_buy_rate = map_chr(buy_rate, ~ num_format(., "percentage", F)),
      str_buy_rate_d = map_chr(buy_rate_d, ~ num_format(., "point", T))
    ) %>%
    arrange(desc(sales_value))
  
  if(competition == F) { tb_cat <- filter(tb_cat, company_brand == T) }
  
  if(competition == T & all(is.na(tb_cat$value_evo))) {
    demand_chart <- hbar_vis(groups = tb_cat$brand,
                             highlight = tb_cat$company_brand,
                             barplot_1 = rep(0, nrow(tb_cat)),
                             values_1 = tb_cat$str_value_evo,
                             barplot_2 = tb_cat$value_ms,
                             values_2 = tb_cat$str_value_ms,
                             comps_2 = tb_cat$str_value_ms_d,
                             barplot_3 = rep(0, nrow(tb_cat)),
                             values_3 = tb_cat$str_units_evo,
                             barplot_4 = tb_cat$units_ms,
                             values_4 = tb_cat$str_units_ms,
                             comps_4 = tb_cat$str_units_ms_d,
                             mask_comp = masking)
    
    basket_chart <- hbar_vis(groups = tb_cat$brand,
                             highlight = tb_cat$company_brand,
                             barplot_1 = tb_cat$pen,
                             values_1 = tb_cat$str_pen,
                             comps_1 = tb_cat$str_pen_d,
                             barplot_2 = tb_cat$avg_spend,
                             values_2 = tb_cat$str_avg_spend,
                             comps_2 = tb_cat$str_avg_spend_d,
                             barplot_3 = tb_cat$avg_units,
                             values_3 = tb_cat$str_avg_units,
                             comps_3 = tb_cat$str_avg_units_d,
                             barplot_4 = tb_cat$avg_item_price,
                             values_4 = tb_cat$str_avg_item_price,
                             comps_4 = tb_cat$str_avg_item_price_d,
                             mask_comp = masking)
    
    rate_chart <- hbar_vis(groups = tb_cat$brand,
                           highlight = tb_cat$company_brand,
                           barplot_1 = rep(0, nrow(tb_cat)),
                           values_1 = tb_cat$str_pageviews_evo,
                           barplot_2 = rep(0, nrow(tb_cat)),
                           values_2 = tb_cat$str_orders_evo,
                           barplot_3 = tb_cat$buy_rate,
                           values_3 = tb_cat$str_buy_rate,
                           comps_3 = tb_cat$str_buy_rate_d,
                           mask_comp = masking)
    
  } else if(competition == T) {
    demand_chart <- hbar_vis(groups = tb_cat$brand,
                             highlight = tb_cat$company_brand,
                             barplot_1 = tb_cat$value_evo,
                             values_1 = tb_cat$str_value_evo,
                             barplot_2 = tb_cat$value_ms,
                             values_2 = tb_cat$str_value_ms,
                             comps_2 = tb_cat$str_value_ms_d,
                             barplot_3 = tb_cat$units_evo,
                             values_3 = tb_cat$str_units_evo,
                             barplot_4 = tb_cat$units_ms,
                             values_4 = tb_cat$str_units_ms,
                             comps_4 = tb_cat$str_units_ms_d,
                             mask_comp = masking)
    
    basket_chart <- hbar_vis(groups = tb_cat$brand,
                             highlight = tb_cat$company_brand,
                             barplot_1 = tb_cat$pen,
                             values_1 = tb_cat$str_pen,
                             comps_1 = tb_cat$str_pen_d,
                             barplot_2 = tb_cat$avg_spend,
                             values_2 = tb_cat$str_avg_spend,
                             comps_2 = tb_cat$str_avg_spend_d,
                             barplot_3 = tb_cat$avg_units,
                             values_3 = tb_cat$str_avg_units,
                             comps_3 = tb_cat$str_avg_units_d,
                             barplot_4 = tb_cat$avg_item_price,
                             values_4 = tb_cat$str_avg_item_price,
                             comps_4 = tb_cat$str_avg_item_price_d,
                             mask_comp = masking)
    
    rate_chart <- hbar_vis(groups = tb_cat$brand,
                           highlight = tb_cat$company_brand,
                           barplot_1 = tb_cat$pageviews_evo,
                           values_1 = tb_cat$str_pageviews_evo,
                           barplot_2 = tb_cat$orders_evo,
                           values_2 = tb_cat$str_orders_evo,
                           barplot_3 = tb_cat$buy_rate,
                           values_3 = tb_cat$str_buy_rate,
                           comps_3 = tb_cat$str_buy_rate_d,
                           mask_comp = masking)
  } else {
    demand_chart <- hbar_vis(groups = tb_cat$brand,
                             highlight = tb_cat$company_brand,
                             barplot_1 = tb_cat$value_evo,
                             values_1 = tb_cat$str_value_evo,
                             barplot_2 = tb_cat$units_evo,
                             values_2 = tb_cat$str_units_evo)
    
    basket_chart <- hbar_vis(groups = tb_cat$brand,
                             highlight = tb_cat$company_brand,
                             barplot_1 = tb_cat$avg_spend,
                             values_1 = tb_cat$str_avg_spend,
                             comps_1 = tb_cat$str_avg_spend_d,
                             barplot_2 = tb_cat$avg_units,
                             values_2 = tb_cat$str_avg_units,
                             comps_2 = tb_cat$str_avg_units_d,
                             barplot_3 = tb_cat$avg_item_price,
                             values_3 = tb_cat$str_avg_item_price,
                             comps_3 = tb_cat$str_avg_item_price_d)
    
    rate_chart <- hbar_vis(groups = tb_cat$brand,
                           highlight = tb_cat$company_brand,
                           barplot_1 = tb_cat$pageviews_evo,
                           values_1 = tb_cat$str_pageviews_evo,
                           barplot_2 = tb_cat$orders_evo,
                           values_2 = tb_cat$str_orders_evo,
                           barplot_3 = tb_cat$buy_rate,
                           values_3 = tb_cat$str_buy_rate,
                           comps_3 = tb_cat$str_buy_rate_d)
  }
  
  ggsave(paste0("../output/", eram_company_account_id, "_", eram_site_id, "_", segment_id, "_01.png"), plot = demand_chart, dpi = 96, units = "px", width = 1800, height = 700)
  ggsave(paste0("../output/", eram_company_account_id, "_", eram_site_id, "_", segment_id, "_02.png"), plot = basket_chart, dpi = 96, units = "px", width = 1800, height = 700)
  ggsave(paste0("../output/", eram_company_account_id, "_", eram_site_id, "_", segment_id, "_03.png"), plot = rate_chart, dpi = 96, units = "px", width = 1800, height = 700)
  
  return(tb_cat$segment[[1]])
  
}