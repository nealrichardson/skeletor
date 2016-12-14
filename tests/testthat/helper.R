Sys.setlocale("LC_COLLATE", "C") ## What CRAN does
Sys.setenv("R_TESTS"="") # What the internet suggests
set.seed(999)
options(warn=1)

public <- function (...) with(globalenv(), ...)
