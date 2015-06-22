#' export_nwea()
#'
#' Helper function to export formatted NWEA data as .csv for upload in ETO
#' @param df dataframe: formatted NWEA data
#' @return csv file
#' @export
#' @examples
#' nwea <- load_csv(data_folder = './path/to/data_folder')
#' nwea <- clean_nwea(df = nwea)
#' nwea <- format_nwea(df = nwea)
#' export(df = nwea, path = './output')
#' 

export_nwea <- function(df, path = './') {
  
  df <- as.data.frame(df)
  
  # Get name for csv file
  assertthat::assert_that(length(unique(df['Term_3245'])) == 1) 
  assertthat::assert_that(length(unique(df['School year_3247'])) == 1)
  csv_name <- tolower(paste('nwea', as.character(unique(df[, 'Term_3245'])), unique(df['School year_3247']), sep = '_'))
  csv_name <- gsub(pattern = '-', replacement = '_', x = csv_name)
  
  write.csv(x = df, file = paste0(path, csv_name, '.csv'), row.names = FALSE, na = '')
}
