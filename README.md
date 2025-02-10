# Accessing Brazil Central Bank Data via API

## Overview
This simple library allows users to access Brazil Central Bank (BACEN) data by interacting with its API. The library consists of three main R scripts that work together:

1. **Bacen_URL**: Generates the URL where the data is available.
2. **Bacen_API**: Connects with the BACEN API, extracts the requested information, and converts it to a readable format.
3. **Bacen_Form**: A user-friendly form that gathers necessary input for data extraction.

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

## Bacen_Form

### Description
This script interacts with the user to gather information necessary for data extraction. The steps are as follows:

1. Prompt the user to input the series code and a short name for each series.
2. Ask whether additional series should be specified.
3. Prompt for the start and end dates.

The information gathered is stored in variables representing series codes, names, and date intervals.

### Note
While this example directly sets variables for demonstration purposes, you should use `Bacen_Form` interactively in your R console.

---

## Combining All Functions

### Example
This example demonstrates the integration of all scripts to extract data for four variables:
- Price Index and Economic Activity Index for Brazil and Ceará.
- Codes: `433`, `24364`, `13005`, `25391`.
- Names: `ipca_br`, `ipca_for`, `ibc_br`, `ibcr_ce`.
- Date interval: `01/01/2003` to `31/12/2023`.

```r
# Access API data with multiple series
# Assume the user provides the following information during execution
data  <- bacen_form()

# Display results
print(head(bacen_series))
```

**Sample Output:**
```
         data ipca_br ipca_for ibc_br ibcr_ce
1  01/01/2003    2.25     2.04 100.46  101.28
2  01/02/2003    1.57     2.04 102.12  100.92
3  01/03/2003    1.23     0.66 101.72  100.19
4  01/04/2003    0.97     1.59 101.08  100.41
5  01/05/2003    0.61     1.17  99.97  100.25
6  01/06/2003   -0.15    -0.22 100.14  101.38
```

---

## Footnotes
- Customize series codes and date ranges as per your needs.

