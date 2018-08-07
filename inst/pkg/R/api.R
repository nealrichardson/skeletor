#' @importFrom httr GET PUT PATCH POST DELETE
my_api <- function (verb, url, config=list(), ...) {
    FUN <- get(verb, envir=asNamespace("httr"))
    resp <- FUN(url, ..., config=c(my_config(), config))
    return(my_handle_response(resp))
}

#' @importFrom httr add_headers
my_config <- function () {
    add_headers(`user-agent`=ua("yourpackagename"))
}

#' @importFrom httr http_status content
my_handle_response <- function (resp) {
    if (resp$status_code >= 400L)  {
        msg <- http_status(resp)$message
        # If the API returns a useful error message in the content(), you can
        # append it to `msg`
        stop(msg, call.=FALSE)
    } else {
        return(content(resp))
    }
}

my_url <- function (...) {
    paste(..., sep="/")
}

#' @importFrom utils packageVersion
ua <- function (pkg) paste(pkg, as.character(packageVersion(pkg)), sep="/")

my_GET <- function (url, ...) my_api("GET", url, ...)

my_PUT <- function (url, ...) my_api("PUT", url, ...)

my_PATCH <- function (url, ...) my_api("PATCH", url, ...)

my_POST <- function (url, ...) my_api("POST", url, ...)

my_DELETE <- function (url, ...) my_api("DELETE", url, ...)
