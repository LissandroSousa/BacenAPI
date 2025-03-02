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
#' url <- bacen_url(433, "01/01/2003", "31/12/2023") # in the format "dd/mm/yyyy"
#' data <- bacen_api(url, httr = TRUE)
#'
#' # Example using the `httr2` package:
#' data <- bacen_api(url, httr = FALSE)
#'
#'
#' @export
bacen_api = function(url, httr = TRUE){
  message('Starting connection to the Bacen API\n')
  flag = 0

  # --- API Connection - Using httr --- #
  if(httr == TRUE){

    # -- API Connection -- #
    api_connection = httr::GET(url = url)


    # --- Connection Flag --- #
    if(api_connection$status_code == 200){
      message("Connection successful!\nData being collected...\n")
    }
    else if(api_connection$status_code != 200){
      while(api_connection$status_code != 200 & flag <= 3){
        flag = flag + 1

        if(flag == 1){
          Sys.sleep(2)
          message('Connection issues. \nTrying to access the API again ...\n')}
        if(flag == 2){
          Sys.sleep(5)
          message('Connection issues. \nTrying to access the API again ...\n')}
        if(flag == 3){
          Sys.sleep(10)
          message('Connection issues. \nTrying to access the API one last time ...\n')}

        api_connection = httr::GET(url = url)
      }

      if (api_connection$status_code == 200) {
        message("Connection successful!\nData being collected...\n")
      } else {
        message("Connection failed!\nTry connecting to the API later.")
      }
    }


    # --- Converting Data to a Readable Format --- #
    api_connection = rawToChar(api_connection$content)              # Raw to Json
    api_connection = jsonlite::fromJSON(api_connection, flatten = TRUE)       # Json to Data Frame
  }



  # --- API Connection - Using httr2 --- #
  else{

    # -- API Connection -- #
    api_connection = httr2::request(base_url = url) %>% httr2::req_perform()


    # --- Connection Flag --- #
    if(api_connection$status_code == 200){
      message("Connection successful!\nData being collected...\n")
    }
    else if(api_connection$status_code != 200){
      while(api_connection$status_code != 200 & flag <= 3){
        flag = flag + 1

        if(flag == 1){
          Sys.sleep(2)
          message('Connection issues. \nTrying to access the API again ...\n')}
        if(flag == 2){
          Sys.sleep(5)
          message('Connection issues. \nTrying to access the API again ...\n')}
        if(flag == 3){
          Sys.sleep(10)
          message('Connection issues ! \nTrying to access the API one last time ...\n')}

        api_connection = httr2::request(base_url = url) %>% httr2::req_perform()
      }

      if (api_connection$status_code == 200) {
        message("Connection successful!\nData being collected...\n")
      } else {
        message("Connection failed!\nTry connecting to the API later.")
      }
    }


    # --- Converting Data to a Readable Format --- #
    api_connection = rawToChar(api_connection$body)                 # Raw to JSon
    api_connection = jsonlite::fromJSON(api_connection, flatten = TRUE)       # Json to Data Frame
  }



  # --- Output --- #
  return(api_connection)
}


