# skeletor: Another R Package Skeleton Generator

[![Build Status](https://travis-ci.org/nealrichardson/skeletor.png?branch=master)](https://travis-ci.org/nealrichardson/skeletor) [![Build status](https://ci.appveyor.com/api/projects/status/28hsiu1b9ntisto7/branch/master?svg=true)](https://ci.appveyor.com/project/nealrichardson/skeletor/branch/master)  [![codecov](https://codecov.io/gh/nealrichardson/skeletor/branch/master/graph/badge.svg)](https://codecov.io/gh/nealrichardson/skeletor)

There are lots of R package skeletons out there. Why write another? I want a package skeleton that lays out everything I need to write tests, code, documentation, and potentially vignettes. I want it set up to build and install and pass CHECK smoothly. And I want it set up for using git, GitHub, and Travis CI. The defaults of the base R's `package.skeleton` never are what I want, and `devtools::create` left out key features that I want in my package.

I found that I was starting every package I wrote by copying the last package I made, deleting its code and tests, and renaming everything. `skeletor` automates that.

## Installing

The pre-CRAN-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("nealrichardson/skeletor")

## Using

Skeletor provides only two functions: (1) `skeletor`, which makes a package skeleton for you, and (2) `configure`, which sets a few parameters in your .Rprofile so that you don't need to provide them each time. These parameters, which are inserted into the package skeleton template, are:

* **name**: your name
* **email**: your email address
* **github**: your GitHub username

After installing, run `configure` once to set these, like:

    > library(skeletor)
    > configure(name="Neal Richardson", email="neal.p.richardson@gmail.com", github="nealrichardson")

Thereafter, simply running

    $ R -e 'skeletor::skeletor("wittynamehere")'

from the shell will create a package skeleton called "wittynamehere" in a same-named subdirectory of your current working directory, and it will insert your name, email, and GitHub account into the appropriate parts of the package. Then you can open that directory's contents in your favorite IDE or text editor. You also can immediately run tests on your new package with `make test` or by running `R CMD check` on it.

## For developers

The repository---and the repositories it creates---include a Makefile to facilitate some common tasks.

### Running tests

`$ make test`. Requires the [testthat](https://github.com/hadley/testthat) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=logging`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the `testthat` package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.
