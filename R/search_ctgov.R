#' Search clinicaltrials.gov
#'
#' @description search clinicaltrials.gov using the Study Fields API (https://clinicaltrials.gov/api/gui/demo/simple_study_fields).
#' Search can be specified with expression and the fields required.
#'
#' @param expr expression as defined by clinicaltrials.gov (https://clinicaltrials.gov/api/gui/ref/syntax)
#' @param fields fields to be returned (defaulted to default_fields())
#' @param min_rnk minimum returned searches
#' @param max_rnk maximum returned searches (note: this cannot be > 1000)
#' @param fmt format as per API, defaulted to csv
#' @param output can be WIDE or LONG format
#'
#' @return data.frame
#'
#' @import tidyr readr
#' @importFrom assertthat assert_that
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' res <- search_ctgov("heart+attack", max_rnk = 10)
#' res <- search_ctgov("BP28248")
#' res <- search_ctgov("BP28248", fields = all_fields()) #note: all_fields() takes a long time to run
#' res <- search_ctgov("heart+attack", fields = c("OrgStudyId","SecondaryId","NCTId"))
#' 
#' }
search_ctgov <- function(expr,
                         fields = default_fields(),
                         min_rnk = 1,
                         max_rnk = 1000,
                         fmt = "csv",
                         output = "WIDE") {
  
  assertthat::assert_that(is.character(expr))
  assertthat::assert_that(is.character(fields))
  assertthat::assert_that(is.numeric(min_rnk))
  assertthat::assert_that(is.numeric(max_rnk) & max_rnk <= 1000)
  assertthat::assert_that(is.character(fmt))
  assertthat::assert_that(is.character(output) & toupper(output) %in% c("WIDE", "LONG"))
  
  expr <- gsub(" ", "+", expr)#substitute spaces with + as per API
  
  n <- length(fields)
  if(n > 50){
    message(paste0("The number of fields requested is ", n, ". This may take a while..."))
  }
  
  k <- 20 #maximum number of fields allowed per call
  fields_grouped <- unname(split(fields, rep(1:ceiling(n / k), each = k)[1:n])) #grouping fields by 20 elements
  datalist = list()
  c <- 0
  for (i in fields_grouped) {
    formated_fields <- paste(i, collapse = '%2C+') #format list of fields as required by API
    url1 <-
      paste0(
        "https://clinicaltrials.gov/api/query/study_fields?expr=",
        expr,
        "%0D%0A&fields=",
        formated_fields,
        "&min_rnk=",
        min_rnk,
        "&max_rnk=",
        max_rnk,
        "&fmt=",
        fmt
      )
    res_api <- read_csv(url(url1), skip = 10, col_types = cols(.default = "c"))
    res_adjusted <- subset(res_api, select = -Rank) #remove unnecessary Rank column
    c <- c + 1
    datalist[[c]] <- res_adjusted
  }
  
  res <- do.call(cbind, datalist)
  
  #if results is required as long format
  if (toupper(output) == "LONG") {
    res <- tidyr::gather(res)
  }
  
  if(nrow(res) == 0){
    message(paste0("no results found for ", expr))
  }
  
  return(res)
}
