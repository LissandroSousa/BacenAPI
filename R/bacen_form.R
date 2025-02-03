#' Coleta de Dados da API do Banco Central
#'
#' Esta função permite que o usuário insira informações para coletar séries temporais
#' diretamente da API do Banco Central do Brasil (BACEN). Ela orienta o preenchimento de dados
#' como códigos de séries, nomes das séries e períodos desejados, retornando os dados formatados.
#'
#' @return Um data frame contendo as séries temporais coletadas, com colunas para datas
#' e valores correspondentes às séries especificadas.
#'
#' @examples
#' # Exemplo com múltiplas séries:
#' # Suponha que o usuário forneça as seguintes informações durante a execução:
#' # Códigos das séries: c('433', '13005', '24364', '25391')
#' # Nomes atribuídos: c('ipca_br', 'ipca_for', 'ibc_br', 'ibcr_ce')
#' # Período: '01/01/2003' a '01/12/2023'
#'
#' # Após executar a função, os dados podem ser salvos ou utilizados:
#' dados <- bacen_form()
#' print(dados)
#'
#' @export
bacen_form <- function() {

  # Inicializando variáveis
  cod_bacen_series <- name_bacen_series <- NULL
  per_init_bacen_series <- per_end_bacen_series <- ""

  # Info Box
  svDialogs::msg_box(message = 'Caro usuário, a partir de agora você irá inserir as informações necessárias para coletar dados da API do Banco Central. Preencha as informações solicitadas de acordo.')

  # Formulário para inserir séries
  repeat {
    single_cod_bacen_series <- readline(prompt = 'Informe o código da série a ser acessada: ')
    single_name_bacen_series <- readline(prompt = 'Informe como deseja chamar essa série: ')
    cod_bacen_series <- c(cod_bacen_series, single_cod_bacen_series)
    name_bacen_series <- c(name_bacen_series, single_name_bacen_series)
    flag_question <- svDialogs::dlg_message(message = 'Deseja informar mais alguma série?', type = 'yesno')
    if (flag_question$res != "yes") break
  }

  # Inserção do intervalo
  svDialogs::msg_box(message = 'Agora informe o período inicial e final. Padrão: dd/mm/aaaa')

  repeat {
    per_init_bacen_series <- readline(prompt = 'Informe o período inicial: ')
    if (nchar(per_init_bacen_series) == 10) break
    svDialogs::msg_box(message = 'Data de início inválida. Informe novamente.')
  }

  repeat {
    per_end_bacen_series <- readline(prompt = 'Informe o período final: ')
    if (nchar(per_end_bacen_series) == 10) break
    svDialogs::msg_box(message = 'Data de encerramento inválida. Informe novamente.')
  }

  # Baixando as séries
  bacen_series <- NULL
  for (i in seq_along(cod_bacen_series)) {
    bacen_series_raw <- bacen_api(url = bacen_url(cod_bacen_series[i], per_init_bacen_series, per_end_bacen_series))

    if (is.null(bacen_series)) {
      bacen_series <- bacen_series_raw
    } else {
      bacen_series <- cbind(bacen_series, bacen_series_raw[, 2])
    }
  }

  # Renomeando colunas e limpando variáveis auxiliares
  colnames(bacen_series) <- c('data', name_bacen_series)

  # Retornando os dados coletados
  return(bacen_series)
}

