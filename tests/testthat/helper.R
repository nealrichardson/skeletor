Sys.setlocale("LC_COLLATE", "C") ## What CRAN does
Sys.setenv("R_TESTS"="") # What the internet suggests for running tests within tests
set.seed(999)
options(warn=1,
    skeletor.name=NULL,
    skeletor.email=NULL,
    skeletor.github=NULL)

public <- function (...) with(globalenv(), ...)
