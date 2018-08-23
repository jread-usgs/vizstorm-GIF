
prep_legend_fun <- function(precip_bins, legend_styles, storm_points_sf, DateTime=NA, x_pos = c('left', 'right'), y_pos = c('bottom','top')){

  x_pos <- match.arg(x_pos)
  y_pos <- match.arg(y_pos)


  plot_fun <- function(){

    leg_cex <- 2
    h_dot_cex <- 3.5
    col_cex <- 2.0

    if(is.na(DateTime)) DateTime <- min(storm_points_sf$DateTime)
    this_DateTime <- as.POSIXct(DateTime, tz = "UTC") # WARNING, IF WE EVER MOVE FROM UTC elsewhere, this will be fragile/bad.
    this_dot <- filter(storm_points_sf, DateTime == this_DateTime)
    hurricane_col <- legend_styles$hurricane_cols[(this_dot$SS + 1)]
    hurricane_cat <- legend_styles$hurricane_col_names[(this_dot$SS + 1)]
    coord_space <- par()$usr
    bin_w_perc <- 0.06 # percentage of X domain
    bin_h_perc <- 0.025 # *also* percentage of X domain
    bin_w <- bin_w_perc * diff(coord_space[c(1,2)])
    bin_h <- bin_h_perc * diff(coord_space[c(1,2)])
    if (x_pos == 'left'){
      txt_pos = 4
      x_edge <- coord_space[1] + bin_h/3
      shift_dir <- 1
      bin_j <- 1:nrow(precip_bins)
      xright <- x_edge+bin_w
    } else if (x_pos == 'right'){
      txt_pos = 2
      x_edge <- coord_space[2] - bin_h/3
      shift_dir <- -1
      bin_j <- nrow(precip_bins):1
      xright <- x_edge
    }


    ybottom <- coord_space[3]+bin_h/3
    for (j in bin_j){
      col <- as.character(precip_bins$col[j])
      text_col <- ifelse(any(col2rgb(col) < 130), 'white','black')
      rect(xleft = xright-bin_w, ybottom = ybottom, xright = xright, ytop = ybottom+bin_h, col = col, border = NA)
      text_char <- as.character(precip_bins$break_factor[j]) %>% gsub(pattern = ',', replacement = '-') %>% gsub(pattern = '-Inf', replacement = '+') %>% gsub(pattern = "\\(|\\]", replacement = '')
      text(xright-bin_w/2, ybottom+bin_h/2, text_char, col = text_col, cex = col_cex)

      xright <- xright+bin_w*shift_dir
    }

    precip_txt_y <- ybottom+2*bin_h*0.8
    flood_y <- ybottom+3*bin_h
    normal_y <- ybottom+4*bin_h
    gage_caveat_y <- ybottom+5*bin_h*1.02
    hurricane_y <- ybottom+6*bin_h*1.1
    title_y <- ybottom+7*bin_h*1.1

    dot_x <- x_edge+bin_w/4*shift_dir
    dot_txt_x <- x_edge+bin_w*0.5*shift_dir

    text(x_edge, precip_txt_y, labels = 'NOAA total rainfall amount (inches)', pos = txt_pos, cex = leg_cex)
    points(dot_x, flood_y, pch = 21, bg = legend_styles$gage_norm_col, col = legend_styles$gage_flood_col, lwd = 4, cex = col_cex)
    text(dot_txt_x, flood_y, labels = 'Above flood stage', pos = txt_pos, cex = leg_cex)
    points(dot_x, normal_y, pch = 21, bg = legend_styles$gage_norm_col, col = NA, cex = col_cex)
    text(dot_txt_x, normal_y, labels = 'Below flood stage', pos = txt_pos, cex = leg_cex)
    text(x_edge, gage_caveat_y, labels = 'USGS Stream Gages (< 1% of U.S. total)', pos = txt_pos, cex = leg_cex)
    text(dot_txt_x, hurricane_y, labels = "", pos = txt_pos, cex = leg_cex)

    h_dot_x <- dot_x

    points(h_dot_x, hurricane_y, pch = 21, bg = hurricane_col, col = NA, cex = h_dot_cex)

  }
  return(plot_fun)
}
