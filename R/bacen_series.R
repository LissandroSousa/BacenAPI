#' Fetch Multiple Central Bank Series
#'
#' This function retrieves data from multiple Central Bank series, given a vector of series IDs and corresponding names.
#'
#' @param series A numeric vector containing the series IDs from Central Bank API.
#' @param names A character vector containing the names corresponding to each series.
#' @param start_date A string specifying the start date in "dd/mm/yyyy" format.
#' @param end_date A string specifying the end date in "dd/mm/yyyy" format.
#' @param httr A logical value indicating whether to use `httr` (`TRUE`) or `httr2` (`FALSE`). Default is `TRUE`.
#'
#' @return A `data.frame` containing the retrieved series data.
#'
#' @examples
#' series <- c('433', '13005')
#' names <- c('ipca_br', 'ipca_for')
#' data <- bacen_series(series, names,
#' "01/01/2020", "31/12/2023",
#' httr = TRUE) # in the format "dd/mm/yyyy"
#'
#'
#'
#' @export
bacen_series <- function(series, names, start_date, end_date, httr = TRUE) {
  # Criar uma lista para armazenar os dados
  series_data <- list()

  # Percorrer todas as séries
  for (i in seq_along(series)) {
    # Criar a URL para a série específica
    url <- bacen_url(series[i], start_date, end_date)

    # Obter os dados da API
    data <- tryCatch(
      bacen_api(url, httr),
      error = function(e) {
        message(paste("Failed to fetch series:", series[i]))
        return(NULL)
      }
    )

    # Se os dados forem válidos, adicioná-los à lista
    if (!is.null(data)) {
      series_data[[names[i]]] <- data$valor
    }
  }

  # Criar um data frame final com as datas como índice
  if (length(series_data) > 0) {
    df <- data.frame(data$data, series_data)
    colnames(df)[1] <- "date"  # Nome da coluna de datas
    return(df)
  } else {
    message("No data retrieved for any series.")
    return(NULL)
  }
}
