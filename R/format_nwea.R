#' format_nwea()
#'
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
  df$site <- 'Latin American Youth Center'
  df$program <- 'CA - Full Roster'
  df$update <-'I'
  df$response_id <- NA
  
  # Reorder columns
  new_order <- c("id", "fname", "dob", "site", "program", "TestStartDate", "update", "response_id", "school_year", "term", "TestRITScore")
  df <- df[, new_order]
  
  # rename columns for upload
  colnames(df) <- c("Participant Identifier",	"First Name",	"DOB",	"Site Name",	"Program Name",	"Response Date",	"Update or Insert",
                    "Response ID",	"School year_3247",	"Term_3245",	"RIT Reading score_3246")
  
  return(df)
  
  }