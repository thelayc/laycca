#' Helper function to format NWEA data for upload in ETO
#' @param df dataframe: NWEA data exported from the website
#' @return dataframe
#' @export
#' @examples
#' nwea <- load_csv(data_folder = './path/to/data_folder')
#' nwea <- clean_nwea(df = nwea)
#' nwea <- format_nwea(df = nwea)
#' 

format_nwea <- function(df) {
  
  # select subset of columns to upload
  keep <- c("id", "fname", "dob", "TestStartDate", "school_year", "term", "TestRITScore")
  df <- df[, keep]
  
  # Add addtional columns
  df$site <- NA
  df$program <- NA
  df$update <-NA
  df$response_id <- NA
  
  # Reorder columns
  new_order <- c("id", "fname", "dob", "site", "program", "TestStartDate", "update", "response_id", "school_year", "term", "TestRITScore")
  df <- df[, new_order]
  
  # Get name for csv file
  assertthat::assert_that(length(unique(df$term)) == 1)
  assertthat::assert_that(length(unique(df$school_year)) == 1)
  csv_name <- tolower(paste('nwea', unique(df$term), unique(df$school_year), '.csv', sep = '_'))
  
  # rename columns for upload
  colnames(df) <- c("Participant Identifier",	"First Name",	"DOB",	"Site Name",	"Program Name",	"Response Date",	"Update or Insert",
                    "Response ID",	"School year_3247",	"Term_3245",	"RIT Reading score_3246")
  
  }