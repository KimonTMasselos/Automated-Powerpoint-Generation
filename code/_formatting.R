# ---- UTILITY FUNCTIONS ----

## Format values for charts
num_format <- function(x, type = "number", comp = F, symbol = "€", rounding = 0.1) {
  if(!is.numeric(x) | !is.finite(x)) {
    return("•")
  } else {
    n <- case_when(
      type == "number" & comp == F ~ number(
        x,
        accuracy = rounding,
        decimal.mark = ",",
        scale_cut = cut_short_scale()
      ),
      type == "number" & comp == T ~ number(
        x,
        accuracy = rounding,
        decimal.mark = ",",
        scale_cut = cut_short_scale(),
        style_positive = "plus"
      ),
      type == "currency" & comp == F ~ number(
        x, 
        accuracy = rounding,
        decimal.mark = ",",
        prefix = symbol,
        scale_cut = cut_short_scale()
      ),
      type == "currency" & comp == T ~ number(
        x, 
        accuracy = rounding,
        decimal.mark = ",",
        prefix = symbol,
        scale_cut = cut_short_scale(),
        style_positive = "plus"
      ),
      type == "percentage" & comp == F ~ number(
        x,
        scale = 100,
        accuracy = rounding,
        decimal.mark = ",",
        suffix = "%",
        scale_cut = cut_short_scale()
      ),
      type == "percentage" & comp == T ~ number(
        x,
        scale = 100,
        accuracy = rounding,
        decimal.mark = ",",
        suffix = "%",
        scale_cut = cut_short_scale(),
        style_positive = "plus"
      ),
      type == "point" & comp == T ~ number(
        x,
        scale = 100,
        accuracy = rounding,
        decimal.mark = ",",
        suffix = "pp",
        scale_cut = cut_short_scale(),
        style_positive = "plus"
      )
    )
    return(n)
  }
}