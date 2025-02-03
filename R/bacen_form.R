#' Data Collection from the Central Bank API
#'
#' This function allows the user to input information to collect time series
#' directly from the Central Bank of Brazil (BACEN) API. It guides the user
#' in providing data such as series codes, series names, and desired periods,
#' returning the data in a formatted structure.
#'
#' @return A data frame containing the collected time series, with columns for dates
#' and values corresponding to the specified series.
#'
#' @examples
#' # Example with multiple series:
#' # Assume the user provides the following information during execution:
#' # Series codes: c('433', '13005', '24364', '25391')
#' # Assigned names: c('ipca_br', 'ipca_for', 'ibc_br', 'ibcr_ce')
#' # Period: '01/01/2003' a '01/12/2023', in the format "dd/mm/yyyy"
#'
#' # After running the function, the data can be saved or used:
#' data  <- bacen_form()
#' print(data)
#'
#' @export
bacen_form <- function() {

  # Initializing variables
  cod_bacen_series <- name_bacen_series <- NULL
  per_init_bacen_series <- per_end_bacen_series <- ""

  # Info Box
  svDialogs::msg_box(message = 'Dear user, from now on you will enter the necessary information to collect data from the Central Bank API. Please fill in the requested information accordingly.')

  # Form to enter series
  repeat {
    single_cod_bacen_series <- readline(prompt = 'Enter the code of the series to be accessed: ')
    single_name_bacen_series <- readline(prompt = 'Enter the name you want to assign to this series: ')
    cod_bacen_series <- c(cod_bacen_series, single_cod_bacen_series)
    name_bacen_series <- c(name_bacen_series, single_name_bacen_series)
    flag_question <- svDialogs::dlg_message(message = 'Do you want to enter another series?', type = 'yesno')
    if (flag_question$res != "yes") break
  }

  # Entering the interval
  svDialogs::msg_box(message = 'Now enter the initial and final period. Format: dd/mm/yyyy')

  repeat {
    per_init_bacen_series <- readline(prompt = 'Enter the initial period: ')
    if (nchar(per_init_bacen_series) == 10) break
    svDialogs::msg_box(message = 'Invalid start date. Please enter again.')
  }

  repeat {
    per_end_bacen_series <- readline(prompt = 'Enter the final period: ')
    if (nchar(per_end_bacen_series) == 10) break
    svDialogs::msg_box(message = 'Invalid end date. Please enter again.')
  }

  # Downloading the series
  bacen_series <- NULL
  for (i in seq_along(cod_bacen_series)) {
    bacen_series_raw <- bacen_api(url = bacen_url(cod_bacen_series[i], per_init_bacen_series, per_end_bacen_series))

    if (is.null(bacen_series)) {
      bacen_series <- bacen_series_raw
    } else {
      bacen_series <- cbind(bacen_series, bacen_series_raw[, 2])
    }
  }

  # Renaming columns and cleaning auxiliary variables
  colnames(bacen_series) <- c('data', name_bacen_series)

  # Returning the collected data
  return(bacen_series)
}

