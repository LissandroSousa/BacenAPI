#' Criação de URLs para acesso à API do Banco Central
#'
#' Esta função gera URLs que permitem acessar dados de séries temporais específicas
#' fornecidas pela API do Banco Central do Brasil (BACEN).
#'
#' @param serie Código(s) da(s) série(s) desejada(s). Deve ser um número ou vetor de números.
#' @param data_inicio Data inicial do período de interesse, no formato "dd/mm/aaaa".
#' @param data_termino Data final do período de interesse, no formato "dd/mm/aaaa".
#'
#' @return Retorna um vetor contendo os URLs criados para cada série fornecida.
#'
#' @examples
#' # Gerar URL para a série 433 (IPCA) no período de 01/01/2003 a 31/12/2023.
#' bacen_url(433, "01/01/2003", "31/12/2023")
#'
#' @export
bacen_url <- function(serie, data_inicio, data_termino){
  url = 'https://api.bcb.gov.br/dados/serie/bcdata.sgs.'

  for(i in serie){
    bacen_url = paste0(url, serie, '/dados?formato=json&dataInicial=', data_inicio, '&dataFinal=', data_termino)
  }

  return(bacen_url)
}

