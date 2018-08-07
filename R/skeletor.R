#' Create a package skeleton
#'
#' @param pkg character: name for your new package
#' @param dir character: path in which to create the package. Default is `pkg`
#' @param name character: your name. Default is 'skeletor.name' from options.
#' See [configure()] to set `name`, `email`, and
#' `github` in your .Rprofile so that you don't need to pass them in here.
#' @param email character: your email address. Likewise taken from option
#' 'skeletor.email' by default.
#' @param github character: the GitHub account where you will push this new
#' package. Likewise taken from option 'skeletor.github' by default.
#' @param api logical: is this package an API wrapper? If `TRUE`, an `api.R`
#' file of boilerplate code will be added, `httr` will be added to `Imports`,
#' `httptest` will be added to `Suggests`, and some basic tests of the wrapping
#' code will be added. Default is `FALSE`.
#' @return The path, `dir`, invisibly.
#' @export
#' @importFrom utils as.person installed.packages
skeletor <- function (pkg,
                      dir=pkg,
                      name=getOption("skeletor.name"),
                      email=getOption("skeletor.email"),
                      github=getOption("skeletor.github"),
                      api=FALSE) {

    ## Make the package dir
    dir.create(dir)

    ## Copy the pkg skeleton
    file.copy(file.path(system.file(package="skeletor"), "pkg", "."), dir,
        recursive=TRUE)

    ## cd so that we don't have to carry file.path(dir, ...) everywhere
    cwd <- setwd(dir)
    on.exit(setwd(cwd))

    ## Rename some things that R CMD CHECK won't allow in inst otherwise
    file.rename("elifekaM", "Makefile")
    file.rename("Rbuildignore", ".Rbuildignore")
    file.rename("Rinstignore", ".Rinstignore")
    file.rename("travis.yml", ".travis.yml")
    file.rename("gitignore", ".gitignore")
    file.rename(file.path("R", "yourpackagename.R"),
        file.path("R", paste0(pkg, ".R")))

    ## Create empty dirs
    dir.create("man")
    dir.create("vignettes")

    files.to.edit <- c("DESCRIPTION", "Makefile", "NEWS.md", "README.md",
        ".gitignore", file.path("tests", "testthat.R"),
        file.path("R", paste0(pkg, ".R")))
    api.files <- c(file.path("R", "api.R"),
        file.path("tests", "testthat", "test-api.R"))
    if (api) {
        files.to.edit <- c(files.to.edit, api.files)
        file.remove(file.path("tests", "testthat", "test-something.R"))
    } else {
        file.remove(api.files)
    }
    ## Load files that need munging
    files <- sapply(files.to.edit, readLines, simplify=FALSE)

    ## Sub in the package name appropriately
    files <- lapply(files, function (f) {
        gsub("yourpackagename", pkg, f)
    })

    ## Edit the date in DESCRIPTION
    dateline <- grep("^Date", files[["DESCRIPTION"]])
    files[["DESCRIPTION"]][dateline] <- paste("Date:", Sys.Date())

    ## If name given, write it in
    if (!is.null(name)) {
        ## Read in the LICENSE (we don't need it otherwise)
        files[["LICENSE"]] <- gsub("yourname", name, readLines("LICENSE"))
        files[["DESCRIPTION"]] <- gsub("yourname", name, files[["DESCRIPTION"]])
    }
    ## Same for github
    if (!is.null(github)) {
        for (f in c("DESCRIPTION", "README.md")) {
            files[[f]] <- gsub("yourgithub", github, files[[f]])
        }
    }
    ## And email
    if (!is.null(name)) {
        files[["DESCRIPTION"]] <- gsub("youremail@example.com", email,
            files[["DESCRIPTION"]])
    }
    ## Now do Authors@R
    if (!is.null(name) && !is.null(email)) {
        ## TODO: let someone specify a `person` in "name"
        p <- as.person(name)
        authors.at.r <- paste0('Authors@R: person(', deparse(p$given), ', ',
            deparse(p$family), ', role=c("aut", "cre"), email="', email,
            '")')
        authors.row <- grep("^Authors", files[["DESCRIPTION"]])
        files[["DESCRIPTION"]][authors.row] <- authors.at.r
    }

    if (api) {
        ## Add Imports/Suggests for API packages
        files[["DESCRIPTION"]] <- splice(
            files[["DESCRIPTION"]],
            grep("^Imports:", files[["DESCRIPTION"]]),
            "    httr,",
            "    utils"
        )
        files[["DESCRIPTION"]] <- splice(
            files[["DESCRIPTION"]],
            grep("^    covr", files[["DESCRIPTION"]]),
            "    httptest,"
        )
        ## Use httptest in tests
        files[[file.path("tests", "testthat.R")]][1] <- "library(httptest)"
    }

    ## Write them all back out
    for (f in names(files)) {
        writeLines(files[[f]], f)
    }

    if (api && "roxygen2" %in% rownames(installed.packages())) {
        ## Build our man pages and NAMESPACE because the API version has code
        roxygen2::roxygenise()
    }

    invisible(dir)
}

splice <- function (str, at, ...) {
    end <- length(str)
    ## TODO: validate that at %in% seq_len(end)
    c(str[1:at], ..., str[(at + 1):end])
}
