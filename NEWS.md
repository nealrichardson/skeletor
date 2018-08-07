# skeletor 1.1.0

* New `api` argument to `skeletor()`. If `TRUE`, the generated skeleton will have an `R/api.R` with basic functions for wrapping an API, and the test suite will use the [`httptest`](https://enpiar.com/r/httptest/) package.
* Add `spelling` to Suggests in skeleton and add spell check to tests. (Also add `spelling` to Suggests in this package.)
* Use `_R_CHECK_CRAN_INCOMING_REMOTE_` environment variable, released in R 3.4.0, in `make check`
* Add `r-pkg.org` badge to the skeleton
* Various modernizations

# skeletor 1.0.4

* Fix skeleton README's reference to Appveyor
* Move `covr` to Suggests rather than a .travis.yml extra installation
* Enable [markdown in roxygen tags](https://github.com/klutometis/roxygen/blob/master/vignettes/markdown.md)

# skeletor 1.0.2

* Patch tests to work with "oldrel" R, which doesn't have `tools::Rcmd()`.
* Run Travis builds on "oldrel", "release", and "devel" versions of R.

# skeletor 1.0.0

* CRAN release. Provides two functions: `skeletor()` to make a package skeleton, and `configure()` to set your name, email, and github account in your .Rprofile so that you don't have to enter them when you call `skeletor`.

# skeletor 0.1.0

* Initial addition of functions and tests
