# Carregando o pacote dplyr
library(dplyr)

# Carregando os dados --------------------------------------------------------
dados <- readr::read_rds("dados_output/sidra_4092_arrumado.rds")

# Relembrando funções vistas na aula "Conhecendo a base de dados" -------------

# Sumário das variáveis
summary(dados)

# Sumário das variáveis - Com o pacote skimr
dados_skim <- skimr::skim(dados)
dados_skim

# Estatísticas descritivas ---------------------------------------------------
mean(dados$perc_desocupacao)

# Função summarise() ---------------------------------------------------------
dados |> 
  summarise(
    valor_min = min(perc_desocupacao),
    valor_max = max(perc_desocupacao),
    amplitude = valor_max - valor_min,
    media = mean(perc_desocupacao)
  )

# Lembrando que apenas criamos um objeto novo
# ao usar o operador de atribuição: <-


# Função group_by() ----------------------------------------------------------
dados |> 
  group_by(uf)
# # Groups:   uf [27]

dados |> 
  group_by(ano, regiao)
# Groups:   ano, regiao [65]

dados |> 
  group_by(ano, regiao) |> 
  ungroup()
# Nenhum grupo

# Função summarise() com group_by() ------------------------------------------
dados |> 
  group_by(uf) |> 
  summarise(
    valor_min = min(perc_desocupacao),
    valor_max = max(perc_desocupacao),
    amplitude = valor_max - valor_min,
    media = mean(perc_desocupacao)
  ) 

# Sobre o argumento .groups -------------------------------------------------
# Isso gerou bastante dúvida, então vamos explorar um pouco mais
dados_agrupados <- dados |> 
  group_by(regiao, ano) |> 
  summarise(
    valor_min = min(perc_desocupacao),
    valor_max = max(perc_desocupacao),
    amplitude = valor_max - valor_min,
    media = mean(perc_desocupacao), 
      # .groups = "keep"  # manter grupos
    # .groups = "drop" # perder grupos
  ) 

dados_agrupados
# Groups:   regiao [5]

# Exemplo de filtro com dados agrupados:
filter(dados_agrupados, valor_max == max(valor_max))

# Exemplo de filtro com dados desagrupados:
dados_agrupados |> 
  ungroup() |> 
  filter(valor_max == max(valor_max))
