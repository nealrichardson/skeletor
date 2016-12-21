#' Create a package skeleton
#'
#' @param name character name for your new package
#' @param dir character path in which to create the package. Default is \code{name}
#' @return The path, \code{dir}, invisibly.
#' @export
skeletor <- function (name, dir=name) {
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

    ## Create empty dirs
    dir.create("man")
    dir.create("vignettes")

    ## Sub in the package name appropriately
    files.to.edit <- c("DESCRIPTION", "Makefile", "NEWS.md", "README.md",
        ".gitignore", file.path("tests", "testthat.R"))
    lapply(files.to.edit, function (f) {
        cleaned <- gsub("yourpackagename", name, readLines(f))
        writeLines(cleaned, f)
    })

    ## Edit the date in DESCRIPTION
    desc <- readLines("DESCRIPTION")
    desc[grep("^Date", desc)] <- paste("Date:", Sys.Date())
    writeLines(desc, "DESCRIPTION")

    invisible(dir)
}
