combine_animation_frames <- function(out_file, animation_cfg, task_names=NULL, intro_config, n_outro) {

  ## I still want to use a better way than just assuming what is in tmp will be used
  
  # use ffmpeg to build a videos
  png_frames <- list.files('6_visualize/tmp', full.names = TRUE)
  png_frames_right <- png_frames[grep('gif_frame_a_', png_frames)]
  tmp_dir_video <- '6_visualize/tmp/video'
  if(dir.exists(tmp_dir_video)) {
    existing_files <- list.files(tmp_dir_video, full.names = TRUE)
    if(length(existing_files) > 0) file.remove(existing_files)
  } else { 
    dir.create('6_visualize/tmp/video') 
  }
<<<<<<< HEAD
  system(magick_command)

  # simplify the gif with gifsicle - cuts size by about 2/3
  stopifnot(task_names == '*')

  png_dir <- dirname(png_files)
  png_patt <- basename(png_files) %>% tools::file_path_sans_ext()
  total_frames <- grepl(dir(png_dir), pattern = png_patt) %>% sum()
  # how many intro frames? how many storm frames? how many outro frames?
  intro_delay <- intro_config$frame_delay_cs
  storm_delay <- animation_cfg$frame_delay_cs
  outro_delay <- 200
  final_delay <- 700
  freeze_delay <- 150
  # **trash code for now:
  calc_delays <- function(delay, start_frame, end_frame){
    paste(paste(sprintf('-d%s "#', delay), seq(start_frame-1, end_frame-1), sep = '') %>%
            paste('"', sep = ''), collapse = " ")
  }
  intro_delays <- calc_delays(intro_delay, 1, intro_config$n_frames)
  storm_delays <- calc_delays(storm_delay, intro_config$n_frames+1, total_frames-n_outro-1)
  # freeze the last storm frame too for as long as we are showing each outro frame:
  last_storm_delay <- calc_delays(freeze_delay, total_frames-n_outro, total_frames-n_outro)
  outro_delays <- calc_delays(outro_delay, total_frames-n_outro+1, total_frames-1)
  final_delay <- calc_delays(final_delay, total_frames, total_frames)

  gifsicle_command <- sprintf('gifsicle -b -O3 %s %s %s %s %s %s --colors 256', gif_file, intro_delays, storm_delays, last_storm_delay, outro_delays, final_delay)
  system(gifsicle_command)
=======
  file_name_df <- tibble(origName = png_frames,
                         countFormatted = zeroPad(1:length(png_frames), padTo = 3),
                         newName = file.path("6_visualize/tmp/video", paste0("gif_frame_", countFormatted, ".png")))
  file.copy(from = file_name_df$origName, to = file_name_df$newName)
  shell_command <- sprintf(
    "ffmpeg -y -framerate %s -i 6_visualize/tmp/video/gif_frame_%%03d.png -r %s -pix_fmt yuv420p %s",
    animation_cfg$video_cfg$frame_rate, animation_cfg$video_cfg$frame_rate, out_file)
  
  system(shell_command)
  file.remove(file_name_df$newName)
>>>>>>> 93c183c1ad9828acc49207b1b3855282a8cc37c9
}
