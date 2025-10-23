

category_partner_ppt <- function(br_pptx, site_details, nav_sessions, sear_sessions, period, spend, missed_cross_sells_categories, file_path, competition) {
  
  if (file.exists(paste0(file_path, "_04.png"))) {
    
    image <- readPNG(paste0(file_path, "_04.png"))
    image_width_1 <- attr(image, "dim")[2] * 0.02645833
    image_height_1 <- attr(image, "dim")[1] * 0.02645833
    sc_1 <- image_width_1 / 11.43
    
    image <- readPNG(paste0(file_path, "_05.png"))
    image_width_2 <- attr(image, "dim")[2] * 0.02645833
    image_height_2 <- attr(image, "dim")[1] * 0.02645833
    sc_2 <- image_width_2 / 11.43
    
    add_slide(br_pptx,
              layout = "Browsing Experience",
              master = "QBR Template") %>%
      ph_with(
        value = external_img(paste0(file_path, "_04.png"), width = 11.43, height = image_height_1 / sc_1, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 14"),
        use_loc_size = FALSE
      ) %>%
      ph_with(
        value = external_img(paste0(file_path, "_05.png"), width = 11.43, height = image_height_2 / sc_2, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 2"),
        use_loc_size = FALSE
      )  %>%
      ph_with(
        value = period,
        location = ph_location_label(ph_label = "Text Placeholder 12")
      )  %>%
      ph_with(
        value = paste0("Direct Weight: ", num_format(nav_sessions / (nav_sessions + sear_sessions), "percentage", F, rounding = 0.1)),
        location = ph_location_label(ph_label = "Text Placeholder 3")
      )  %>%
      ph_with(
        value = paste0("Search Weight: ", num_format(sear_sessions / (nav_sessions + sear_sessions), "percentage", F, rounding = 0.1)),
        location = ph_location_label(ph_label = "Text Placeholder 11")
      )
    
  }
  
  if (file.exists(paste0(file_path, "_06.png"))) {
    
    if (competition) {
      
      if (file.exists(paste0(file_path, "_08.png"))) {
        
        add_slide(br_pptx,
                  layout = "Shopper Profile",
                  master = "QBR Template") %>%
          ph_with(
            value = external_img(paste0(file_path, "_07.png")),
            location = ph_location_label(ph_label = "Picture Placeholder 56")
          ) %>%
          ph_with(
            value = external_img(paste0(file_path, "_06.png")),
            location = ph_location_label(ph_label = "Picture Placeholder 60")
          ) %>%
          ph_with(
            value = external_img(paste0(file_path, "_09.png")),
            location = ph_location_label(ph_label = "Picture Placeholder 58")
          ) %>%
          ph_with(
            value = external_img(paste0(file_path, "_08.png")),
            location = ph_location_label(ph_label = "Picture Placeholder 62")
          )  %>%
          ph_with(
            value = period,
            location = ph_location_label(ph_label = "Text Placeholder 12")
          )  %>%
          ph_with(
            value = spend[[7]][2],
            location = ph_location_label(ph_label = "Text Placeholder 38")
          )  %>%
          ph_with(
            value = spend[[8]][2],
            location = ph_location_label(ph_label = "Text Placeholder 40")
          )  %>%
          ph_with(
            value = spend[[9]][2],
            location = ph_location_label(ph_label = "Text Placeholder 43")
          )  %>%
          ph_with(
            value = spend[[10]][2],
            location = ph_location_label(ph_label = "Text Placeholder 46")
          )  %>%
          ph_with(
            value = spend[[7]][1],
            location = ph_location_label(ph_label = "Text Placeholder 48")
          )  %>%
          ph_with(
            value = spend[[8]][1],
            location = ph_location_label(ph_label = "Text Placeholder 50")
          )  %>%
          ph_with(
            value = spend[[9]][1],
            location = ph_location_label(ph_label = "Text Placeholder 52")
          )  %>%
          ph_with(
            value = spend[[10]][1],
            location = ph_location_label(ph_label = "Text Placeholder 54")
          )
        
      } else {
        
        add_slide(br_pptx,
                  layout = "Shopper Profile",
                  master = "QBR Template") %>%
          ph_with(
            value = external_img(paste0(file_path, "_07.png")),
            location = ph_location_label(ph_label = "Picture Placeholder 56")
          ) %>%
          ph_with(
            value = external_img(paste0(file_path, "_06.png")),
            location = ph_location_label(ph_label = "Picture Placeholder 60")
          ) %>%
          ph_with(
            value = period,
            location = ph_location_label(ph_label = "Text Placeholder 12")
          )  %>%
          ph_with(
            value = spend[[7]][2],
            location = ph_location_label(ph_label = "Text Placeholder 38")
          )  %>%
          ph_with(
            value = spend[[8]][2],
            location = ph_location_label(ph_label = "Text Placeholder 40")
          )  %>%
          ph_with(
            value = spend[[9]][2],
            location = ph_location_label(ph_label = "Text Placeholder 43")
          )  %>%
          ph_with(
            value = spend[[10]][2],
            location = ph_location_label(ph_label = "Text Placeholder 46")
          )  %>%
          ph_with(
            value = spend[[7]][1],
            location = ph_location_label(ph_label = "Text Placeholder 48")
          )  %>%
          ph_with(
            value = spend[[8]][1],
            location = ph_location_label(ph_label = "Text Placeholder 50")
          )  %>%
          ph_with(
            value = spend[[9]][1],
            location = ph_location_label(ph_label = "Text Placeholder 52")
          )  %>%
          ph_with(
            value = spend[[10]][1],
            location = ph_location_label(ph_label = "Text Placeholder 54")
          )
        
      }
      
    } else {
      
      if (file.exists(paste0(file_path, "_08.png"))) {
        
        add_slide(br_pptx,
                  layout = "Shopper Profile Company",
                  master = "QBR Template") %>%
          ph_with(
            value = external_img(paste0(file_path, "_06.png")),
            location = ph_location_label(ph_label = "Picture Placeholder 60")
          ) %>%
          ph_with(
            value = external_img(paste0(file_path, "_08.png")),
            location = ph_location_label(ph_label = "Picture Placeholder 62")
          )  %>%
          ph_with(
            value = period,
            location = ph_location_label(ph_label = "Text Placeholder 12")
          )  %>%
          ph_with(
            value = spend[[7]][1],
            location = ph_location_label(ph_label = "Text Placeholder 48")
          )  %>%
          ph_with(
            value = spend[[8]][1],
            location = ph_location_label(ph_label = "Text Placeholder 50")
          )  %>%
          ph_with(
            value = spend[[9]][1],
            location = ph_location_label(ph_label = "Text Placeholder 52")
          )  %>%
          ph_with(
            value = spend[[10]][1],
            location = ph_location_label(ph_label = "Text Placeholder 54")
          )
        
      } else {
        
        add_slide(br_pptx,
                  layout = "Shopper Profile Company",
                  master = "QBR Template") %>%
          ph_with(
            value = external_img(paste0(file_path, "_06.png")),
            location = ph_location_label(ph_label = "Picture Placeholder 60")
          ) %>%
          ph_with(
            value = period,
            location = ph_location_label(ph_label = "Text Placeholder 12")
          )  %>%
          ph_with(
            value = spend[[7]][1],
            location = ph_location_label(ph_label = "Text Placeholder 48")
          )  %>%
          ph_with(
            value = spend[[8]][1],
            location = ph_location_label(ph_label = "Text Placeholder 50")
          )  %>%
          ph_with(
            value = spend[[9]][1],
            location = ph_location_label(ph_label = "Text Placeholder 52")
          )  %>%
          ph_with(
            value = spend[[10]][1],
            location = ph_location_label(ph_label = "Text Placeholder 54")
          )
        
      }
      
    }
    
    
    
    
    
  }
  
  
  if (file.exists(paste0(file_path, "_10.png"))) {
    
    image <- readPNG(paste0(file_path, "_10.png"))
    image_width <- attr(image, "dim")[2] * 0.02645833
    image_height <- attr(image, "dim")[1] * 0.02645833
    sc <- image_width / 23.5
    
    add_slide(template_pptx,
              layout = "Bundle Opportunities",
              master = "QBR Template") %>%
      ph_with(
        value = period,
        location = ph_location_label(ph_label = "Text Placeholder 12")
      ) %>%
      ph_with(
        value = external_img(paste0(file_path, "_10.png"), width = 23.5, height = image_height / sc, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 9"),
        use_loc_size = FALSE
      )
    
  }
  
  
  if (file.exists(paste0(file_path, "_11.png"))) {
    
    image <- readPNG(paste0(file_path, "_11.png"))
    image_width_1 <- attr(image, "dim")[2] * 0.02645833
    image_height_1 <- attr(image, "dim")[1] * 0.02645833
    sc_1 <- image_width_1 / 7.37
    
    image <- readPNG(paste0(file_path, "_12.png"))
    image_width_2 <- attr(image, "dim")[2] * 0.02645833
    image_height_2 <- attr(image, "dim")[1] * 0.02645833
    sc_2 <- image_width_2 / 7.37
    
    image <- readPNG(paste0(file_path, "_13.png"))
    image_width_3 <- attr(image, "dim")[2] * 0.02645833
    image_height_3 <- attr(image, "dim")[1] * 0.02645833
    sc_3 <- image_width_3 / 7.37
    
    add_slide(br_pptx,
              layout = "Missed Cross Sells",
              master = "QBR Template") %>%
      ph_with(
        value = period,
        location = ph_location_label(ph_label = "Text Placeholder 12")
      ) %>%
      ph_with(
        value = missed_cross_sells_categories[[8]][1],
        location = ph_location_label(ph_label = "Text Placeholder 22")
      ) %>%
      ph_with(
        value = missed_cross_sells_categories[[8]][2],
        location = ph_location_label(ph_label = "Text Placeholder 24")
      ) %>%
      ph_with(
        value = missed_cross_sells_categories[[8]][3],
        location = ph_location_label(ph_label = "Text Placeholder 26")
      ) %>%
      ph_with(
        value = missed_cross_sells_categories[[3]][1],
        location = ph_location_label(ph_label = "Text Placeholder 28")
      ) %>%
      ph_with(
        value = missed_cross_sells_categories[[3]][2],
        location = ph_location_label(ph_label = "Text Placeholder 30")
      ) %>%
      ph_with(
        value = missed_cross_sells_categories[[3]][3],
        location = ph_location_label(ph_label = "Text Placeholder 32")
      ) %>%
      ph_with(
        value = external_img(paste0(file_path, "_11.png"), width = 7.37, height = image_height_1 / sc_1, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 34"),
        use_loc_size = FALSE
      ) %>%
      ph_with(
        value = external_img(paste0(file_path, "_12.png"), width = 7.37, height = image_height_2 / sc_2, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 36"),
        use_loc_size = FALSE
      ) %>%
      ph_with(
        value = external_img(paste0(file_path, "_13.png"), width = 7.37, height = image_height_3 / sc_3, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 38"),
        use_loc_size = FALSE
      )
    
  }
  
}



title_slide <- function(br_pptx, company_account, period) { 
  
  add_slide(br_pptx,
            layout = "Cover Slide",
            master = "QBR Template") %>%
    ph_with(
      value = company_account,
      location = ph_location_label(ph_label = "Text Placeholder 10")
    ) %>%
    ph_with(
      value = period,
      location = ph_location_label(ph_label = "Text Placeholder 12")
    )
  
}



performance_overview <- function(br_pptx, file_path) {
  
  add_slide(br_pptx,
            layout = "Across Retailers Title",
            master = "QBR Template")
  
  image <- readPNG(file_path)
  image_width <- attr(image, "dim")[2] * 0.02645833
  image_height <- attr(image, "dim")[1] * 0.02645833
  sc <- image_width / 23.82
  
  add_slide(br_pptx,
            layout = "Across Retailers Overview",
            master = "QBR Template") %>%
    ph_with(
      value = full_period,
      location = ph_location_label(ph_label = "Text Placeholder 12")
    ) %>%
    ph_with(
      value = external_img(file_path, width = 7.37, height = image_height / sc, unit = 'cm'),
      location = ph_location_label(ph_label = "Picture Placeholder 15")
    )
  
}

color_format <- function(val) {
  
  return(ifelse(str_contains(val, "+"), '#87BF39', ifelse(str_contains(val, "-"), '#EF676A', '#a1a4b2')))
  
}


market_overview_unmasked <- function(template_pptx, file_path_1, file_path_2, file_path_3, ove, dec) {
  
  image <- readPNG(file_path_1)
  image_width_1 <- attr(image, "dim")[2] * 0.02645833
  image_height_1 <- attr(image, "dim")[1] * 0.02645833
  sc_1 <- image_width_1 / 7.28
  
  image <- readPNG(file_path_2)
  image_width_2 <- attr(image, "dim")[2] * 0.02645833
  image_height_2 <- attr(image, "dim")[1] * 0.02645833
  sc_2 <- image_width_2 / 7.28
  
  image <- readPNG(file_path_3)
  image_width_3 <- attr(image, "dim")[2] * 0.02645833
  image_height_3 <- attr(image, "dim")[1] * 0.02645833
  sc_3 <- image_width_3 / 7.28
  
  add_slide(template_pptx,
            layout = "Retailer Title",
            master = "QBR Template") %>%
    ph_with(
      value = site_details$retailer[1],
      location = ph_location_label(ph_label = "Text Placeholder 10")
    )
  
  add_slide(template_pptx,
            layout = "Market Overview",
            master = "QBR Template") %>%
    ph_with(
      value = full_period,
      location = ph_location_label(ph_label = "Text Placeholder 12")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'val', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 27")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'right'),
                   fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'val_e', 2])),
                   values = ove[ove$variable == 'val_e', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 29")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'val_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 31")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'right'),
                   fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'val_ce', 2])),
                   values = ove[ove$variable == 'val_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 33")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'val_s', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 35")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'right'),
                   fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'val_sd', 2])),
                   values = ove[ove$variable == 'val_sd', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 37")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'unt', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 54")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'unt_e', 2])),
                   values = ove[ove$variable == 'unt_e', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 72")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'ord', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 56")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'ord_e', 2])),
                   values = ove[ove$variable == 'ord_e', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 74")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'prc', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 58")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'prc_e', 2])),
                   values = ove[ove$variable == 'prc_e', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 76")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'unt_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 60")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'unt_ce', 2])),
                   values = ove[ove$variable == 'unt_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 78")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'ord_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 62")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'ord_ce', 2])),
                   values = ove[ove$variable == 'ord_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 80")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'prc_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 64")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'prc_ce', 2])),
                   values = ove[ove$variable == 'prc_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 82")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'unt_s', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 66")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'unt_sd', 2])),
                   values = ove[ove$variable == 'unt_sd', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 84")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'pen', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 68")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'pen_d', 2])),
                   values = ove[ove$variable == 'pen_d', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 86")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'prc_i', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 70")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'prc_id', 2])),
                   values = ove[ove$variable == 'prc_id', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 88")
    ) %>%
    ph_with(
      value = external_img(file_path_1, width = 7.28, height = image_height_1 / sc_1, unit = 'cm'),
      location = ph_location_label(ph_label = "Picture Placeholder 39"),
      use_loc_size = FALSE
    ) %>%
    ph_with(
      value = external_img(file_path_2, width = 7.28, height = image_height_2 / sc_2, unit = 'cm'),
      location = ph_location_label(ph_label = "Picture Placeholder 41"),
      use_loc_size = FALSE
    ) %>%
    ph_with(
      value = external_img(file_path_3, width = 7.28, height = image_height_3 / sc_3, unit = 'cm'),
      location = ph_location_label(ph_label = "Picture Placeholder 43"),
      use_loc_size = FALSE
    )
  
  add_slide(template_pptx,
            layout = "Sales Drivers",
            master = "QBR Template") %>%
    ph_with(
      value = full_period,
      location = ph_location_label(ph_label = "Text Placeholder 12")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'val_ce', 2])),
                   values = ove[ove$variable == 'val_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 115")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'val_cd', 2])),
                   values = dec[dec$variable == 'val_cd', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 117")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'val_re', 2])),
                   values = dec[dec$variable == 'val_re', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 119")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'val_rd', 2])),
                   values = dec[dec$variable == 'val_rd', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 121")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'qc_c', 2])),
                   values = dec[dec$variable == 'qc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 123")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'qm_c', 2])),
                   values = dec[dec$variable == 'qm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 125")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'pc_c', 2])),
                   values = dec[dec$variable == 'pc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 127")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'pm_c', 2])),
                   values = dec[dec$variable == 'pm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 129")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'mc_c', 2])),
                   values = dec[dec$variable == 'mc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 131")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'mm_c', 2])),
                   values = dec[dec$variable == 'mm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 133")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'rc_c', 2])),
                   values = dec[dec$variable == 'rc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 135")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'rm_c', 2])),
                   values = dec[dec$variable == 'rm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 137")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'qc_r', 2])),
                   values = dec[dec$variable == 'qc_r', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 139")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'qm_r', 2])),
                   values = dec[dec$variable == 'qm_r', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 141")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'pc_r', 2])),
                   values = dec[dec$variable == 'pc_r', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 143")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'pm_r', 2])),
                   values = dec[dec$variable == 'pm_r', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 145")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'mc_r', 2])),
                   values = dec[dec$variable == 'mc_r', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 147")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'mm_r', 2])),
                   values = dec[dec$variable == 'mm_r', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 149")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'rc_r', 2])),
                   values = dec[dec$variable == 'rc_r', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 151")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'rm_r', 2])),
                   values = dec[dec$variable == 'rm_r', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 153")
    )
  
}

category_base_slides <- function(template_pptx, file_path_1, file_path_2, file_path_3, seg, competition) {
  
  add_slide(template_pptx,
            layout = "Category Title",
            master = "QBR Template") %>%
    ph_with(
      value = paste0(seg, " IN ", site_details$retailer[1]),
      location = ph_location_label(ph_label = "Text Placeholder 10")
    )
  
  image <- readPNG(file_path_1)
  image_width <- attr(image, "dim")[2] * 0.02645833
  image_height <- attr(image, "dim")[1] * 0.02645833
  sc <- image_width / 23.82
  
  if (competition == T) {
    
    add_slide(template_pptx,
              layout = "Category Demand",
              master = "QBR Template") %>%
      ph_with(
        value = full_period,
        location = ph_location_label(ph_label = "Text Placeholder 12")
      ) %>%
      ph_with(
        value = external_img(file_path_1, width = 23.82, height = image_height / sc, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 15"),
        use_loc_size = FALSE
      )
    
  } else {
    
    add_slide(template_pptx,
              layout = "Category Demand Collab",
              master = "QBR Template") %>%
      ph_with(
        value = full_period,
        location = ph_location_label(ph_label = "Text Placeholder 12")
      ) %>%
      ph_with(
        value = external_img(file_path_1, width = 23.82, height = image_height / sc, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 15"),
        use_loc_size = FALSE
      )
    
  }
  
  image <- readPNG(file_path_2)
  image_width <- attr(image, "dim")[2] * 0.02645833
  image_height <- attr(image, "dim")[1] * 0.02645833
  sc <- image_width / 23.82
  
  if (competition == T) {
    
    add_slide(template_pptx,
              layout = "Category Basket Analysis",
              master = "QBR Template") %>%
      ph_with(
        value = full_period,
        location = ph_location_label(ph_label = "Text Placeholder 12")
      ) %>%
      ph_with(
        value = external_img(file_path_2, width = 23.82, height = image_height / sc, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 21"),
        use_loc_size = FALSE
      )
    
  } else {
    
    add_slide(template_pptx,
              layout = "Category Basket Analysis Collab",
              master = "QBR Template") %>%
      ph_with(
        value = full_period,
        location = ph_location_label(ph_label = "Text Placeholder 12")
      ) %>%
      ph_with(
        value = external_img(file_path_2, width = 23.82, height = image_height / sc, unit = 'cm'),
        location = ph_location_label(ph_label = "Picture Placeholder 21"),
        use_loc_size = FALSE
      )
    
  }
  
  
  
  image <- readPNG(file_path_3)
  image_width <- attr(image, "dim")[2] * 0.02645833
  image_height <- attr(image, "dim")[1] * 0.02645833
  sc <- image_width / 23.82
  
  add_slide(template_pptx,
            layout = "Buy Rate Analysis",
            master = "QBR Template") %>%
    ph_with(
      value = full_period,
      location = ph_location_label(ph_label = "Text Placeholder 12")
    ) %>%
    ph_with(
      value = external_img(file_path_3, width = 23.82, height = image_height / sc, unit = 'cm'),
      location = ph_location_label(ph_label = "Picture Placeholder 15"),
      use_loc_size = FALSE
    )
  
  
}

end_slides <- function(br_pptx) { 
  
  add_slide(br_pptx,
            layout = "Appendix",
            master = "QBR Template")
  
  add_slide(br_pptx,
            layout = "Optional",
            master = "QBR Template")
  
  add_slide(br_pptx,
            layout = "Last Slide",
            master = "QBR Template")
  
}


market_overview_evos <- function(template_pptx, file_path_1, file_path_2, file_path_3, ove, dec) {
  
  image <- readPNG(file_path_1)
  image_width_1 <- attr(image, "dim")[2] * 0.02645833
  image_height_1 <- attr(image, "dim")[1] * 0.02645833
  sc_1 <- image_width_1 / 7.28
  
  image <- readPNG(file_path_2)
  image_width_2 <- attr(image, "dim")[2] * 0.02645833
  image_height_2 <- attr(image, "dim")[1] * 0.02645833
  sc_2 <- image_width_2 / 7.28
  
  image <- readPNG(file_path_3)
  image_width_3 <- attr(image, "dim")[2] * 0.02645833
  image_height_3 <- attr(image, "dim")[1] * 0.02645833
  sc_3 <- image_width_3 / 7.28
  
  add_slide(template_pptx,
            layout = "Retailer Title",
            master = "QBR Template") %>%
    ph_with(
      value = site_details$retailer[1],
      location = ph_location_label(ph_label = "Text Placeholder 10")
    )
  
  add_slide(template_pptx,
            layout = "Market Overview",
            master = "QBR Template") %>%
    ph_with(
      value = full_period,
      location = ph_location_label(ph_label = "Text Placeholder 12")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'val', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 27")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'right'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 29")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'val_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 31")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'right'),
                   fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'val_ce', 2])),
                   values = ove[ove$variable == 'val_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 33")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'val_s', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 35")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'right'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 37")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'unt', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 54")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 72")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'ord', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 56")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 74")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'prc', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 58")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 76")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'unt_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 60")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'unt_ce', 2])),
                   values = ove[ove$variable == 'unt_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 78")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'ord_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 62")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'ord_ce', 2])),
                   values = ove[ove$variable == 'ord_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 80")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'prc_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 64")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'prc_ce', 2])),
                   values = ove[ove$variable == 'prc_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 82")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'unt_s', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 66")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 84")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'pen', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 68")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 86")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'prc_i', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 70")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 88")
    ) %>%
    ph_with(
      value = external_img(file_path_1, width = 7.28, height = image_height_1 / sc_1, unit = 'cm'),
      location = ph_location_label(ph_label = "Picture Placeholder 39"),
      use_loc_size = FALSE
    ) %>%
    ph_with(
      value = external_img(file_path_2, width = 7.28, height = image_height_2 / sc_2, unit = 'cm'),
      location = ph_location_label(ph_label = "Picture Placeholder 41"),
      use_loc_size = FALSE
    ) %>%
    ph_with(
      value = external_img(file_path_3, width = 7.28, height = image_height_3 / sc_3, unit = 'cm'),
      location = ph_location_label(ph_label = "Picture Placeholder 43"),
      use_loc_size = FALSE
    )
  
  add_slide(template_pptx,
            layout = "Sales Drivers",
            master = "QBR Template") %>%
    ph_with(
      value = full_period,
      location = ph_location_label(ph_label = "Text Placeholder 12")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'val_ce', 2])),
                   values = ove[ove$variable == 'val_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 115")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'val_cd', 2])),
                   values = dec[dec$variable == 'val_cd', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 117")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 119")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 121")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'qc_c', 2])),
                   values = dec[dec$variable == 'qc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 123")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'qm_c', 2])),
                   values = dec[dec$variable == 'qm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 125")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'pc_c', 2])),
                   values = dec[dec$variable == 'pc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 127")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'pm_c', 2])),
                   values = dec[dec$variable == 'pm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 129")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'mc_c', 2])),
                   values = dec[dec$variable == 'mc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 131")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'mm_c', 2])),
                   values = dec[dec$variable == 'mm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 133")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'rc_c', 2])),
                   values = dec[dec$variable == 'rc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 135")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'rm_c', 2])),
                   values = dec[dec$variable == 'rm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 137")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 139")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 141")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 143")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 145")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 147")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 149")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 151")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = '#a1a4b2'),
                   values = "-"),
      location = ph_location_label(ph_label = "Text Placeholder 153")
    )
  
}



market_overview_masked <- function(template_pptx, file_path_1, ove, dec) {
  
  image <- readPNG(file_path_1)
  image_width_1 <- attr(image, "dim")[2] * 0.02645833
  image_height_1 <- attr(image, "dim")[1] * 0.02645833
  sc_1 <- image_width_1 / 7.28
  
  add_slide(template_pptx,
            layout = "Retailer Title",
            master = "QBR Template") %>%
    ph_with(
      value = site_details$retailer[1],
      location = ph_location_label(ph_label = "Text Placeholder 10")
    )
  
  add_slide(template_pptx,
            layout = "Collaborate Overview",
            master = "QBR Template") %>%
    ph_with(
      value = full_period,
      location = ph_location_label(ph_label = "Text Placeholder 12")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'val_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 31")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'right'),
                   fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'val_ce', 2])),
                   values = ove[ove$variable == 'val_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 33")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'unt_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 60")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'unt_ce', 2])),
                   values = ove[ove$variable == 'unt_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 78")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'ord_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 62")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'ord_ce', 2])),
                   values = ove[ove$variable == 'ord_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 80")
    ) %>%
    ph_with(
      value = ove[ove$variable == 'prc_c', 2][[1]],
      location = ph_location_label(ph_label = "Text Placeholder 64")
    )  %>%
    ph_with(
      value = fpar(fp_t = fp_text_lite(color = color_format(ove[ove$variable == 'prc_ce', 2])),
                   values = ove[ove$variable == 'prc_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 82")
    ) %>%
    ph_with(
      value = external_img(file_path_1, width = 7.28, height = image_height_1 / sc_1, unit = 'cm'),
      location = ph_location_label(ph_label = "Picture Placeholder 41"),
      use_loc_size = FALSE
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'val_ce', 2])),
                   values = ove[ove$variable == 'val_ce', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 115")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'val_cd', 2])),
                   values = dec[dec$variable == 'val_cd', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 117")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'qc_c', 2])),
                   values = dec[dec$variable == 'qc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 123")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'qm_c', 2])),
                   values = dec[dec$variable == 'qm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 125")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'pc_c', 2])),
                   values = dec[dec$variable == 'pc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 127")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'pm_c', 2])),
                   values = dec[dec$variable == 'pm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 129")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'mc_c', 2])),
                   values = dec[dec$variable == 'mc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 131")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'mm_c', 2])),
                   values = dec[dec$variable == 'mm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 133")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'rc_c', 2])),
                   values = dec[dec$variable == 'rc_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 135")
    )  %>%
    ph_with(
      value = fpar(fp_p = fp_par(text.align = 'center'),
                   fp_t = fp_text_lite(color = color_format(dec[dec$variable == 'rm_c', 2])),
                   values = dec[dec$variable == 'rm_c', 2]),
      location = ph_location_label(ph_label = "Text Placeholder 137")
    )
  
}



























