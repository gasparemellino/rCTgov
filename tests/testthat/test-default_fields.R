context('Running test: default_fields\n')


test_that("returns a vector", {
  expect_vector(all_fields())
})
