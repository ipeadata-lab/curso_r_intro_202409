library(tidyverse)
library(janitor)

dados_brutos <- read_rds("dados/sidrar_4092_bruto.rds")

dados_renomeados <- clean_names(dados_brutos)

dados_filtrados <- dados_renomeados |> 
  filter(variavel == "Pessoas de 14 anos ou mais de idade")

dados_selecionados <- select(
  # base de dados
  dados_filtrados, 
  # colunas que queremos manter
  unidade_da_federacao,
  unidade_da_federacao_codigo,
  trimestre,
  trimestre_codigo,
  condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao,
  valor
) 

dados_renomeados_2 <- rename(
  # base de dados
  dados_selecionados, 
  # colunas que queremos renomear: novo_nome = nome_atual
  condicao = condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao,
  valor_mil_pessoas = valor,
  uf = unidade_da_federacao,
  uf_codigo = unidade_da_federacao_codigo
)

dados_largos <- pivot_wider(
  # base de dados
  dados_renomeados_2, 
  # nome da coluna de onde os nomes das novas colunas serão extraídos
  names_from = condicao, 
  # nome da coluna de onde os valores das novas colunas serão extraídos 
  values_from = valor_mil_pessoas, 
  # podemos adicionar um texto como prefixo. nesse caso, isso é opcional, 
  # mas é útil para ficar claro qual é a unidade de medida das variáveis
  names_prefix = "mil_pessoas_"
)

dados_largos_renomeados <- clean_names(dados_largos)


dados_tipo <- dados_largos_renomeados |> 
  mutate(
    uf_codigo = as.factor(uf_codigo),
    prop_desocupacao = mil_pessoas_forca_de_trabalho_desocupada / mil_pessoas_forca_de_trabalho,
    perc_desocupacao = prop_desocupacao * 100) |> 
  mutate(
    ano = str_sub(trimestre_codigo, 1, 4),
    ano = as.numeric(ano),
    trimestre_numero = as.numeric(str_sub(trimestre_codigo, 5, 6)),
    trimestre_mes_inicio = case_when(
      trimestre_numero == 1 ~ 1, # janeiro
      trimestre_numero == 2 ~ 4, # abril 
      trimestre_numero == 3 ~ 7, # julho
      trimestre_numero == 4 ~ 10 # outubro
    ),
    trimestre_inicio = paste0(ano, "-", trimestre_mes_inicio, "-01"), # YYYY-MM-DD
    trimestre_inicio = as.Date(trimestre_inicio),
    .after = trimestre_codigo
  ) |> 
  select(-trimestre_numero, -trimestre_mes_inicio)

dados_dummy <- dados_tipo |>
  mutate(periodo_pandemia = case_when(
    trimestre_codigo %in% c(
      "202002",
      "202003",
      "202004",
      "202101",
      "202102",
      "202103",
      "202104",
      "202201"
    ) ~ 1,
    .default = 0
  ))



# if_else(  )

# https://recipes.tidymodels.org/reference/step_dummy.html
# https://cran.r-project.org/web/packages/fastDummies/vignettes/making-dummy-variables.html

# aula 4 ---------------

# join ----
uf_regiao <- readr::read_csv("https://raw.githubusercontent.com/ipeadata-lab/curso_r_intro_202409/refs/heads/main/dados/uf_regiao.csv")

readr::write_csv(uf_regiao, "dados/uf_regiao.csv")

uf_regiao_fct <- uf_regiao |> 
  mutate(uf_codigo = as.factor(uf_codigo))

dados_com_regiao <- dados_dummy |> 
  left_join(uf_regiao_fct, by = c("uf_codigo")) |> 
  relocate(uf_sigla, regiao, .after = uf_codigo) 

