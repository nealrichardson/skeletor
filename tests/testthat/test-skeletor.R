context("Skeletor")

public({
    dest <- file.path(tempdir(), "testskeletor")
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
    test_that("The package name appears in the contents", {
        desc <- readLines(file.path(dest, "DESCRIPTION"))
        expect_identical(desc[1], "Package: testskeletor")
        tests <- readLines(file.path(dest, "tests", "testthat.R"))
        expect_identical(tests[2], 'test_check("testskeletor")')
        git <- readLines(file.path(dest, ".gitignore"))
        expect_identical(git[4], 'testskeletor*.tar.gz')
    })
})
