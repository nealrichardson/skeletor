skeletor <- function (name, dir=name) {
    dir.create(dir)
    file.copy(file.path(system.file(package="skeletor"), "pkg"), dir)
    invisible(dir)
}
