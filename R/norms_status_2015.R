#' NWEA Norms data 2015 (status)
#'
#' On-time data for all flights that departed NYC (i.e. JFK, LGA or EWR) in
#' 2013.
#'
#' @source NWEA, Northwest Evaluation Association,
#'  \url{https://legacysupport.nwea.org/support/article/norms-study-resources}
#' @format Data frame with columns
#' \describe{
#' \item{season}{Term Possible Values: 4 = Beginning of year (Fall)
#' 1 = Middle of year (Winter) 2 = End of year (Spring)
#' 3 = Norms not available for this season (Summer)"}
#' \item{grade}{Grade}
#' \item{subject}{Subject}
#' \item{student_pctile}{Student percentile}
#' \item{rit}{RIT score}
#' }
"norms_status_2015"