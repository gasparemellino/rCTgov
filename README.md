# rCTgov  
The rCTgov package is a collection of R functions to interact with the [ClinicalTrials.gov API](https://clinicaltrials.gov/api/)  

## Installation  
```r
# install.packages("devtools")
devtools::install_github("gasparemellino/rCTgov", ref = "main")  

library(rCTgov)
```

## Functions  

### all_fields()
The function returns an alphabetical list of [all study fields available](https://clinicaltrials.gov/api/info/study_fields_list)  

```r
fields <- all_fields()
```

### default_fields()
This function is used by the *search_by_id* and *search_ctgov* functions as default fields returned by the query. 
This list should contain the list of fields most frequently used (this is to improve performance). This list can, of course, be changed locally as required.  

```r
fields <- default_fields()
```

### search_by_id()
This function can be used to retrieve the information of a particular study. It uses the *search_ctgov* function. 
Examples:

```r
search_by_id("BP28248") #returns the information for study BP28248 using the default fields defined in default_fields()
search_by_id("BP28248", output = "LONG") #as per above, but in long format
search_by_id("BP28248", fields = all_fields()) #returns all fields for study BP28248 - CAREFUL this will take a while...
search_by_id("BP28248", fields = c("OrgStudyId", "NCTId")) #select which fields to be returned by the query
search_by_id("NCT01874691", area = c("NCTId")) #specify in which field to search
search_by_id("BP28248", coverage = "FullMatch") #speficy coverage see here: https://clinicaltrials.gov/api/gui/ref/expr#coverageOp

#return specific information for a study
study_info <- search_by_id("BP30153")
study_info$OfficialTitle
study_info$MaximumAge
study_info$Condition
study_info$Phase
```

### search_ctgov()
This function is used to search across study fields and it consumes the [Study Fields API](https://clinicaltrials.gov/api/gui/demo/simple_study_fields)

```r
search_ctgov("heart+attack")
search_ctgov("heart+attack", max_rnk = 10) #free search across all fields, max results 10
search_ctgov("heart+attack", fields = c("OrgStudyId","SecondaryId","NCTId")) #specify fields to be returned
search_ctgov("Severe Headache") #free search across all fields
search_ctgov("BP28248", fields = all_fields()) #note: all_fields() takes a long time to run
```

   
_________________________
## Important Notes  
- There is a search limit by the API of max 1000 results  
- Search using "all_fields()" is only recommended in certain cases as it has an impact on performance  
- Futher documentation is available in the documentation of each function and on the [clinicaltrials.gov API website](https://clinicaltrials.gov/api/) 


