VERSION = $(shell grep ^Version DESCRIPTION | sed s/Version:\ //)

doc:
	R --slave -e 'library(roxygen2); roxygenise()'
	git add --all man/*.Rd

test:
	R CMD INSTALL --install-tests .
	R --slave -e 'Sys.setenv(NOT_CRAN="true"); library(testthat); setwd(file.path(.libPaths()[1], "skeletor", "tests")); system.time(test_check("skeletor", filter="${file}", reporter=ifelse(nchar("${r}"), "${r}", "summary")))'

deps:
	R --slave -e 'install.packages(c("codetools", "testthat", "devtools", "roxygen2", "knitr"), repo="http://cran.at.r-project.org", lib=ifelse(nchar(Sys.getenv("R_LIB")), Sys.getenv("R_LIB"), .libPaths()[1]))'

build: doc
	R CMD build .

check: build
	-export _R_CHECK_CRAN_INCOMING_REMOTE_=FALSE && R CMD check --as-cran skeletor_$(VERSION).tar.gz
	rm -rf skeletor.Rcheck/

man: doc
	R CMD Rd2pdf man/ --force

md:
	R CMD INSTALL --install-tests .
	mkdir -p inst/doc
	R -e 'setwd("vignettes"); lapply(dir(pattern="Rmd"), knitr::knit, envir=globalenv())'
	mv vignettes/*.md inst/doc/
	-cd inst/doc && ls | grep .md | xargs -n 1 sed -i '' 's/.html)/.md)/g'
	-cd inst/doc && ls | grep .md | xargs -n 1 egrep "^.. Error"

build-vignettes: md
	R -e 'setwd("inst/doc"); lapply(dir(pattern="md"), function(x) markdown::markdownToHTML(x, output=sub("\\\\.md", ".html", x)))'
	cd inst/doc && ls | grep .html | xargs -n 1 sed -i '' 's/.md)/.html)/g'

covr:
	R --slave -e 'library(covr); cv <- package_coverage(); df <- covr:::to_shiny_data(cv)[["file_stats"]]; cat("Line coverage:", round(100*sum(df[["Covered"]])/sum(df[["Relevant"]]), 1), "percent\\n")'

build-pkgdown:
	R -e 'pkgdown::build_site()'
	cp ../nealrichardson.github.io/static/favicon.ico docs/

publish-pkgdown:
	rm -rf ../nealrichardson.github.io/static/r/skeletor/
	mkdir ../nealrichardson.github.io/static/r/skeletor/
	cp -r docs/* ../nealrichardson.github.io/static/r/skeletor/
