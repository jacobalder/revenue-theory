################################################################################
# F609 - Dr. Denvil Duncan
# Date: 4/3/22
# Copyright: Jacob Alder, Indiana University
# E-mail: alderjc@iu.edu
# Dependencies: 
# Outputs: 
# Purpose: Graphs
################################################################################
source("code/stats.R")
plot_usmap(regions = "counties") + 
  labs(title = "US Counties",
       subtitle = "This is a blank map of the counties of the United States.") + 
  theme(panel.background = element_rect(color = "black", fill = "lightblue"))

sample <- data.table(rep(state.name,1))[,values:=rnorm(length(V1))]
setnames(sample,"V1","states")
sample <- as.data.frame(sample)
jcmap(data = sample, values = "values")



# x -----------------------------------------------------------------------
jcmap = function (regions = c("states", "state", "counties", "county"), 
          include = c(), exclude = c(), data = data.frame(), values = "values", 
          theme = theme_map(), labels = FALSE, label_color = "black", 
          ...) 
{
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("`ggplot2` must be installed to use `plot_usmap`.\n         Use: install.packages(\"ggplot2\") and try again.")
  }
  regions_ <- match.arg(regions)
  geom_args <- list(...)
  if (is.null(geom_args[["colour"]]) & is.null(geom_args[["color"]])) {
    geom_args[["color"]] <- "black"
  }
  if (is.null(geom_args[["size"]])) {
    geom_args[["size"]] <- 0.4
  }
  if (is.null(geom_args[["fill"]]) & nrow(data) == 0) {
    geom_args[["fill"]] <- "white"
  }
  else if (!is.null(geom_args[["fill"]]) & nrow(data) != 0) {
    warning("`fill` setting is ignored when `data` is provided. Use `fill` to color regions with solid color when no data is being displayed.")
  }
  if (nrow(data) == 0) {
    map_df <- us_map(regions = regions_, include = include, 
                     exclude = exclude)
    geom_args[["mapping"]] <- ggplot2::aes(x = x, y = y, 
                                           group = group)
  }
  else {
    map_df <- map_with_data(data, values = values, include = include, 
                            exclude = exclude)
    geom_args[["mapping"]] <- ggplot2::aes(x = x, y = y, 
                                           group = group, fill = map_df[, values])
  }
  polygon_layer <- do.call(ggplot2::geom_polygon, geom_args)
  if (labels) {
    centroidLabelsColClasses <- c("numeric", "numeric", "character", 
                                  "character", "character")
    if (regions_ == "county" | regions_ == "counties") {
      centroidLabelsColClasses <- c(centroidLabelsColClasses, 
                                    "character")
    }
    centroid_labels <- utils::read.csv(system.file("extdata", 
                                                   paste0("us_", regions_, "_centroids.csv"), package = "usmap"), 
                                       colClasses = centroidLabelsColClasses, stringsAsFactors = FALSE)
    if (length(include) > 0) {
      centroid_labels <- centroid_labels[centroid_labels$full %in% 
                                           include | centroid_labels$abbr %in% include | 
                                           centroid_labels$fips %in% include, ]
    }
    if (length(exclude) > 0) {
      centroid_labels <- centroid_labels[!(centroid_labels$full %in% 
                                             exclude | centroid_labels$abbr %in% exclude | 
                                             centroid_labels$fips %in% exclude | substr(centroid_labels$fips, 
                                                                                        1, 2) %in% exclude), ]
    }
    if (regions_ == "county" | regions_ == "counties") {
      label_layer <- ggplot2::geom_text(data = centroid_labels, 
                                        ggplot2::aes(x = x, y = y, label = sub(" County", 
                                                                               "", county)), color = label_color)
    }
    else {
      label_layer <- ggplot2::geom_text(data = centroid_labels, 
                                        ggplot2::aes(x = x, y = y, label = abbr), color = label_color)
    }
  }
  else {
    label_layer <- ggplot2::geom_blank()
  }
  ggplot2::ggplot(data = map_df) + polygon_layer + label_layer + 
    ggplot2::coord_equal() + theme
}
# x -----------------------------------------------------------------------







dt.map <- data.frame(dt[abbs!="DC",list(fips,max_local_tr)])
colnames(dt.map) = c("state","local_tax")

plot_usmap(data = countypov, values = "pct_pov_2014", include = c("CT", "ME", "MA", "NH", "VT"), color = "blue") + 
  scale_fill_continuous(low = "white", high = "blue", name = "Poverty Percentage Estimates", label = scales::comma) + 
  labs(title = "New England Region", subtitle = "Poverty Percentage Estimates for New England Counties in 2014") +
  theme(legend.position = "right")

plot_usmap(data = state_utility_policies, 
           values = "securitization_policy") + 
  ## Currently not working, come back to this
  # scale_color_discrete(name = "Securitization Policy" 
  # values = c(color_blind_palette[6], color_blind_palette[9],
  # color_blind_palette[4], color_blind_palette[10])
  # )+
  labs(title = "Securitization Policy by State", color = "Securitization Policy as of November 2021",
       caption = "Source: RMI Utility Transition Hub") +
  theme(legend.position = "right") + 
  theme(panel.background = element_rect(color = "black"))


plot_usmap(
  regions = "states",
  data = dt.map,
  values = "local_tax")

usmap::plot_usmap()



ggsave("figures/lorenz.pdf", units = "in", width = 6, height = 6)

# Output a table
fwrite(dt.q,"figures/out.csv")
suits.out = data.table(suits.excise,suits.iit)
fwrite(suits.out,"figures/suits.csv")
