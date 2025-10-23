#---- MARKET OVERVIEW CHARTS ----

## Sector Monthly Evolution Theme
sec.evo.theme <- theme(
  text = element_text(family = "Arial"),
  plot.margin = unit(c(0,0,0,0),"cm"),
  plot.background = element_blank(),
  panel.background = element_blank(),
  panel.grid.major.y = element_line(colour = "#DAE2F2", linewidth = .2),
  panel.grid.major.x = element_blank(),
  panel.grid.minor = element_blank(),
  axis.text = element_text(
    size = 10,
    colour = "#a1a4b2",
    margin = margin(10, 0, 0, 0)
  ),
  axis.title = element_blank(),
  axis.ticks = element_blank(),
  legend.title = element_blank(),
  legend.position = "none"
)

## Monthly Trend Chart
monthly_trend <- function(period, current_series, previous_series, segment, evos = T) {
  data <- bind_cols(month = period, cs = current_series, ps = previous_series) %>%
    mutate(month = month(month, label = T, abbr = T, locale = 'en'))
  color <- case_when(
    segment == "market" ~ "#2a438c",
    segment == "you" ~ "#33c2ff",
    segment == "ms" ~ "#feb659",
    T ~ "#a1a4b2"
  )
  trend <- ggplot(data, aes(x = month, group = 1)) +
    geom_hline(yintercept = 0, linewidth = .5, colour = "#222222") +
    geom_line(aes(y = cs), color = color, linewidth = 1) +
    geom_point(aes(y = cs), color = color, size = 3) +
    expand_limits(y = 0) +
    sec.evo.theme
  
  if(evos == T) {
    trend <- trend + geom_line(aes(y = ps), color = color, alpha = 0.8, linewidth = .5, linetype = "dashed")
  }
  
  if(segment == "ms") {
    chart <- trend +
      scale_y_continuous(
        labels = label_percent(),
        breaks = breaks_extended(5)
      )
  } else {
    chart <- trend +
      scale_y_continuous(
        labels = label_number(prefix = "€", scale_cut = cut_short_scale()),
        breaks = breaks_extended(5)
      )
  }
  
  return(chart)
}