#' plot_individual_scores()
#'
#' plot RIT reading score for each students on the roster
#' @param df data.frame: Name of the data frame containing NWEA data
#' @param score character: Name of the score column in df
#' @param my_title character: Main title of the chart
#' @param my_lab character: y-axis title
#' @param my_palette character: hexadecimal color values
#' @import ggplot2
#' @return ggplot
#' @export


plot_individual_scores <- function(df,
                                   score = 'rit',
                                   my_title = paste("Individual students' scores on the RIT reading scale\n"),
                                   my_lab = paste('RIT Reading score'),
                                   my_palette = c('#2CA02C', '#FF7F0E', '#D62728')) { 
  
  testing_period <- paste(as.character(unique(df$term)), unique(df$school_year))
  my_title <- paste(my_title, testing_period)
  
  p <- ggplot(data = df, aes_(
    x = reorder(paste(fname, lname), as.name(score)),
    y = as.name(score),
    col = as.name(score)
  ))
  p <- p + geom_point(size = rel(4))
  p <- p + coord_flip()
  p <- p + scale_color_gradient2(low = scales::muted(my_palette[3]), 
                                 mid = my_palette[2], 
                                 high = scales::muted(my_palette[1]),
                                 midpoint = median(df[[as.name(score)]]))
  p <- p + ylab(my_lab)
  p <- p + ggtitle(my_title)
  p <- p + theme(
    axis.ticks.y = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.background = element_blank()
  )
}

#' plot_distribution()
#'
#' plot distribution of RIT reading scores
#' @param df data.frame: Name of the data frame containing NWEA data
#' @return ggplot
#' @export

plot_distribution <- function(df){
  
  testing_period <- paste(as.character(unique(df$term)), unique(df$school_year))
  my_title = paste('Distribution of RIT Reading scores\n', testing_period)
  my_ylab <- paste('RIT Reading score\n')
  
  p <- ggplot(data = df, aes(x = testing_period, y = rit))
  p <- p + geom_boxplot(alpha = .8, fill = scales::muted('#FF7F0E'))
  p <- p + ggthemes::theme_hc()
  p <- p + ggtitle(my_title)
  p <- p + ylab(my_ylab)
  p <- p + theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title.x = element_blank(),
    legend.title = element_blank()
  )
}