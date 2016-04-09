context("Skeletor")

public({
    test_that("Creating a package skeleton", {
        dest <- file.path(tempdir(), "testskeletor")
        skeletor("testskeletor", dest)
        desc <- readLines(file.path(dest, "DESCRIPTION"))
        expect_identical(desc[1], "Package: testskeletor")
        tests <- readLines(file.path(dest, "tests", "testthat.R"))
        expect_identical(tests[2], paste0('test_check("testskeletor")'))
    })
})
