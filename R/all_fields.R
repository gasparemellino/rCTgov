#' All Study Fields
#'
#' @description Return all available study fields on clinicaltrials.gov
#' @return vector
#' @export 
#'
#' @import rjson
#'
#' @examples
#' \dontrun{
#' fields <- all_fields()
#' }
#' 
all_fields <- function() {
  return(rjson::fromJSON(file = "https://clinicaltrials.gov/api/info/study_fields_list?fmt=JSON")$StudyFields$Fields)
}