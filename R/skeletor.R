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
    ## Sub in the package name appropriately
    files.to.edit <- c("DESCRIPTION", "Makefile", "NEWS.md", "README.md",
        file.path("tests", "testthat.R"))
    subber <- function (f) {
        f <- file.path(dir, f)
        if (!file.exists(f)) {
            stop(f, call.=FALSE)
        }
        cleaned <- gsub("yourpackagename", name, readLines(f))
        writeLines(cleaned, f)
    }
    lapply(files.to.edit, subber)
    invisible(dir)
}
