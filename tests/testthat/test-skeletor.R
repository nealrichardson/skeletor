context("Skeletor")

public({
    tmpd <- tempdir()
    dest <- file.path(tmpd, "testskeletor")
    test_that("Creating a package skeleton", {
        skeletor("testskeletor", dest)
        expect_true(dir.exists(dest))
    })
    test_that("The right dirs exist", {
        expect_true(dir.exists(file.path(dest, "tests")))
        expect_true(dir.exists(file.path(dest, "man")))
        expect_true(dir.exists(file.path(dest, "vignettes")))
    })
    test_that("The right files exist", {
        expect_true(file.exists(file.path(dest, "DESCRIPTION")))
        expect_true(file.exists(file.path(dest, ".Rbuildignore")))
        expect_true(file.exists(file.path(dest, "Makefile")))
        expect_true(file.exists(file.path(dest, ".gitignore")))
    })

    desc <- readLines(file.path(dest, "DESCRIPTION"))
    tests <- readLines(file.path(dest, "tests", "testthat.R"))
    git <- readLines(file.path(dest, ".gitignore"))

    test_that("The package name appears in the contents", {
        expect_identical(desc[1], "Package: testskeletor")
        expect_identical(tests[2], 'test_check("testskeletor")')
        expect_identical(git[4], 'testskeletor*.tar.gz')
    })
    test_that("Today's date is set in the DESCRIPTION", {
        expect_identical(desc[6], paste("Date:", Sys.Date()))
    })

    test_that("The skeleton package can be built", {
        setwd(tmpd)
        tools::Rcmd("build testskeletor")
        expect_true(file.exists("testskeletor_0.1.0.tar.gz"))
    })
    test_that("The built package passes R CMD CHECK", {
        status <- tools::Rcmd("check testskeletor_0.1.0.tar.gz")
        expect_equal(status, 0)
    })
})
