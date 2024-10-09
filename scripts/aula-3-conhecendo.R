library(tidyverse)

dados <- read_rds("dados/sidrar_4092_bruto.rds")

nrow(dados)

ncol(dados)

names(dados)

glimpse(dados)

summary(dados)

library(skimr)

dados_skim <- skim(dados)


library(naniar)

gg_miss_var(dados)

gg_miss_var(dados, show_pct = TRUE)


# Fazendo recortes na base

dados_com_n_linha <- rowid_to_column(dados)

View(head(dados_com_n_linha, n = 10))

View(tail(dados_com_n_linha, n = 10))

View(slice_sample(dados_com_n_linha, n = 100))

unique(dados$`Condição em relação à força de trabalho e condição de ocupação`)
