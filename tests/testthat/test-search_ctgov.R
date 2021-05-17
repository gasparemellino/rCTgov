context("Running test: search_ctgov")

test_that("search_ctgov receives bad input",{
  
  expect_error(search_ctgov(), "argument \"expr\" is missing, with no default")
})

test_that("search_ctgov runs successfully", {
  
  expect_equal(nrow(search_ctgov("heart+attack", max_rnk = 10)), 10)
  expect_equal(nrow(search_ctgov("heart attack", max_rnk = 10)), 10)
  expect_equal(ncol(search_ctgov("heart+attack", fields = c("OrgStudyId","SecondaryId","NCTId"))), 3)
  expect_equal(search_ctgov("BP28248")$OrgStudyId, "BP28248")
  expect_equal(ncol(search_ctgov("BP28248", output = "LONG")), 2)
  expect_message(search_ctgov("BP28248", fields = all_fields()[1:51]), "The number of fields requested is 51. This may take a while...")

})

