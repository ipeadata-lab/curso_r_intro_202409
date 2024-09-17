library(sidrar)

# Sugestão de dados feita pelo Rafael: ------
# https://sidra.ibge.gov.br/Tabela/4092
# Dados trimestrais da PNADc: 
# "Pessoas de 14 anos ou mais de idade,
# por condição em relação à força de trabalho e condição de ocupação"
# Codigo: 4092

# Com o codigo abaixo, a baixa essa tabela que traz pop ocupada e desocupada 
# para cada UF em diferentes trimentes.
# Acho que um dos objetivos do exercicio poderia ser por exemplo calcular a 
# taxa de desocupação de cada estado e cada região ao longo do tempo. 
# Voces vao ver que a tabela é bem 'untidy', entao dá bastante pano pra manga.

informacoes_tabela_4092 <- sidrar::info_sidra(4092)


periodos_disponiveis <- informacoes_tabela_4092$period |> 
  stringr::str_split(pattern = ", ") |> 
  unlist()


dados_4092 <- sidrar::get_sidra(
  # Tabela 4092 - Pessoas de 14 anos ou mais de idade, por condição em relação à força de trabalho e condição de ocupação
  x = 4092,
  # Períodos: trimestres
  period = periodos_disponiveis,
  # Dados agrupados por UF
  geo = "State",
  # 4: Return the codes and names of the descriptors (Default)
  format  = 4
)


# Preparar os dados  ----
# O que cada linha deve representar? UF/trimestre


prep_dados_4092 <- dados_4092 |>
  tibble::as_tibble() |>
  janitor::clean_names() |>
  dplyr::filter(variavel_codigo == 1641) |>
  
  dplyr::mutate(
    condicao = dplyr::case_when(
      condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao == "Total" ~ "total_mil_pessoas",
      condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao == "Força de trabalho" ~ "forca_de_trabalho_total_mil_pessoas",
      condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao == "Força de trabalho - ocupada" ~ "forca_de_trabalho_ocupada_mil_pessoas",
      condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao == "Força de trabalho - desocupada" ~ "forca_de_trabalho_desocupada_mil_pessoas",
      condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao == "Fora da força de trabalho" ~ "fora_da_forca_de_trabalho_mil_pessoas",
    )
  ) |>
  dplyr::select(
    -c(
      condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao_codigo,
      condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao,
      variavel_codigo,
      variavel,
      nivel_territorial_codigo,
      nivel_territorial,
      unidade_de_medida_codigo,
      unidade_de_medida
    )
  ) |>
  tidyr::pivot_wider(names_from = condicao, values_from = valor) |>
  dplyr::relocate(
    forca_de_trabalho_ocupada_mil_pessoas,
    forca_de_trabalho_desocupada_mil_pessoas,
    forca_de_trabalho_total_mil_pessoas,
    fora_da_forca_de_trabalho_mil_pessoas,
    total_mil_pessoas,
    .after = tidyselect::everything()
  ) |>
  dplyr::mutate(
    ano = stringr::str_sub(trimestre_codigo, 1, 4),
    trimestre_numero = stringr::str_sub(trimestre_codigo, 6, 7),
    trimestre_mes_inicio = dplyr::case_when(
      trimestre_numero == 1 ~ 1,
      trimestre_numero == 2 ~ 4,
      trimestre_numero == 3 ~ 7,
      trimestre_numero == 4 ~ 10
    ),
    trimestre_mes_fim = dplyr::case_when(
      trimestre_numero == 1 ~ 3,
      trimestre_numero == 2 ~ 6,
      trimestre_numero == 3 ~ 9,
      trimestre_numero == 4 ~ 12
    ),
    trimestre_data_inicio = lubridate::make_date(ano, trimestre_mes_inicio, 1),
    trimestre_data_fim = lubridate::make_date(
      ano,
      trimestre_mes_fim,
      lubridate::days_in_month(lubridate::make_date(ano, trimestre_mes_fim, 1))
    ),
    .before = tidyselect::everything()
  ) |>
  dplyr::select(-c(trimestre_mes_inicio, trimestre_mes_fim)) |>
  dplyr::relocate(tidyselect::starts_with("trimestre"), .after = ano) |>
  dplyr::rename(trimestre_texto = trimestre) |>
  dplyr::arrange(trimestre_data_inicio, unidade_da_federacao) 






# Salvando os dados brutos em vários formatos, para usar no curso!
readr::write_rds(dados_4092, "dados/sidrar_4092_bruto.rds")

readr::write_csv(
  dados_4092,
  "dados/sidrar_4092_bruto.csv"
)

readr::write_csv2(
  dados_4092,
  "dados/sidrar_4092_bruto_2.csv"
)

writexl::write_xlsx(
  dados_4092,
  "dados/sidrar_4092_bruto.xlsx"
)
