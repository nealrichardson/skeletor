context("Skeletor with configure")

options(skeletor.name="Neal Richardson",
        skeletor.email="neal.p.richardson@gmail.com",
        skeletor.github="nealrichardson")

public({
    tmpd <- tempdir()
    pkgdir <- tempfile(tmpdir="")
    pkgdir <- substr(pkgdir, 2, nchar(pkgdir)) ## Remove the leading /
    dest <- file.path(tmpd, pkgdir)
    test_that("Creating a package skeleton", {
        skeletor("testskeletor", dest)
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
    lisc <- readLines(file.path(dest, "LICENSE"))
    readme <- readLines(file.path(dest, "README.md"))

    test_that("The package name appears in the contents", {
        expect_identical(desc[1], "Package: testskeletor")
        expect_identical(tests[2], 'test_check("testskeletor")')
        expect_identical(git[4], 'testskeletor*.tar.gz')
    })
    test_that("Today's date is set in the DESCRIPTION", {
        expect_identical(desc[11], paste("Date:", Sys.Date()))
    })
    test_that("skeletor.name appears in the right places", {
        expect_identical(lisc[2], "COPYRIGHT HOLDER: Neal Richardson")
        expect_true("Author: Neal Richardson [aut, cre]" %in% desc)
    })
    test_that("skeletor.github appears in the right places", {
        expect_true("URL: https://github.com/nealrichardson/testskeletor" %in% desc)
    })
    test_that("skeletor.email appears in the right place", {
        expect_true("Maintainer: Neal Richardson <neal.p.richardson@gmail.com>" %in% desc)
    })
    test_that("The travis/codecov badge links get updated", {
        u <- "https://travis-ci.org/nealrichardson/testskeletor.png?branch=master"
        expect_true(any(grepl(u, readme, fixed=TRUE)))
    })
    test_that("Authors@R gets set correctly if you give a name and email", {
        expect_true('Authors@R: person("Neal", "Richardson", role=c("aut", "cre"), email="neal.p.richardson@gmail.com")' %in% desc)
    })

    if (!no.check) {
        setwd(tmpd)
        test_that("The skeleton package can be built", {
            tools::Rcmd(paste("build", pkgdir))
            expect_file_exists("testskeletor_0.1.0.tar.gz")
        })
        test_that("The built package passes R CMD CHECK", {
            skip_on_appveyor() ## It apparently can't find pdflatex to build the manual
            skip_on_cran() ## In case it is slow
            status <- tools::Rcmd("check testskeletor_0.1.0.tar.gz")
            expect_equal(status, 0)
        })
    }
})
