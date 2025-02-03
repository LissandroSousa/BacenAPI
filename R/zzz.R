#' @export
.onLoad <- function(libname, pkgname) {
  # Carrega o pacote desejado
  library(dplyr)

  # Mensagem opcional para confirmar que o pacote foi carregado
  packageStartupMessage("Pacote dplyr carregado automaticamente.")
}
