#----------------- Products Decomposition Calculations -----------------------------

## Calculating Decomposition Metrics on Products by the chosen aggregation level

decom_products_calc <- function(df) {
  
  df <- df %>%
    mutate(value = coalesce(value, 0),
           value_ya = coalesce(value_ya, 0),
           units = coalesce(units, 0),
           units_ya = coalesce(units_ya, 0),
           avg_price = value / units,
           avg_price_ya = value_ya / units_ya)
  
  
  range <- df %>%
    filter(value == 0 | value_ya == 0) %>%
    mutate(range = value - value_ya)
  
  df <- df %>%
    filter(value != 0 & value_ya != 0)
  
  aggregate_df <- df %>%
    group_by(aggregation_level) %>%
    summarize(agg_sales = sum(value), 
              agg_sales_ya = sum(value_ya), 
              agg_units = sum(units), 
              agg_units_ya = sum(units_ya))
  
  df <- merge(df, aggregate_df, c = ('aggregation_level'))
  
  df <- df %>%
    mutate(units_weight = units / agg_units, 
           units_weight_ya = units_ya / agg_units_ya,
           agg_price = agg_sales / agg_units,
           agg_price_ya = agg_sales_ya / agg_units_ya,
           price = (avg_price - avg_price_ya) * units,
           quantity = (units - units_ya) * agg_price_ya,
           mix = (avg_price_ya - agg_price_ya) * (units - (agg_units * units_weight_ya)),
           range = 0)
  
  final <- bind_rows(df, range) %>%
    mutate(evol = value - value_ya)
  
  return(final)
  
}

#----------------- Aggregation Level Decomposition ----------------------

## Getting the Decomposition summarized for the chosen Aggregation Level

decom_aggregated_level <- function(df) {
  
  df <- df %>%
    group_by(aggregation_level) %>%
    summarize(sales = sum(value, na.rm = T),
              sales_ya = sum(value_ya, na.rm = T),
              sales_delta = sales - sales_ya,
              sales_evo = (sales / sales_ya) - 1,
              range = sum(range, na.rm = T),
              range_cont = (range / sales_delta) * sales_evo,
              quantity = sum(quantity, na.rm = T),
              quantity_cont = (quantity / sales_delta) * sales_evo,
              price = sum(price, na.rm = T),
              price_cont = (price / sales_delta) * sales_evo,
              mix = sum(mix, na.rm = T),
              mix_cont = (mix / sales_delta) * sales_evo)
}

#----------------- AC Decomposition Format ----------------------

## Returning the Decomposition Data for the Market Overview Section in the desired Format

market_overview_decomposition <- function(df) {
  
  company <- df %>%
    mutate(aggregation_level = "You") %>%
    filter(company_account == T) %>%
    decom_products_calc() %>%
    decom_aggregated_level()
  
  rest <- df %>%
    mutate(aggregation_level = "Rest of Market") %>%
    filter(company_account == F) %>%
    decom_products_calc() %>%
    decom_aggregated_level()
  
  final <- rbind(company, rest)
  
  final_format <- tibble(
    val_cd = num_format(final$sales_delta[final$aggregation_level == "You"], type = "currency", comp = T, symbol = currency),
    val_ce = num_format(final$sales_evo[final$aggregation_level == "You"], type = "percentage", comp = T),
    qm_c = num_format(final$quantity[final$aggregation_level == "You"], type = "currency", comp = T, symbol = currency),
    pm_c = num_format(final$price[final$aggregation_level == "You"], type = "currency", comp = T, symbol = currency),
    mm_c = num_format(final$mix[final$aggregation_level == "You"], type = "currency", comp = T, symbol = currency),
    rm_c = num_format(final$range[final$aggregation_level == "You"], type = "currency", comp = T, symbol = currency),
    qc_c = num_format(final$quantity_cont[final$aggregation_level == "You"], type = "point", comp = T),
    pc_c = num_format(final$price_cont[final$aggregation_level == "You"], type = "point", comp = T),
    mc_c = num_format(final$mix_cont[final$aggregation_level == "You"], type = "point", comp = T),
    rc_c = num_format(final$range_cont[final$aggregation_level == "You"], type = "point", comp = T),
    val_re = num_format(final$sales_evo[final$aggregation_level == "Rest of Market"], type = "percentage", comp = T),
    val_rd = num_format(final$sales_delta[final$aggregation_level == "Rest of Market"], type = "currency", comp = T, symbol = currency),
    qm_r = num_format(final$quantity[final$aggregation_level == "Rest of Market"], type = "currency", comp = T, symbol = currency),
    pm_r = num_format(final$price[final$aggregation_level == "Rest of Market"], type = "currency", comp = T, symbol = currency),
    mm_r = num_format(final$mix[final$aggregation_level == "Rest of Market"], type = "currency", comp = T, symbol = currency),
    rm_r = num_format(final$range[final$aggregation_level == "Rest of Market"], type = "currency", comp = T, symbol = currency),
    qc_r = num_format(final$quantity_cont[final$aggregation_level == "Rest of Market"], type = "point", comp = T),
    pc_r = num_format(final$price_cont[final$aggregation_level == "Rest of Market"], type = "point", comp = T),
    mc_r = num_format(final$mix_cont[final$aggregation_level == "Rest of Market"], type = "point", comp = T),
    rc_r = num_format(final$range_cont[final$aggregation_level == "Rest of Market"], type = "point", comp = T)
  ) %>% pivot_longer(cols = everything(), names_to = "variable", values_to = "value")
  
  return(final_format)
}

#----------------- AC eRAM Decomposition Format ----------------------

## Returning the Decomposition Data for the Market Overview Section in the desired Format

eram_market_overview_decomposition <- function(df) {
  
  retailers <- unique(df$retailer)
  
  final <- data.frame()
  
  for (retailer in retailers) {
    
    dt <- df[df$retailer == retailer, ]
    
    company <- dt %>%
      mutate(aggregation_level = 'You') %>%
      filter(company_account == T) %>%
      decom_products_calc() %>%
      decom_aggregated_level()
    
    rest <- dt %>%
      mutate(aggregation_level = 'Rest of Market') %>%
      filter(company_account == F) %>%
      decom_products_calc() %>%
      decom_aggregated_level()
    
    d <- rbind(company, rest) %>%
      mutate(retailer = retailer) %>%
      select(retailer, aggregation_level, sales, sales_ya,
             sales_delta, sales_evo, range, range_cont, 
             quantity, quantity_cont, price, price_cont, mix, mix_cont)
    
    final <- rbind(final, d)
    
  }
  
  return(final)
  
}