#' Conexão com a API do Banco Central
#'
#' Esta função estabelece uma conexão com a API do Banco Central do Brasil (BACEN),
#' utilizando os pacotes `httr` ou `httr2`, para obter dados em formato JSON e convertê-los
#' em um formato legível como data frames.
#'
#' @param url Um string contendo o URL da API do BACEN para a série desejada.
#' @param httr Um valor lógico. Se `TRUE`, a função utiliza o pacote `httr` para a conexão.
#' Caso contrário, utiliza o pacote `httr2`. O valor padrão é `TRUE`.
#'
#' @return Retorna os dados obtidos da API do BACEN.
#'
#' @examples
#' # Exemplo usando o pacote httr:
#' url <- bacen_url(433, "01/01/2003", "31/12/2023")
#' dados <- bacen_api(url, httr = TRUE)
#'
#' # Exemplo usando o pacote httr2:
#' dados <- bacen_api(url, httr = FALSE)
#'
#'
#' @export
bacen_api = function(url, httr = TRUE){
  message('Iniciando a conexao com a API do Bacen\n')
  flag = 0

  # --- API Connection - Using httr --- #
  if(httr == TRUE){

    # -- API Connection -- #
    api_connection = httr::GET(url = url)


    # --- Connection Flag --- #
    if(api_connection$status_code == 200){
      svDialogs::dlg_message(message = 'Conexao bem sucedida ! \nDados sendo coletados ...\n', type = 'ok')
    }
    else if(api_connection$status_code != 200){
      while(api_connection$status_code != 200 & flag <= 3){
        flag = flag + 1

        if(flag == 1){
          Sys.sleep(2)
          message('Problemas na conexao. \nTentando acessar a API novamente ...\n')}
        if(flag == 2){
          Sys.sleep(5)
          message('Problemas na conexao. \nTentando acessar a API novamente ...\n')}
        if(flag == 3){
          Sys.sleep(10)
          message('Problemas na conexao. \nTentando acessar a API uma última vez ...\n')}

        api_connection = httr::GET(url = url)
      }

      ifelse(api_connection$status_code == 200,
             svDialogs::dlg_message(message = 'Conexao bem sucedida ! \nDados sendo coletados ...\n', type = 'ok'),
             svDialogs::dlg_message(message = 'Falha na conexao ! \nTente conectar com a API mais tarde.', type = 'ok')
      )
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
      svDialogs::dlg_message(message = 'Conexao bem sucedida ! \nDados sendo coletados ...\n', type  = 'ok')
    }
    else if(api_connection$status_code != 200){
      while(api_connection$status_code != 200 & flag <= 3){
        flag = flag + 1

        if(flag == 1){
          Sys.sleep(2)
          message('Problemas na conexao. \nTentando acessar a API novamente ...\n')}
        if(flag == 2){
          Sys.sleep(5)
          message('Problemas na conexao. \nTentando acessar a API novamente ...\n')}
        if(flag == 3){
          Sys.sleep(10)
          message('Problemas na conexao. ! \nTentando acessar a API uma última vez ...\n')}

        api_connection = httr2::request(base_url = url) %>% httr2::req_perform()
      }

      ifelse(api_connection$status_code == 200,
             svDialogs::dlg_message(message = 'Conexao bem sucedida ! \nDados sendo coletados ...\n', type = 'ok'),
             svDialogs::dlg_message(message = 'Falha na conexao ! \nTente conectar com a API mais tarde.', type = 'ok')
      )
    }


    # --- Converting Data to a Readable Format --- #
    api_connection = rawToChar(api_connection$body)                 # Raw to JSon
    api_connection = jsonlite::fromJSON(api_connection, flatten = TRUE)       # Json to Data Frame
  }



  # --- Output --- #
  return(api_connection)
}
