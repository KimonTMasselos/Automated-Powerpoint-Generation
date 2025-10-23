# ---- BARPLOT VISUALIZATION ----

## Define Bar Plot Theme
barplot_theme <- theme(
  text = element_text(family = "Arial"),
  plot.background = element_blank(),
  panel.background = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  axis.line = element_blank(),
  axis.text = element_blank(),
  axis.title = element_blank(),
  axis.ticks = element_blank(),
  legend.title = element_blank(),
  legend.position = "none"
)
min_lines <- 3


plot_labels <- function(group_names, highlight, mask_comp) {
  
  ## Merge all relevant data to a data-frame
  if(is.null(highlight)) { highlight <- rep(F, length(group_names)) }
  data <- bind_cols(as.data.frame(group_names), as.data.frame(highlight))
  
  data <- data %>% 
    mutate(
      vis_names = ifelse(
        mask_comp == T & highlight == F & group_names != levels(data$group_names)[nrow(data)],
        "Masked Brand",
        as.character(group_names)
      ),
      vis_names = str_replace_all(vis_names, "\\/", " "),
      vis_names = str_replace_all(vis_names, "-", " - "),
      vis_names = str_trunc(vis_names, 32, side = "center", ellipsis = "... ")
    )
  
  vlines <- seq(from = min(1.5, nrow(data) - 0.5), to = nrow(data) - 0.5, by = 1)
  
  ## Generate Plot
  ggplot(data, aes(x = group_names)) +
    geom_label(aes(y = 0, label = str_wrap(vis_names, width = 18 ), fill = ifelse(highlight == T, "1", "0")),
               label.padding = unit(0.5, "lines"), label.size = 0, label.r = unit(0.1, "npc"), alpha = 0.4,
               size = 3.4, position = position_nudge(y = 0.5)) +
    #geom_text(aes(y = 0, label = str_wrap(group_names, width = 14)), stat = "identity", size = 4) +
    sapply(vlines, function(v) geom_vline(aes(xintercept = v), colour = "#DAE2F2", linewidth = .3)) +
    expand_limits(x = c(min(nrow(data) - min_lines, 0), nrow(data))) +
    scale_fill_manual(values = c("1" = "#FEB659", "0" = "#FFFFFF")) +
    coord_flip() +
    barplot_theme
}

plot_bars <- function(groups, numbers, colour) {
  ## Merge all relevant data to a data-frame
  data <- bind_cols(as.data.frame(groups), as.data.frame(numbers))
  vlines <- seq(from = min(1.5, nrow(data) - 0.5), to = nrow(data) - 0.5, by = 1)
  
  ## Generate Plot
  ggplot(data, aes(x = groups)) + 
    geom_hline(yintercept = 0, colour = "#DAE2F2", size = .6) +
    geom_bar(aes(y = numbers), stat = "identity", width = .5, fill = colour) +
    sapply(vlines, function(v) geom_vline(aes(xintercept = v), colour = "#DAE2F2", linewidth = .3)) +
    expand_limits(x = c(min(nrow(data) - min_lines, 0), nrow(data))) +
    coord_flip() +
    barplot_theme
}

plot_values <- function(groups, values) {
  ## Merge all relevant data to a data-frame
  data <- bind_cols(as.data.frame(groups), as.data.frame(values))
  vlines <- seq(from = min(1.5, nrow(data) - 0.5), to = nrow(data) - 0.5, by = 1)
  
  ## Generate Plot
  ggplot(data, aes(x = groups)) +
    geom_text(aes(y = 0, label = values), stat = "identity", fontface = "bold", size = 4.6) +
    sapply(vlines, function(v) geom_vline(aes(xintercept = v), colour = "#DAE2F2", linewidth = .3)) +
    expand_limits(x = c(min(nrow(data) - min_lines, 0), nrow(data))) +
    coord_flip() +
    barplot_theme
}

plot_values_w_comps <- function(groups, values, comps) {
  ## Merge all relevant data to a data-frame
  data <- bind_cols(as.data.frame(groups), as.data.frame(values), as.data.frame(comps)) %>% 
    mutate(sign = case_when(
      str_starts(comps, "\\+") ~ "pos",
      str_starts(comps, "\\-") ~ "neg",
      T ~ "flt"
    )
    )
  vlines <- seq(from = min(1.5, nrow(data) - 0.5), to = nrow(data) - 0.5, by = 1)
  
  ## Generate Plot
  ggplot(data, aes(x = groups)) +
    geom_text(aes(y = 1, label = values), stat = "identity", fontface = "bold", size = 4.6) +
    geom_label(aes(y = 3, label = comps, fill = sign), color = "#FFFFFF", stat = "identity", fontface = "bold", size = 4) +
    sapply(vlines, function(v) geom_vline(aes(xintercept = v), colour = "#DAE2F2", linewidth = .3)) +
    expand_limits(x = c(min(nrow(data) - 3, 0), nrow(data))) +
    ylim(c(0,4)) +
    scale_fill_manual(values = setNames(c("#87BF39dd", "#EF676Add", "#A1A4B2dd"), c("pos", "neg", "flt"))) +
    coord_flip() +
    barplot_theme
}


## Build a composite barplot
hbar_vis <- function(
    groups,
    highlight = NULL,
    barplot_1,
    values_1,
    comps_1 = NULL,
    barplot_2 = NULL,
    values_2 = NULL,
    comps_2 = NULL,
    barplot_3 = NULL,
    values_3 = NULL,
    comps_3 = NULL,
    barplot_4 = NULL,
    values_4 = NULL,
    comps_4 = NULL,
    mask_comp = F
) {
  ## Count number of plots
  plot_map <- NULL
  for(i in 1:4) {
    t <- tibble(
      chart = paste0("barplot_", i),
      visible = !is.null(get(paste0("barplot_", i))),
      comp = !is.null(get(paste0("comps_", i))))
    plot_map <- bind_rows(plot_map, t)
  }
  plot_map <- filter(plot_map, visible == T)
  
  ## Define Layout Parameters
  colours <- c("#004B8C", "#49B4F2", "#7083C7", "#137BC2")
  n_charts <- nrow(plot_map)
  n_comps <- sum(plot_map$comp)
  left <- 11
  width_val <- 5
  width_comp <- 5
  width_bar <- floor((100 - left - n_charts - (n_charts * width_val) - (n_comps * width_comp)) / n_charts)
  
  ## Generate Layout
  layout <- area(t = 1, l = 1, b = 2, r = 11)
  for(l in 1:n_charts) {
    ## Define Grid Positions
    left_b <- left + 2
    right_b <- left_b + width_bar
    left_v <- right_b + 1
    right_v <- ifelse(plot_map$comp[l] == T, left_v + width_val + width_comp, left_v + width_val)
    left <- right_v + 2
    
    ## Update Layout
    layout <- c(
      layout,
      area(t = 1, l = left_b, b = 2, r = right_b),
      area(t = 1, l = left_v, b = 2, r = right_v)
    )
  }
  
  ## Generate Plots
  plots <- list(plot_labels(groups, highlight, mask_comp))
  for(p in 1:n_charts) {
    b <- plot_bars(groups, get(paste0("barplot_", p)), colour = colours[p])
    if(plot_map$comp[p] == T) {
      v <- plot_values_w_comps(groups, get(paste0("values_", p)), get(paste0("comps_", p)))
    } else {
      v <- plot_values(groups, get(paste0("values_", p)))
    }
    plots <- c(plots, list(b), list(v))
  }
  
  ## Combine all plots
  vis <- wrap_plots(plots, design = layout)
  return(vis)
}