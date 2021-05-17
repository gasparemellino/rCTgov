context('Running test: all_fields\n')


test_that("returns a vector", {
  expect_vector(all_fields())
})


test_that("some fields are present", {
  expect_true("NCTId" %in% all_fields() &
              "OrgStudyId" %in% all_fields())
})