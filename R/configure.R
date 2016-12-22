#' Set some personal defaults for skeletor
#' @param name character: your name
#' @param email character: your email address
#' @param github character: your GitHub account
#' @param file character: file path to set these in as options. Default is your
#' personal .Rprofile file.
#' @return Invisibly, the options set in \code{file}. Typically, you'll call
#' this function only once, and only for its side effects of adding the values
#' to your .Rprofile so that \code{\link{skeletor}} will find them there without
#' your having to enter them each time.
#' @export
configure <- function (name=NULL, email=NULL, github=NULL, file="~/.Rprofile") {
    ## Construct string to write and payload to return
    out <- list()
    opts <- c()
    if (!is.null(name)) {
        out$skeletor.name <- name
        opts <- c(opts, paste0('skeletor.name="', name, '"'))
    }
    if (!is.null(email)) {
        out$skeletor.email <- email
        opts <- c(opts, paste0('skeletor.email="', email, '"'))
    }
    if (!is.null(github)) {
        out$skeletor.github <- github
        opts <- c(opts, paste0('skeletor.github="', github, '"'))
    }
    if (length(opts)) {
        opts <- paste0("options(", paste(opts, collapse=", "),
            ") # Added by skeletor::configure")
    } else {
        ## If all are null, we aren't going to write anything
        opts <- ""
    }

    ## If file does not exist, and we have options to add, just cat to it
    if (!file.exists(file)) {
        if (nchar(opts)) {
            cat(paste0(opts, "\n"), file=file)
        }
    } else {
        ## Read in the file to look for our comment
        lines <- readLines(file)
        ours <- grep("^options\\(.*\\) # Added by skeletor", lines)
        if (length(ours)) {
            ## Drop those
            lines <- lines[-ours]
        }
        if (nchar(opts)) { ## Only add ours if it is non-empty
            ## Add a line of padding if needed
            if (nchar(lines[length(lines)])) {
                lines <- c(lines, "")
            }
            ## Add our line
            lines <- c(lines, opts)
        }
        ## Write out
        writeLines(lines, file)
    }

    ## Set the options in the current session too
    do.call("options", out)

    invisible(out)
}
