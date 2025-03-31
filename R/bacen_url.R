#' Creation of URLs to Access the Central Bank API
#'
#' This function generates URLs to access specific time series
#' data provided by the Central Bank of Brazil API.
#'
#' @param series Desired series code(s). Must be a number or a vector of numbers.
#' @param start_date Start date of the period of interest, in the format "dd/mm/yyyy".
#' @param end_date End date of the period of interest, in the format "dd/mm/yyyy".
#'
#' @return Returns a vector containing the generated URLs for each provided series.
#'
#' @examples
#' # Generate a URL for series 433 (IPCA) from 01/01/2003 to 31/12/2023.
#' bacen_url(433, "01/01/2020", "31/12/2023") # in the format "dd/mm/yyyy"
#'
#'
#'
#' @export
bacen_url <- function(series, start_date, end_date){
  url = 'https://api.bcb.gov.br/dados/serie/bcdata.sgs.'

  for(i in series){
    bacen_url = paste0(url, series, '/dados?formato=json&dataInicial=', start_date, '&dataFinal=', end_date)
  }

  return(bacen_url)
}
