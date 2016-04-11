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
    ## Rename some things that R CMD CHECK won't allow in inst otherwise
    file.rename(file.path(dir, "elifekaM"), file.path(dir, "Makefile"))
    file.rename(file.path(dir, "Rbuildignore"), file.path(dir, ".Rbuildignore"))
    file.rename(file.path(dir, "Rinstignore"), file.path(dir, ".Rinstignore"))
    file.rename(file.path(dir, "travis.yml"), file.path(dir, ".travis.yml"))
    file.rename(file.path(dir, "gitignore"), file.path(dir, ".gitignore"))

    ## Create empty dirs
    dir.create(file.path(dir, "man"))
    dir.create(file.path(dir, "vignettes"))

    ## Sub in the package name appropriately
    files.to.edit <- c("DESCRIPTION", "Makefile", "NEWS.md", "README.md",
        ".gitignore", file.path("tests", "testthat.R"))
    lapply(files.to.edit, function (f) {
        f <- file.path(dir, f)
        cleaned <- gsub("yourpackagename", name, readLines(f))
        writeLines(cleaned, f)
    })
    invisible(dir)
}
