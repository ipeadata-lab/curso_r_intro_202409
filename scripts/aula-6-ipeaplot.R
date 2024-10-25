# Carregando os pacotes necessários
library(ggplot2)
library(dplyr)
library(ipeaplot)

# Importando os dados
dados <- readr::read_rds("dados_output/sidra_4092_arrumado.rds")

# Filtrando dados mais recentes
dados_tri_recente <- dados |>
  filter(trimestre_inicio == max(trimestre_inicio))

# Selecionando colunas relevantes
dados_selecionados <- dados_tri_recente |>
  select(
    regiao,
    uf,
    trimestre,
    mil_pessoas_forca_de_trabalho_ocupada,
    mil_pessoas_forca_de_trabalho_desocupada,
    mil_pessoas_fora_da_forca_de_trabalho,
  )


head(dados_selecionados)

# Transformar no formato longo
dados_longos <- dados_selecionados |>
  tidyr::pivot_longer(
    cols = tidyselect::starts_with("mil_pessoas"),
    names_to = "categoria",
    values_to = "mil_pessoas",
    names_prefix = "mil_pessoas_"
  )

head(dados_longos)

# Preparar os dados para o gráfico
dados_preparados <- dados_longos |>
  group_by(regiao, uf, trimestre) |>
  mutate(
    soma_grupo = sum(mil_pessoas),
    perc = mil_pessoas / soma_grupo * 100
  ) |>
  ungroup()

head(dados_preparados)


# Fazendo um primeiro gráfico
dados_preparados |>
  ggplot(aes(fill = categoria)) +
  aes(y = uf, x = perc) +
  geom_col()

# Transformando os dados para melhorar a visualização
# da legenda
dados_grafico_1 <- dados_preparados |>
  mutate(
    categoria_label = case_match(
      categoria,
      "forca_de_trabalho_ocupada" ~ "Força de trabalho ocupada",
      "forca_de_trabalho_desocupada" ~ "Força de trabalho desocupada",
      "fora_da_forca_de_trabalho" ~ "Fora da força de trabalho"
    )
  )

# Transformando os dados novamente, para fatores
dados_grafico_2 <- dados_grafico_1 |>
  mutate(
    categoria_fct = factor(
      categoria_label,
      levels = c(
        "Fora da força de trabalho",
        "Força de trabalho ocupada",
        "Força de trabalho desocupada"
      )
    ),
    uf_fct = forcats::fct_reorder(uf, perc, min)
  )

# Segunda tentativa do gráfico
dados_grafico_2 |>
  ggplot(aes(fill = categoria_fct)) +
  aes(x = uf_fct, y = perc) +
  geom_col()

# salvando o trimestre de referência em um objeto
# para usar o texto posteriormente
trimestre_referencia <- unique(dados_grafico_2$trimestre)

# Gráfico da proporção, ainda sem o IPEA Plot
grafico_proporcao <- dados_grafico_2 |>
  ggplot(aes(fill = categoria_fct)) +
  aes(x = uf_fct, y = perc) +
  geom_col() +
  scale_fill_manual(values = c("#5b5e62", "gray", "#cc1e00")) +
  labs(
    y = "Proporção (%)",
    x = "Estado",
    title = "Proporção por categoria de ocupação em cada estado",
    subtitle = paste0("Período: ", trimestre_referencia),
    fill = "Categoria",
    caption = "Dados da PNAD Contínua Trimestral - IBGE, obtidos no SIDRA."
  ) +
  theme_minimal() +
  coord_flip()

grafico_proporcao

# IPEA PLOT ---------------
# install.packages("ipeaplot")

# carregar o pacote
library("ipeaplot")

grafico_ipeaplot <- grafico_proporcao +
  # adiciona o tema do ipea
  theme_ipea() +
  # Configura o eixo X para limitar aos valores existentes nos dados
  coord_flip(expand = FALSE) +
  # adiciona a paleta de cores do ipea
  scale_fill_ipea(palette = "Blue")

# Salvando o gráfico ----------
save_eps(grafico_ipeaplot,
  file.name = "graficos/grafico_ipeaplot.eps",
  width = 10,
  height = 8,
  dpi = 300
)

save_pdf(grafico_ipeaplot,
  file.name = "graficos/grafico_ipeaplot.pdf",
  width = 10,
  height = 8,
  dpi = 300
)
