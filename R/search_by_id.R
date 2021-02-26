#' search using STUDYID or NCT num
#'
#' @description search clinicaltrials.gov using any study id or NCT number
#' 
#' @param id study id or NCT num
#' @param area declares which search area/fields should be searched
#' @param coverage degree to which a search term needs to match the text in an API field. There are four choices: Contains(default), FullMatch, StartsWith, EndsWith
#' @param fields fields to be returned (defaulted to default_fields())
#' @param min_rnk minimum returned searches
#' @param max_rnk maximum returned searches (note: this cannot be > 1000)
#' @param fmt format as per API, defaulted to csv
#' @param output can be WIDE or LONG format
#'
#' @importFrom assertthat assert_that
#'
#' @return data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' res <- search_by_id("BP28248")
#' res <- search_by_id("BP28248", coverage = "FullMatch")
#' res <- search_by_id("NCT01874691", area = c("NCTId"), fields = c("OrgStudyId", "SecondaryId"))
#' res <- search_by_id("BP28248", fields = c("NCTId"))
#' }
#' 
search_by_id <- function(id,
                         area = c("OrgStudyId", "SecondaryId"), #area must not be null
                         coverage = "Contains",
                         fields = default_fields(),
                         min_rnk = 1,
                         max_rnk = 1000,
                         fmt = "csv",
                         output = "WIDE") {
  
  assertthat::assert_that(is.character(id))
  assertthat::assert_that(is.character(area))
  assertthat::assert_that(is.character(coverage) & coverage %in% c("Contains", "FullMatch", "StartsWith", "EndsWith")) 
  assertthat::assert_that(is.character(fields))
  assertthat::assert_that(is.numeric(min_rnk))
  assertthat::assert_that(is.numeric(max_rnk) & max_rnk <= 1000)
  assertthat::assert_that(is.character(fmt))
  assertthat::assert_that(is.character(output) & toupper(output) %in% c("WIDE", "LONG"))
  
  
  expr <- ""
  for (a in area) {
    expr <- paste0(expr, paste0("AREA%5B", a, "%5DCOVERAGE%5B", coverage, "%5D", id, "+OR+"))
  }
  expr_formatted <- gsub("[+]OR[+]$", "", expr)
  
  res <- search_ctgov(
    expr = expr_formatted,
    fields = fields,
    min_rnk = min_rnk,
    max_rnk = max_rnk,
    fmt = fmt,
    output = output
  )
  
  return(res)
}