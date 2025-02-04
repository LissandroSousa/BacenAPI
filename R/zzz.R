#' @export
.onLoad <- function(libname, pkgname) {
  # Load the desired package
  library(dplyr)

  # Optional message to confirm that the package was loaded
  packageStartupMessage("Package dplyr loaded automatically..")
}
