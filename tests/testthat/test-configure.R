context("Configuration")

public({
    f <- tempfile()
    test_that("configure adds a line to your .Rprofile (or other specified file)", {
        expect_false(file.exists(f))
        cat("abc\n123\n", file=f) ## Now the file exists
        configure(name="State Your Name", email="sy.name@example.com",
            github="syn", file=f) ## Provide the file; default arg is ~/.Rprofile
        out <- readLines(f)
        expect_identical(out, c("abc", "123", "",
            'options(skeletor.name="State Your Name", skeletor.email="sy.name@example.com", skeletor.github="syn") # Added by skeletor::configure'))
    })
    test_that("configure overwrites its own line if you run it again", {
        configure(name="Your Name Here", email="ynh@example.com", file=f)
        expect_identical(readLines(f), c("abc", "123", "",
            'options(skeletor.name="Your Name Here", skeletor.email="ynh@example.com") # Added by skeletor::configure'))
    })

    test_that("configure removes its line if you run it with empty args", {
        cfg <- configure(file=f)
        expect_identical(readLines(f), c("abc", "123", ""))
        expect_identical(cfg, list())
    })

    f2 <- tempfile()
    cfg <- configure(name="State Your Name", email="sy.name@example.com",
        github="syn", file=f2)
    test_that("configure creates the file if it does not already exist", {
        out <- readLines(f2)
        expect_identical(out,
            'options(skeletor.name="State Your Name", skeletor.email="sy.name@example.com", skeletor.github="syn") # Added by skeletor::configure')
    })

    test_that("configure returns its set options invisibly", {
        expect_identical(cfg,
            list(skeletor.name="State Your Name",
                 skeletor.email="sy.name@example.com",
                 skeletor.github="syn"))
    })
    test_that("configure sets the options in the current session too", {
        expect_identical(getOption("skeletor.name"), "State Your Name")
    })

    test_that("configure with empty args doesn't create a file if it doesn't exist", {
        f3 <- tempfile()
        expect_false(file.exists(f3))
        configure(file=f3)
        expect_false(file.exists(f3))
    })
})
