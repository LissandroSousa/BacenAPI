# Accessing Brazil Central Bank Data via API

## Overview
This simple library allows users to access Brazil Central Bank (BACEN) data by interacting with its API. The library consists of three main R scripts that work together:

1. **Bacen_URL**: Generates the URL where the data is available.
2. **Bacen_API**: Connects with the BACEN API, extracts the requested information, and converts it to a readable format.
3. **Bacen_series**: Retrieves data from multiple Central Bank series, given a vector of series IDs and corresponding names.
4. **bacen_search**: Searches for financial indicator series using keywords in Portuguese.
5. **dataset**: object is a preloaded data frame containing metadata about the financial indicator series available from the Central Bank of Brazil (BACEN).

This README provides a detailed guide on how to use each function.

---

## Bacen_URL

### Description
This function generates the URL for accessing BACEN data by specifying three arguments:
- `series`: The series code.
- `star_date`: The start date.
- `end_date`: The end date.

### Important Notes
- Use the Brazilian date format: `dd/mm/yyyy`.
- Ensure dates are provided as strings/characters.

### Example
```r
# Generate URL for IPCA series from 01/01/2003 to 31/12/2023
ipca_br_url <- bacen_url(433, '01/01/2003', '31/12/2023')

# Output
print(ipca_br_url)
```
**Result:**
```
[1] "https://api.bcb.gov.br/dados/serie/bcdata.sgs.433/dados?formato=json&dataInicial=01/01/2003&dataFinal=31/12/2023"
```

---

## Bacen_API

### Description
This function connects to the BACEN API using either the `httr` or `httr2` package. It internally verifies the HTTP status code (e.g., `200` for success, `400/404` for failure) and retries up to three times if the initial connection fails.

### Arguments
- `url`: The URL generated using the `Bacen_URL` function.
- `httr`: A logical variable indicating whether to use `httr`. Defaults to `TRUE`.

### Example
```r
# URL for IPCA series
ipca_br_url <- bacen_url(433, '01/01/2003', '31/12/2023')

# Access API data
data <- bacen_api(url = ipca_br_url, httr = TRUE)

# Display results
print(head(data))
```
**Sample Output:**
```
         data valor
1  01/01/2003  2.25
2  01/02/2003  1.57
3  01/03/2003  1.23
4  01/04/2003  0.97
5  01/05/2003  0.61
6  01/06/2003 -0.15
```

---

## Bacen_series

### Description
This function retrieves data from multiple Central Bank series, given a vector of series IDs and corresponding names:

### Arguments

- `series`: A numeric vector containing the series IDs from Central Bank API.
- `names`: A character vector containing the names corresponding to each series.
- `start_date`: A string specifying the start date in `dd/mm/yyyy` format.
- `end_date`: A string specifying the end date in `dd/mm/yyyy` format.
- `httr`: A logical value indicating whether to use `httr` (`TRUE`) or `httr2` (`FALSE`). Default is TRUE.

### Example
```r
# Retrieve data for multiple series
series <- c('433', '13005')
names <- c('ipca_br', 'ipca_for')
data <- bacen_series(series, names, "01/01/2013", "31/12/2023", httr = TRUE)

# Display results
print(head(data))
```
**Sample Output:**
```
         date ipca_br ipca_for
1  01/01/2013    0.79     0.74
2  01/02/2013    0.60     0.53
3  01/03/2013    0.47     0.40
4  01/04/2013    0.55     0.50
5  01/05/2013    0.37     0.32
6  01/06/2013    0.26     0.21
```

---

## bacen_search

### Description
The `bacen_search()` function allows users to search for financial indicator series based on keywords. It is useful when the exact series code is unknown, but a topic or name is available.

### Arguments
- `keyword`: A character string (in Portuguese) containing the search term. Example: `"câmbio"`, `"juros"`, `"Bovespa"`, `"fortaleza"`.

### Returns
A `data.frame` with the following columns:
- `Code`: The series number from BACEN.
- `Full_Name`: The full name of the financial indicator (truncated to 50 characters for readability).
- `Unit`: The unit of measurement of the indicator.
- `Periodicity`: Frequency of the series (e.g., Monthly, Daily).
- `Start_Date`: The initial date when the series began.

If no matches are found, an informative message will be printed and the function returns `NULL`.

### Example
```r
# Search for financial indicators related to "fortaleza"
bacen_search("fortaleza")
```
**Sample Output:**
```
  Code                         Full_Name                   Unit Periodicity Start_Date
1 1619 Índice de Preços ao Consumidor - Fortaleza           %     Monthly   01/01/1991
2 4414 Índice Nacional de Preços ao Consumidor - Fortaleza  %     Monthly   01/01/1991
```

---

## dataset

### Description
The `dataset` object is a preloaded data frame containing metadata about the financial indicator series available from the Central Bank of Brazil (BACEN). It is used internally by the `bacen_search()` function and can also be accessed directly by users for custom searches and exploration.

### Format
A `data.frame` with multiple rows and the following 5 columns:

- `Code`: *(character)* The unique identifier for each financial indicator series.
- `Full_Name`: *(character)* The full name or description of the financial indicator.
- `Unit`: *(character)* The unit of measurement used for the data (e.g., %, R$, index value).
- `Periodicity`: *(character)* The frequency with which data is collected (e.g., Daily, Monthly, Annual).
- `Start_Date`: *(Date)* The date on which the series began.

### Source
Data collected and compiled from the **Central Bank of Brazil (BACEN)**.

### Example
```r
# Load the dataset
data("dataset")

# Preview the first few rows
head(dataset)
```

---

## Footnotes
- Customize series codes and date ranges as per your needs.

