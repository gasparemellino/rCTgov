#' search using STUDYID or NCT num
#'
#' @description search clinicaltrials.gov using any study id or NCT number
#' 
#' @param ids one or more study id or NCT num
#' @param area declares which search area/fields should be searched
#' @param coverage degree to which a search term needs to match the text in an API field. There are four choices: Contains(default), FullMatch, StartsWith, EndsWith
#' @param fields fields to be returned (defaulted to default_fields())
#' @param min_rnk minimum returned searches
#' @param max_rnk maximum returned searches (note: this cannot be > 1000)
#' @param fmt format as per API, defaulted to csv
#' @param output can be WIDE or LONG format
#'
#' @importFrom assertthat assert_that
#' @import tibble 
#'
#' @return data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' res <- search_by_id("BP28248")
#' res <- search_by_id(c("BP28248", "WN25203", "BN29552"))
#' res <- search_by_id("BP28248", coverage = "FullMatch")
#' res <- search_by_id("NCT01874691", area = c("NCTId"), fields = c("OrgStudyId", "SecondaryId"))
#' res <- search_by_id("BP28248", fields = c("NCTId"))
#' }
#' 
search_by_id <- function(ids,
                         area = c("OrgStudyId", "SecondaryId"), #area must not be null
                         coverage = c("Contains", "FullMatch", "StartsWith", "EndsWith"),
                         fields = default_fields(),
                         min_rnk = 1,
                         max_rnk = 1000,
                         fmt = "csv",
                         output = "WIDE") {
  
  assertthat::assert_that(is.character(ids))
  assertthat::assert_that(is.character(area))
  assertthat::assert_that(is.character(fields))
  assertthat::assert_that(is.numeric(min_rnk))
  assertthat::assert_that(is.numeric(max_rnk) & max_rnk <= 1000)
  coverage = match.arg(coverage)
  
  
  res <- data.frame()
    
  for(i in ids){
    expr <- ""
    for (a in area) {
      expr <- paste0(expr, paste0("AREA%5B", a, "%5DCOVERAGE%5B", coverage, "%5D", i, "+OR+"))
    }
    expr_formatted <- gsub("[+]OR[+]$", "", expr)
    
    suppressMessages(res1 <- search_ctgov(
      expr = expr_formatted,
      fields = fields,
      min_rnk = min_rnk,
      max_rnk = max_rnk,
      fmt = fmt,
      output = "WIDE"
    )
    )
    
    if(nrow(res1) == 0){
      message(paste0("no results found for id ", i))
    }
    res <- rbind(res, res1)
  }
  
#if results is required as long format (repeated due to the multiple call of the search_ctgov function)
  if (toupper(output) == "LONG") {
    res <- res %>%
      tibble::rownames_to_column() %>%  
      pivot_longer(-rowname) %>% 
      pivot_wider(names_from=rowname, values_from=value) 
  }
  
  return(res)
}