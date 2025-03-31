#' Connection to the Central Bank API
#'
#' This function establishes a connection with the Central Bank of Brazil (BACEN) API,
#' using the `httr` or `httr2` packages to retrieve data in JSON format and convert
#' it into a readable format such as data frames.
#'
#' @param url A string containing the BACEN API URL for the desired series.
#' @param httr A logical value. If `TRUE`, the function uses the `httr` package for the connection.
#' Otherwise, it uses the `httr2` package. The default value is `TRUE`.
#'
#' @return Returns the data retrieved from the BACEN API.
#'
#' @examples
#' # Example using the `httr` package:
#' url <- bacen_url(433, "01/01/2020", "31/12/2023") # in the format "dd/mm/yyyy"
#' data <- bacen_api(url, httr = TRUE)
#'
#'
#'
#' @export
bacen_api <- function(url, httr = TRUE){
  `%>%` <- magrittr::`%>%`
  message('Starting connection to the Bacen API\n')
  flag = 0

  # --- API Connection - Using httr --- #
  if(httr == TRUE){

    # -- API Connection -- #
    api_connection = tryCatch(httr::GET(url = url),
                              error = function(e) return(NULL))

    # --- Connection Flag --- #
    if (is.null(api_connection) || api_connection$status_code != 200) {
      while(flag < 3 && (is.null(api_connection) || api_connection$status_code != 200)) {
        flag = flag + 1
        Sys.sleep(flag * 2)  # Atraso progressivo (2s, 4s, 6s)
        message(paste("Connection issues. Attempt", flag, "...\n"))

        api_connection = tryCatch(httr::GET(url = url),
                                  error = function(e) return(NULL))
      }

      if (is.null(api_connection) || api_connection$status_code != 200) {
        message("Connection failed! Try connecting to the API later.")
        return(NULL)  # Retorna NULL para evitar erro fatal
      }
    }

    message("Connection successful!\nData being collected...\n")

    # --- Converting Data to a Readable Format --- #
    api_connection = tryCatch({
      rawToChar(api_connection$content) %>%
        jsonlite::fromJSON(flatten = TRUE)
    }, error = function(e) {
      message("Error processing API response.")
      return(NULL)
    })
  }

  # --- API Connection - Using httr2 --- #
  else {
    api_connection = tryCatch(httr2::request(base_url = url) %>% httr2::req_perform(),
                              error = function(e) return(NULL))

    if (is.null(api_connection) || api_connection$status_code != 200) {
      while(flag < 3 && (is.null(api_connection) || api_connection$status_code != 200)) {
        flag = flag + 1
        Sys.sleep(flag * 2)
        message(paste("Connection issues. Attempt", flag, "...\n"))

        api_connection = tryCatch(httr2::request(base_url = url) %>% httr2::req_perform(),
                                  error = function(e) return(NULL))
      }

      if (is.null(api_connection) || api_connection$status_code != 200) {
        message("Connection failed! Try connecting to the API later.")
        return(NULL)
      }
    }

    message("Connection successful!\nData being collected...\n")

    # --- Converting Data to a Readable Format --- #
    api_connection = tryCatch({
      rawToChar(api_connection$body) %>%
        jsonlite::fromJSON(flatten = TRUE)
    }, error = function(e) {
      message("Error processing API response.")
      return(NULL)
    })
  }

  return(api_connection)
}

