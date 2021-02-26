context("Running test: search_by_id")

test_that("search_by_id receives bad input",{
  
  expect_error(search_by_id(), "argument \"id\" is missing, with no default")
})

test_that("search_by_id runs successfully", {
  
  expect_equal(ncol(search_by_id("BP28248", fields = c("OrgStudyId","SecondaryId","NCTId"))), 3)
  expect_equal(search_by_id("BP28248")$OrgStudyId, "BP28248")
  expect_equal(search_by_id("BP28248", fields = c("NCTId"))$NCTId, "NCT01677754")
  expect_message(search_by_id("sd51"), "no results found for id sd51")
})

