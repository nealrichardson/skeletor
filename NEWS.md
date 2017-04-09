### skeletor 1.0.4

* Fix skeleton README's reference to Appveyor
* Move 'covr' to Suggests rather than a .travis.yml extra installation
* Enable [markdown in roxygen tags](https://github.com/klutometis/roxygen/blob/master/vignettes/markdown.md)

### skeletor 1.0.2

* Patch tests to work with "oldrel" R, which doesn't have `tools::Rcmd`.
* Run Travis builds on "oldrel", "release", and "devel" versions of R.

# skeletor 1.0.0

* CRAN release. Provides two functions: `skeletor` to make a package skeleton, and `configure` to set your name, email, and github account in your .Rprofile so that you don't have to enter them when you call `skeletor`.

## skeletor 0.1.0

* Initial addition of functions and tests
