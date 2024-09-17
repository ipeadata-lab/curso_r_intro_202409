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

# Buscando informação desta tabela no SIDRA
informacoes_tabela_4092 <- sidrar::info_sidra(4092)

# Quais são os períodos disponíveis?
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
  # Transformando em tibble para facilitar a manipulação dos dados
  tibble::as_tibble() |>
  # Limpando os nomes das colunas (coloca os nomes das colunas em minúsculas e substitui espaços por "_")
  janitor::clean_names() |>
  # Filtrando apenas a variável de interesse (pessoas de 14 anos ou mais de idade)
  dplyr::filter(variavel_codigo == 1641) |>
  dplyr::mutate(
    # Criando uma nova coluna chamada "condição", baseada nos valores presentes
    # em condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao
    # Queremos deixar os nomes das categorias de forma que facilite a virar nomes
    # de colunas posteriormentte
    condicao = janitor::make_clean_names(
      condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao,
      allow_dupes = TRUE
    ),
    # colando o texto "_mil_pessoas" no final de cada valor de condicao
    # assim fica mais claro que essas colunas representam a quantidade de pessoas (em milhares)
    condicao = paste0(condicao, "_mil_pessoas"),
  ) |>
    # Removendo colunas
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
    )) |> 
  # Transformando os dados de formato longo para largo
  # Agora cada linha representa um trimestre de um estado
  # Os valores usados para as colunas virão da coluna "condicao"
  # e os valores usados para as células virão da coluna "valor"
  tidyr::pivot_wider(names_from = condicao, values_from = valor) |>
  # Reordenando as colunas, para ficar mais fácil de endender
  dplyr::relocate(
    forca_de_trabalho_ocupada_mil_pessoas,
    forca_de_trabalho_desocupada_mil_pessoas,
    forca_de_trabalho_mil_pessoas,
    fora_da_forca_de_trabalho_mil_pessoas,
    total_mil_pessoas,
    .after = tidyselect::everything()
  ) |>
  # Criando novas colunas para o ano, trimestre, mês de início e fim do trimestre
  # Isso poderia ser uma função!
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
  # Removendo colunas
  dplyr::select(-c(trimestre_mes_inicio, trimestre_mes_fim)) |>
  # Reordenando colunas
  dplyr::relocate(tidyselect::starts_with("trimestre"), .after = ano) |>
  # Renomeando a coluna trimestre
  dplyr::rename(trimestre_texto = trimestre) |>
  # Ordenando as linhas
  dplyr::arrange(trimestre_data_inicio, unidade_da_federacao)






# Salvando os dados brutos em vários formatos, para usar no curso!
readr::write_rds(dados_4092, "dados/sidrar_4092_bruto.rds")

readr::write_csv(dados_4092, "dados/sidrar_4092_bruto.csv")

readr::write_csv2(dados_4092, "dados/sidrar_4092_bruto_2.csv")

writexl::write_xlsx(dados_4092, "dados/sidrar_4092_bruto.xlsx")


# Salvando os dados preparados em vários formatos, para usar no curso!

readr::write_rds(prep_dados_4092, "dados/sidrar_4092.rds")

readr::write_csv(prep_dados_4092, "dados/sidrar_4092.csv")

readr::write_csv2(prep_dados_4092, "dados/sidrar_4092_2.csv")

writexl::write_xlsx(prep_dados_4092, "dados/sidrar_4092.xlsx")


