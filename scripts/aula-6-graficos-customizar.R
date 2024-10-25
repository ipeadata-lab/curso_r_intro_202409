# Carregar pacotes
library(ggplot2)
library(dplyr)

# Carregar os dados
dados <- readr::read_rds("dados_output/sidra_4092_arrumado.rds")

# Filtrar os dados mais recentes
dados_tri_recente <- dados |>
  filter(trimestre_inicio == max(trimestre_inicio))


# Criando um gráfico base para customizar
grafico_base <- dados_tri_recente |>
  ggplot() +
  aes(y = uf, x = perc_desocupacao) +
  geom_col()

grafico_base

# Conceito importante: Fatores/factors ----
# para trabalhar com dados categóricos

# Criando uma tabela de exemplo
escolaridade <- tibble(
  nome = c(
    "Maria",
    "João",
    "Pedro",
    "Ana",
    "José",
    "Carlos",
    "Mariana",
    "Lucas"
  ),
  escolaridade_concluida = c(
    "Pós-graduação",
    "Ensino Médio",
    "Ensino Fundamental II",
    "Ensino Fundamental I",
    "Ensino Fundamental I",
    "Sem instrução",
    "Ensino Técnico",
    "Graduação"
  )
)

# ordenar por uma coluna character faz com que
# a ordem seja alfabéfica
escolaridade |>
  arrange(escolaridade_concluida) # ordem alfabética

# Transformar a coluna em fator
escolaridade_com_fct <- escolaridade |>
  mutate(escolaridade_concluida_fct = factor(
    escolaridade_concluida,
    levels = c(
      "Sem instrução",
      "Ensino Fundamental I",
      "Ensino Fundamental II",
      "Ensino Médio",
      "Ensino Técnico",
      "Graduação",
      "Pós-graduação"
    )
  ))

# Ordenando com o fator
escolaridade_com_fct |>
  arrange(escolaridade_concluida_fct)

# gráfico ordenado com forcats

# preparando os dados: criando uma coluna do tipo factor
dados_reordenados <- dados_tri_recente |>
  # select(uf, perc_desocupacao, regiao) |>
  mutate(uf_fct = forcats::fct_reorder(uf, perc_desocupacao)) |>
  arrange(uf_fct)

# usando o fator para ordenar
grafico_ordenado <- dados_reordenados |>
  ggplot() +
  geom_col(aes(x = perc_desocupacao, y = uf_fct))


# com R base: reorder
dados_tri_recente |>
  ggplot() +
  geom_col(aes(x = perc_desocupacao, y = reorder(uf, perc_desocupacao)))

# Adicionando textos nos eixos, legendas, títulos -----------------

grafico_com_labels <- grafico_ordenado +
  labs(
    title = "Taxa de desocupação por estado",
    subtitle = "Dados para o 2º trimestre 2024",
    caption = "Fonte: Dados referentes à PNAD Contínua Trimestral, obtidos no SIDRA/IBGE.",
    x = "Taxa de desocupação (%)",
    y = "Estado"
  )

grafico_com_labels

# cores ----------------

dados_reordenados |>
  ggplot() +
  geom_col(aes(x = perc_desocupacao, y = uf_fct, fill = regiao)) +
  scale_fill_viridis_d()

dados_reordenados |>
  ggplot() +
  geom_col(aes(x = perc_desocupacao, y = uf_fct, fill = regiao)) +
  scale_fill_viridis_d(option = "D", end = 0.9)


dados_reordenados |>
  ggplot() +
  geom_col(aes(x = perc_desocupacao, y = uf_fct, fill = perc_desocupacao)) +
  scale_fill_viridis_c()


dados_reordenados |>
  ggplot() +
  geom_col(aes(x = perc_desocupacao, y = uf_fct, fill = perc_desocupacao)) +
  scale_fill_gradient(high = "red", low = "green")


# escala de datas -------------------------

# Alterando o locale para português do Brasil
Sys.setlocale("LC_ALL", "pt_br.utf-8")



dados |>
  filter(uf_sigla == "BA", ano >= 2022) |>
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao) +
  geom_line() +
  geom_point() +
  # configurando escala de datas
  scale_x_date(
    date_labels = "%b/%y",
    # "%Y-%m"
    date_breaks = "3 months",
    minor_breaks = "1 month"
  ) +
  # escala contínua
  scale_y_continuous(limits = c(0, 20))


# Temas ----------------------------------------------------

grafico_com_labels +
  theme_minimal()

grafico_com_labels +
  theme_minimal() +
  theme(title = element_text(color = "red", family = "Comic sans Ms"))


install.packages("ggthemes")
library(ggthemes)

grafico_com_labels +
  ggthemes::theme_economist()

grafico_com_labels +
  ggthemes::theme_tufte()

# Temas: exemplo ipeaplot ------------

install.packages("ipeaplot")

# exemplo juntando
dados_sul <- dados |>
  filter(regiao == "Sul")

grafico_customizado <- dados_sul |>
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao, color = uf) +
  geom_line() +
  ipeaplot::theme_ipea() +
  ipeaplot::scale_color_ipea(palette = "Viridis") +
  scale_x_date(breaks = "1 year", date_labels = "%Y") +
  labs(
    title = "Taxa de desocupação por estado na região Sul",
    subtitle = "Dados da PNAD Contínua Trimestral",
    caption = "Fonte dos dados: SIDRA/IBGE.",
    color = "Estado",
    x = "Ano",
    y = "Taxa de desocupação (%)"
  )

grafico_customizado

# Salvando o gráfico ---------------
# dir.create("graficos")

ggsave(filename = "graficos/exemplo_grafico.png", plot = grafico_customizado)

# Dimensão
# Formato/extensão

ggsave(
  filename = "graficos/exemplo_grafico.jpg",
  plot = grafico_customizado
)

# SVG é um exemplo de arquivo editável
ggsave(
  filename = "graficos/exemplo_grafico.svg",
  plot = grafico_customizado
)


# É possível personalizar os tamanhos da imagem
ggsave(
  filename = "graficos/exemplo_grafico.png",
  plot = grafico_customizado,
  width = 30,
  height = 15,
  units = "cm"
)

# Cuidado com o DPI: valores baixos fazem com que a imagem
# fique com baixa qualidade
ggsave(
  filename = "graficos/exemplo_grafico_dpi100.png",
  plot = grafico_customizado,
  dpi = 100
)

ggsave(
  filename = "graficos/exemplo_grafico_dpi900.png",
  plot = grafico_customizado,
  dpi = 900
)
