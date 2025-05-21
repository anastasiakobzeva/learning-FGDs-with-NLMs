# Analysis functions

## Function for summing up the surprisal by region

# Assuming that the dataframe has the following columns: region, 
# sent_index, comp, gap, gap_position
# Aggregating the data by summing up surprisal values in each region
region.surprisal = function(data) {
  data = data %>% 
    group_by(region, sent_index, comp, gap, gap_position) %>% 
    summarise(surprisal = sum(surprisal),
              region_text = paste0(word, collapse = " ")) %>%
    ungroup() %>% 
    # mutate(comp = if_else(comp == "comp", "that", comp)) %>% #changing comp to that
    mutate(wh_numeric = if_else(comp == "that", -0.5, 0.5),
           gap_numeric = if_else(gap == "gap", 0.5, -0.5),
           comp = factor(comp, levels = c("what", "that")),
           gap = factor(gap, levels = c("no-gap", "gap")))
}

## Function for plotting raw surprisal values by region

raw.surprisal.plot = function(data, name, path, regions, color_choice){
  # Plot label details
  # plot_title = paste("Raw surprisal by region, ", name, sep = "")
  # path example suggestion: adjunct_plots/adjunct regions raw 
  file_name = paste(path, name, ".png", sep = "")
  
  gap.labs = c("-GAP (Filled GE)", "+GAP (Unlicensed GE)")
  names(gap.labs) = c("no-gap", "gap")
  linetype = c('solid', 'dashed')
  
  # Creating the plot
  plot = data %>%
    group_by(region, gap, gap_position, comp) %>%
    summarise(m = mean(surprisal),
              s = std.error(surprisal), # from plotrix
              upper = m + 1.96*s,  # assuming normality, this is a 95% CI
              lower = m - 1.96*s) %>%
    ungroup() %>%
    mutate(region = as.numeric(region)) %>% 
    ggplot(aes(x = region, y = m, ymax = upper, ymin = lower, linetype = comp)) + 
    geom_line(color = color_choice) + 
    theme_bw() +
    geom_errorbar(linetype = "solid", width = .1, color = color_choice) +
    scale_x_continuous(breaks = seq(1, length(regions)), labels = regions) +
    theme(axis.text.x = element_text(angle=45, hjust=1), 
          axis.title.x = element_blank()) +
    facet_wrap(~gap, ncol=1, labeller = labeller(gap = gap.labs)) + ylab("Surprisal") +
    scale_linetype_manual(name = "Condition", labels = c("+FILLER", "-FILLER"), values = linetype) +
    theme(legend.position = "right")
  
  #ggsave(file_name, width = 8, height = 6)
  #cat("Saved file", file_name)
  return(plot)
}

## Function for calculating filler effects

fe.calculation = function(data){
  # Calculating the filler effects
  data_fe = data %>%
    select(-wh_numeric, -region_text) %>%
    spread(comp, surprisal) %>%
    mutate(filler_effect=what-`that`) %>%
    select(-c(what, that))
  
  return(data_fe)
}

## Function for plotting filler effects by region

fe.regions.plot = function(data, name, path, regions, color_choice){
  # Plot label details 
  # plot_title = paste("Filler effects by region, ", name, sep = "")
  # path example suggestion: adjunct_plots/adjunct regions fe 
  file_name = paste(path, name, ".png", sep = "")
  linetype = c('solid', 'dashed')
  
  # Creating the plot
  plot = data %>%
    group_by(region, gap) %>%
    summarise(m = mean(filler_effect),
              s = std.error(filler_effect),
              upper = m + 1.96*s,
              lower = m - 1.96*s) %>%
    ungroup() %>%
    mutate(region = as.numeric(region)) %>% 
    ggplot(aes(x = region, y = m, ymax = upper, ymin = lower, linetype = gap)) + 
    geom_line(color = color_choice) + 
    theme_bw() +
    geom_errorbar(linetype = "solid", width = .1, color = color_choice) +
    scale_x_continuous(breaks = seq(1, length(regions)), labels = regions) +
    theme(axis.text.x = element_text(angle=45, hjust = 1), 
          axis.title.x = element_blank()) + 
    geom_hline(yintercept = 0, color = "black", alpha = 0.5) +
    ylab("Filler effect") +
    scale_linetype_manual(name = "Condition", labels = c("-GAP", "+GAP"), values = linetype) +
    theme(legend.position="right") 
  
  #ggsave(file_name, width = 8, height = 6)
  #cat("Saved file", file_name)
  return(plot)
}

## Function for calculating mean and error of FE in ROIs

fe.roi.stats = function(data){
  data_stats = data %>%
    select(-region) %>%
    # Error Calculation
    # Across condition mean response
    group_by(sent_index) %>%
    mutate(across_condition_mean = mean(filler_effect)) %>%
    ungroup() %>%
    # Item mean-extracted-response measure
    mutate(item_mean = filler_effect - across_condition_mean) %>%
    # Across item item-mean error
    group_by(gap_position, gap) %>%
    mutate(err = std.error(item_mean, na.rm=T)) %>%
    ungroup() %>%
    select(-item_mean, -across_condition_mean)
  return(data_stats)
}

## Function for plotting filler effects in ROIs

fe.roi.plot = function(data, name, path, color_choice){
  # Plot label details 
  # plot_title = paste("Filler effects in ROIs, ", name, sep = "")
  # path example suggestion: adjunct_plots/adjunct fe roi
  file_name = paste(path, name, ".png", sep = "")
  
  # Creating the plot
  plot = data %>% 
    group_by(gap, gap_position) %>%
    summarise(m = mean(filler_effect),
              s = mean(err),
              upper = m + 1.96*s,
              lower = m - 1.96*s) %>%
    ungroup() %>%
    ggplot(aes(x = gap, y = m, ymin = lower, ymax = upper)) +
    theme_bw() +
    geom_bar(stat = "identity", position = "dodge", fill = color_choice, color = color_choice) +
    geom_errorbar(color = "black", width = .5, position=position_dodge(width = .9)) +
    ylab("Filler effect") + xlab("Condition") +
    theme(legend.position = "right", legend.margin = margin(c(0,0,0,0))) +
    scale_x_discrete(labels = c("-GAP (Filled GE)", "+GAP (Unlicenced GE)"))
  
  #ggsave(file_name)
  #cat("Saved file", file_name)
  return(plot)
}
