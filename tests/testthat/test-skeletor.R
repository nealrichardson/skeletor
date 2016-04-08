context("Skeletor")

public({
    test_that("Creating a package skeleton", {
        dest <- file.path(tempdir(), "testskeletor")
        skeletor("testskeletor", dest)
        print(dir(dest))
        desc <- readLines(file.path(dest, "DESCRIPTION"))
        expect_identical(desc[1], "Package: testskeletor")
    })
})
