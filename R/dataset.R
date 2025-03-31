#' Financial Indicators Dataset
#'
#' This dataset contains information on financial indicator series available from BacenAPI.
#'
#' @format A data frame with multiple rows and 5 columns:
#' \describe{
#'   \item{Code}{(character) The unique series number.}
#'   \item{Full_Name}{(character) The name of the financial series.}
#'   \item{Unit}{(character) The unit of measurement for the data.}
#'   \item{Periodicity}{(character) The frequency of data collection (e.g., daily, monthly, yearly).}
#'   \item{Start_Date}{(Date) The starting date of the series.}
#' }
#'
#' @source Central Bank of Brazil (Bacen)
#'
#' @examples
#' data("dataset")
#' head(dataset)
"dataset"
