context("Skeletor with api=TRUE")

options(skeletor.name="Neal Richardson",
        skeletor.email="neal.p.richardson@gmail.com",
        skeletor.github="nealrichardson")

public({
    tmpd <- tempdir()
    pkgdir <- tempfile(tmpdir="")
    pkgdir <- substr(pkgdir, 2, nchar(pkgdir)) ## Remove the leading /
    dest <- file.path(tmpd, pkgdir)
    test_that("Creating a package skeleton", {
        skeletor("testskeletor", dest, api=TRUE)
        expect_dir_exists(dest)
    })
    test_that("The right dirs exist", {
        expect_dir_exists(file.path(dest, "tests"))
        expect_dir_exists(file.path(dest, "man"))
        expect_dir_exists(file.path(dest, "vignettes"))
    })
    test_that("The right files exist", {
        expect_file_exists(file.path(dest, "DESCRIPTION"))
        expect_file_exists(file.path(dest, ".Rbuildignore"))
        expect_file_exists(file.path(dest, "Makefile"))
        expect_file_exists(file.path(dest, ".gitignore"))
        expect_file_exists(file.path(dest, "R", "testskeletor.R"))
    })

    desc <- readLines(file.path(dest, "DESCRIPTION"))
    tests <- readLines(file.path(dest, "tests", "testthat.R"))
    git <- readLines(file.path(dest, ".gitignore"))

    test_that("The package name appears in the contents", {
        expect_identical(desc[1], "Package: testskeletor")
        expect_identical(tests[2], 'test_check("testskeletor")')
        expect_identical(git[4], 'testskeletor*.tar.gz')
    })

    if (!no.check) {
        setwd(tmpd)
        test_that("The skeleton package can be built", {
            Rcmd(paste("build", pkgdir))
            expect_file_exists("testskeletor_0.1.0.tar.gz")
        })
        test_that("The built package passes R CMD CHECK", {
            skip_on_appveyor() ## It apparently can't find pdflatex to build the manual
            skip_on_cran() ## In case it is slow
            status <- Rcmd("check testskeletor_0.1.0.tar.gz")
            expect_equal(status, 0)
        })
    }
})
