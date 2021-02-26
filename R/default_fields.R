#' Default fields
#'
#' @description Return selected default fields to use when query clinicaltrials.gov
#' @return vector
#' @export 
#'
#'
#' @examples
#' \dontrun{
#' fields <- default_fields()
#' }
#' 
default_fields <- function() {
  default_fields <- c("OrgStudyId",
                      "SecondaryId",
                      "Acronym",
                      "NCTId",
                      "BriefTitle",
                      "OfficialTitle",
                      "MaximumAge",
                      "MinimumAge",
                      "Condition",
                      "Phase",
                      "StudyType",
                      "LeadSponsorName",
                      "StartDate",
                      "CompletionDate",
                      "HealthyVolunteers",
                      "PrimaryOutcomeMeasure",
                      "SecondaryOutcomeMeasure",
                      "OtherOutcomeMeasure",
                      "OverallStatus"
                      )
  
  return(default_fields)
}