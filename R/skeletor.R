skeletor <- function (name, dir=name) {
    ## Make the package dir
    dir.create(dir)
    ## Copy the pkg skeleton
    file.copy(file.path(system.file(package="skeletor"), "pkg", "."), dir,
        recursive=TRUE)
    ## Sub in the package name appropriately
    files.to.edit <- c("DESCRIPTION", "Makefile", "NEWS.md", "README.md",
        file.path("tests", "testthat.R"))
    lapply(files.to.edit, function (f) {
        f <- file.path(dir, f)
        cleaned <- gsub("yourpackagename", name, readLines(f))
        writeLines(cleaned, f)
    })
    invisible(dir)
}
