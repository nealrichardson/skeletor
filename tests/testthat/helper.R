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
})
