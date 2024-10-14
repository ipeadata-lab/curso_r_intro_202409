# Carregando pacotes
library(tidyverse)
library(janitor)

# mensagem que apareceu: é um aviso de funções com o mesmo nome.
# Attaching package: ‘janitor’
# 
# The following objects are masked from ‘package:stats’:
# 
#     chisq.test, fisher.test

# Carregando os dados -----------------------------------------
dados_brutos <- read_rds("dados/sidrar_4092_bruto.rds")

# Limpando os nomes das colunas --------------------------------
dados_renomeados <- clean_names(dados_brutos)

# Verificando o nome das colunas
names(dados_renomeados)


# Valores distintos --------------------------------------------
View(distinct(
  # base de dados
  dados_renomeados, 
  # colunas que queremos bucar os valores distintos 
  variavel, unidade_de_medida
))

# Conhecendo o pipe ------------
dados_renomeados |> # %>%
  distinct(
    variavel, unidade_de_medida
  ) |> 
  View()


# pipe: ctrl + shift + M
# Pipe do R base: |>
# Pipe do tidyverse: %>% (mais antigo)

sum(c(1,2))

c(1,2) |> 
  sum()

# filter() -----------------------------

dados_filtrados <- dados_renomeados |> 
  filter(variavel == "Pessoas de 14 anos ou mais de idade")

# exemplo sem pipe
select(filter(clean_names(dados_brutos), 
      variavel == "Pessoas de 14 anos ou mais de idade"),
      valor, unidade_da_federacao, trimestre)

# exemplo com pipe
dados_brutos |> 
  clean_names() |> 
  filter(variavel == "Pessoas de 14 anos ou mais de idade") |> 
  select(valor, unidade_da_federacao, trimestre) 

# Uma coisa E outra
dados_renomeados |> 
  filter(variavel == "Pessoas de 14 anos ou mais de idade", # & 
         unidade_da_federacao == "São Paulo") |> View()

# Uma coisa OU outra
dados_renomeados |> 
  filter(unidade_da_federacao == "São Paulo" | # OU
         trimestre == "2º trimestre 2024") |> View()


dados_renomeados |> 
  filter(str_detect(variavel, "percentual")) |> 
  View()


# select() ----------------------------

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

View(dados_selecionados)

glimpse(dados_selecionados)

# Usando funções auxiliares para selecionar colunas
dados_filtrados |> 
  select(contains("codigo")) |> 
  View()


# Renomeando colunas --------------------------
dados_renomeados_2 <- rename(
  # base de dados
  dados_selecionados, 
  # colunas que queremos renomear: novo_nome = nome_atual
  condicao = condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao,
  valor_mil_pessoas = valor,
  uf = unidade_da_federacao,
  uf_codigo = unidade_da_federacao_codigo
)

glimpse(dados_renomeados_2)


# transformando a tabela -------------------------------

## pivot_wider() ------
# uf | uf_codigo | trimestre | trimestre_codigo | condicao | valor_mil_pessoas

# uf | uf_codigo | trimestre | trimestre_codigo | total_mil_pessoas | forca_de_trabalho_mil_pessoas | ...


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

View(dados_largos)

## exemplo com pivot_longer() -----
pivot_longer(
  dados_largos, 
  cols = starts_with("mil_pessoas"),
  names_to = "condicao",
  values_to = "valor_mil_pessoas"
) |> View()


# limpando novamente os nomes --------------
dados_largos_renomeados <- clean_names(dados_largos)
glimpse(dados_largos_renomeados)

# mutate() --------------------------------------
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


View(dados_tipo)

## case_when() ----------------------------
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



## podemos usar também a função if_else(  )

# https://recipes.tidymodels.org/reference/step_dummy.html
# https://cran.r-project.org/web/packages/fastDummies/vignettes/making-dummy-variables.html

# aula 4 ---------------

# arrange() ---------------------------
dados_dummy |> 
  arrange(perc_desocupacao) |> View()

dados_dummy |> 
  arrange(desc(perc_desocupacao)) |> 
  View()

dados_dummy |> 
  arrange(trimestre_inicio, uf) 

dados_dummy |> 
  arrange(desc(trimestre_inicio), desc(perc_desocupacao)) |> View()

# ordem das colunas importa
dados_dummy |> 
  arrange(uf, trimestre_inicio) |> View()

# dúvida: 
dados_dummy |> 
  arrange(desc(perc_desocupacao)) |>
  select(uf, trimestre, perc_desocupacao) |> 
  head(15) |> # busca as 15 primeiras linhas
  View()

# left_join() -----------

uf_regiao <- readr::read_csv("https://raw.githubusercontent.com/ipeadata-lab/curso_r_intro_202409/refs/heads/main/dados/uf_regiao.csv")

# readr::write_csv(uf_regiao, "dados/uf_regiao.csv")

View(uf_regiao)

# |> CTRL SHIFT M  / Command SHIFT M

# chave: uf_codigo

dados_dummy |> 
  left_join(uf_regiao, by = "uf_codigo")

# Error in `left_join()`:
# ! Can't join `x$uf_codigo` with `y$uf_codigo` due to
#   incompatible types.
# ℹ `x$uf_codigo` is a <factor<48524>>.
# ℹ `y$uf_codigo` is a <double>.

uf_regiao_fct <- uf_regiao |> 
  mutate(uf_codigo = as.factor(uf_codigo))


dados_com_regiao <- dados_dummy |> 
  left_join(uf_regiao_fct, by = c("uf_codigo")) |> 
  relocate(uf_sigla, regiao, .after = uf_codigo) 

## Exemplo 2, com geobr --------------------------------
# geobr
# install.packages("geobr")
geo_estados <- geobr::read_state(showProgress = FALSE)
glimpse(geo_estados)

class(geo_estados)

library(ggplot2)
ggplot(geo_estados) + geom_sf()

left_join(geo_estados,
          dados_com_regiao,
          by = join_by(code_state == uf_codigo))


dados_geo <- geo_estados |> 
  mutate(code_state = as.factor(code_state)) |> 
  left_join(dados_com_regiao, by = c("code_state" = "uf_codigo"))

# gráfico usando a base de dados unida
library(ggplot2)
dados_geo |> 
  filter(trimestre_codigo == "202402") |>
  ggplot() +
  geom_sf(aes(fill = perc_desocupacao)) +
  theme_light() +
  scale_fill_viridis_c() +
  labs(title = "Percentual de desocupação por UF no 2º trimestre de 2024",
       fill = "Desocupação (%)") +
  theme(legend.position = "bottom")


# salvar os dados arrumados -------------------
readr::write_rds(dados_com_regiao, "dados_output/sidra_4092_arrumado.rds")

writexl::write_xlsx(dados_com_regiao, "dados_output/sidra_4092_arrumado.xlsx")
