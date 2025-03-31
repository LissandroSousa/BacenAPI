utils::globalVariables("dataset")


#' Search for Financial Indicators Series Number
#'
#' Performs a search for financial indicator series based on a keyword.
#'
#' @param keyword A string containing the search term in Portuguese - BR (e.g., "câmbio", "juros", "Bovespa").
#'
#' @return A data frame with the columns `Code`, `Full_Name`, `Unit`, `Periodicity`, and `Start_Date` corresponding to the search results.
#'
#' @examples
#' # Search for indices related to Fortaleza
#' bacen_search("fortaleza")
#'
#' @export
#' Search for Financial Indicators Series Number
#'
#' Performs a search for financial indicator series based on a keyword.
#'
#' @param keyword A string containing the search term in Portuguese - BR (e.g., "câmbio", "juros", "Bovespa").
#'
#' @return A data frame with the columns `Code`, `Full_Name`, `Unit`, `Periodicity`, and `Start_Date` corresponding to the search results.
#'
#' @importFrom utils data
#'
#' @examples
#' # Search for indices related to Fortaleza
#' bacen_search("fortaleza")
#'
#' @export
bacen_search <- function(keyword) {
  # Load dataset correctly
  data("dataset", package = "BacenAPI", envir = environment())

  # Case-insensitive and partial match search
  results <- dataset[
    grepl(
      pattern = tolower(keyword),
      x = tolower(dataset$Full_Name),
      fixed = FALSE
    ),
    c("Code", "Full_Name", "Unit", "Periodicity", "Start_Date")
  ]

  # Truncate Full_Name to 50 characters to improve readability
  results$Full_Name <- substr(results$Full_Name, 1, 50)

  # Return formatted results
  if (nrow(results) == 0) {
    message("No indicators found for the keyword '", keyword, "'.")
    return(invisible(NULL))
  } else {
    return(results)
  }
}

