# skeletor: Another R Package Skeleton Generator

[![Build Status](https://travis-ci.org/nealrichardson/skeletor.png?branch=master)](https://travis-ci.org/nealrichardson/skeletor) [![Build status](https://ci.appveyor.com/api/projects/status/28hsiu1b9ntisto7/branch/master?svg=true)](https://ci.appveyor.com/project/nealrichardson/skeletor/branch/master)  [![codecov.io](https://codecov.io/github/nealrichardson/httpcache/skeletor.svg?branch=master)](https://codecov.io/github/nealrichardson/skeletor?branch=master) 

There are lots of R package skeletons out there. Why write another? I want a package skeleton that lays out everything I need to write tests, code, documentation, and potentially vignettes. I want it set up to build and install and pass CHECK smoothly. And I want it set up for using git, GitHub, and Travis CI. The defaults of the base R's `package.skeleton` never are what I want, and `devtools::create` left out key features that I want in my package.

I found that I was starting every package I wrote by copying the last package I made, deleting its code and tests, and renaming everything. `skeletor` automates that.

## Installing

The pre-CRAN-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("nealrichardson/skeletor")

## Using

After installing, simply running

    $ R -e 'skeletor::skeletor("wittynamehere")'

from the shell will create a package skeleton called "wittynamehere" in a same-named subdirectory of your current working directory. Then you can open that directory's contents in your favorite IDE or text editor. You can immediately run tests on your new package with `make test` or by running `R CMD CHECK` on it.

## Customizing

In its initial release, certain features of the package skeleton are hard-coded, such as the author name, GitHub link, etc. Someday I'll parameterize those, but for now, you can just find/replace them. Or for a smoother experience, you can fork this repo, edit those values for yourself, and run `skeletor` from your fork.

## For developers

The repository---and the repositories it creates---include a Makefile to facilitate some common tasks.

### Running tests

`$ make test`. Requires the [testthat](https://github.com/hadley/testthat) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=logging`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the `testthat` package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.
