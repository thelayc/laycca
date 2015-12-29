#' NWEA Norms data 2015 (status)
#'
#' Data from the RIT Scale Norms Study 2015
#'
#' @source NWEA, Northwest Evaluation Association,
#'  \url{https://legacysupport.nwea.org/support/article/norms-study-resources}
#' @format Data frame with columns
#' \describe{
#' \item{season}{Term. Possible Values: 
#' 4 = Beginning of year (Fall),
#' 1 = Middle of year (Winter),
#' 2 = End of year (Spring),
#' 3 = Norms not available for this season (Summer)"}
#' \item{grade}{Focal grade (the grade regarded as the present grade of focus for the purposes of norms look-up)
#' Grade 13 refers to kindergarten}
#' \item{subject}{Measurement Scale.	Possible Values: 
#' 1 = Mathematics,
#' 2 = Reading,
#' 3 = Language Usage
#' 4 = General science
#' As of 2015, Science Concepts and Processes is no longer available}
#' \item{student_pctile}{Percentile associated with student RIT score for subject, grade, and season
#' Range = 1-99%}
#' \item{rit}{RIT score}
#' }
"norms_status_2015"