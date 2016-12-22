#' Create a package skeleton
#'
#' @param pkg character: name for your new package
#' @param dir character: path in which to create the package. Default is \code{pkg}
#' @param name chararacter: your name. Default is 'skeletor.name' from options.
#' See \code{\link{configure}} to set \code{name}, \code{email}, and
#' \code{github} in your .Rprofile so that you don't need to pass them in here.
#' @param email character: your email address. Likewise taken from option
#' 'skeletor.email' by default.
#' @param github character: the GitHub account where you will push this new
#' package. Likewise taken from option 'skeletor.github' by default.
#' @return The path, \code{dir}, invisibly.
#' @export
#' @importFrom utils as.person
skeletor <- function (pkg, dir=pkg, name=getOption("skeletor.name"),
                      email=getOption("skeletor.email"),
                      github=getOption("skeletor.github")) {

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

    ## Load files that need munging
    files.to.edit <- sapply(c("DESCRIPTION", "Makefile", "NEWS.md", "README.md",
        ".gitignore", file.path("tests", "testthat.R"),
        file.path("R", paste0(pkg, ".R"))),
        readLines, simplify=FALSE)

    ## Sub in the package name appropriately
    files.to.edit <- lapply(files.to.edit, function (f) {
        gsub("yourpackagename", pkg, f)
    })

    ## Edit the date in DESCRIPTION
    dateline <- grep("^Date", files.to.edit[["DESCRIPTION"]])
    files.to.edit[["DESCRIPTION"]][dateline] <- paste("Date:", Sys.Date())

    ## If name given, write it in
    if (!is.null(name)) {
        ## Read in the LICENSE (we don't need it otherwise)
        files.to.edit[["LICENSE"]] <- gsub("yourname", name,
            readLines("LICENSE"))
        files.to.edit[["DESCRIPTION"]] <- gsub("yourname", name,
            files.to.edit[["DESCRIPTION"]])
    }
    ## Same for github
    if (!is.null(github)) {
        for (f in c("DESCRIPTION", "README.md")) {
            files.to.edit[[f]] <- gsub("yourgithub", github, files.to.edit[[f]])
        }
    }
    ## And email
    if (!is.null(name)) {
        files.to.edit[["DESCRIPTION"]] <- gsub("youremail@example.com", email,
            files.to.edit[["DESCRIPTION"]])
    }
    ## Now do Authors@R
    if (!is.null(name) && !is.null(email)) {
        ## TODO: let someone specify a `person` in "name"
        p <- as.person(name)
        authors.at.r <- paste0('Authors@R: person(', deparse(p$given), ', ',
            deparse(p$family), ', role=c("aut", "cre"), email="', email,
            '")')
        authors.row <- grep("^Authors", files.to.edit[["DESCRIPTION"]])
        files.to.edit[["DESCRIPTION"]][authors.row] <- authors.at.r
    }

    ## Write them all back out
    for (f in names(files.to.edit)) {
        writeLines(files.to.edit[[f]], f)
    }

    invisible(dir)
}
