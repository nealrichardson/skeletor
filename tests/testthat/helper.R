Sys.setlocale("LC_COLLATE", "C") ## What CRAN does
Sys.setenv("R_TESTS"="") # What the internet suggests for running tests within tests
set.seed(999)
options(warn=1,
    skeletor.name=NULL,
    skeletor.email=NULL,
    skeletor.github=NULL)

public <- function (...) with(globalenv(), ...)

public({
    no.check <- Sys.getenv("NOCHECK") == "TRUE" ## To skip the R CMD check tests when developing
    expect_file_exists <- function (...) expect_true(file.exists(...))
    expect_dir_exists <- function (...) expect_true(dir.exists(...))

    ## from __future__ import ...
    if ("Rcmd" %in% ls(envir=asNamespace("tools"))) {
        Rcmd <- tools::Rcmd
    } else {
        ## R < 3.3
        Rcmd <- function (args, ...) {
            if (.Platform$OS.type == "windows") {
                system2(file.path(R.home("bin"), "Rcmd.exe"), args, ...)
            } else {
                system2(file.path(R.home("bin"), "R"), c("CMD", args), ...)
            }
        }
    }
})
