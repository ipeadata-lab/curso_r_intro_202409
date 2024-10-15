# Carregando pacotes e dados --------
library(ggplot2)
library(dplyr)

dados <- readr::read_rds("dados_output/sidra_4092_arrumado.rds")

dados_tri_recente <- dados |>  
  filter(trimestre_inicio == max(trimestre_inicio))

# Introdução ao ggplot2 ------- 
dados_tri_recente |> 
  ggplot()

dados_tri_recente |> 
  ggplot() +
  # atribuos estéticos
  aes(x = perc_desocupacao, y = uf)

# dados
dados_tri_recente |> 
  # começa o gráfico
  ggplot() + # usa o + para adicionar novas camadas
  # atribuos estéticos
  aes(x = perc_desocupacao, y = uf) +
  # qual geometria vamos usar?
  geom_col()

# aes() dentro ou fora do geom? ---

dados_tri_recente |> 
  # começa o gráfico
  ggplot() + # usa o + para adicionar novas camadas
  # atribuos estéticos
  # qual geometria vamos usar?
  geom_col(aes(x = perc_desocupacao, y = uf))

# 2 geometrias no mesmo gráfico
dados_tri_recente |> 
  ggplot() +
  aes(x = perc_desocupacao, y = uf) +
  geom_col() +
  geom_point()

dados_tri_recente |> 
  ggplot() +
  geom_col(aes(x = perc_desocupacao, y = uf)) +
  geom_point(aes(x = perc_desocupacao, y = uf))

dados_tri_recente |> 
  ggplot() +
  aes(x = perc_desocupacao, y = uf) +
  geom_col() +
  geom_point(aes(color = regiao))


dados_tri_recente |> 
  ggplot(aes(x = perc_desocupacao, y = uf)) +
  geom_col() +
  geom_point(aes(color = regiao))

# dúvida: como preencher com a cor?
dados_tri_recente |> 
  ggplot(aes(x = perc_desocupacao, y = uf)) +
  geom_col(aes(fill = regiao))

dados_tri_recente |> 
  ggplot(aes(x = perc_desocupacao, y = uf)) +
  geom_col(fill = "lightblue")

# dentro do aes() - colunas da base
# fora do aes() - igual para o gráfico todo, não
# é relacionado com as colunas

# Dúvida Liliane, O lightblue ficou vermelho!!
dados_tri_recente |>
  ggplot(aes(x = perc_desocupacao, y = uf)) +
  geom_col(aes(fill = "lightblue"))

# precisa colocar fora do aes()
dados_tri_recente |>
  ggplot(aes(x = perc_desocupacao, y = uf)) +
  geom_col(fill = "lightblue")

# gráfico de dispersão --------
dados |> 
  filter(uf_sigla == "BA") |> 
  ggplot() +
  geom_point(aes(x = trimestre_inicio, y = perc_desocupacao))

# gráfico de linha ---
dados |> 
  filter(uf_sigla == "BA") |> 
  ggplot() +
  geom_line(aes(x = trimestre_inicio, y = perc_desocupacao))

# ordem das geometrias importa -----
dados |> 
  filter(uf_sigla == "BA") |> 
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao) +
  geom_line(color = "blue") +
  geom_point(color = "red")

dados |> 
  filter(uf_sigla == "BA") |> 
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao) +
  geom_point(color = "red") +
  geom_line(color = "blue") 


dados |> 
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao) +
  geom_line(aes(group = uf)) 

# geometria de barras/colunas ------

geom_bar() # x, calcula o numero de linhas por grupo
geom_col() # x e y,

# geom_col
dados_tri_recente |> 
  ggplot() +
  aes(y = uf, x = perc_desocupacao) +
  geom_col()

# geom_bar - é util para contagens
dados |> 
  filter(perc_desocupacao >= 20) |>
  ggplot() + 
  aes(x = uf) + 
  geom_bar()

dados |> 
  filter(perc_desocupacao >= 20) |>
  count(uf, name = "n_linhas") |> 
  ggplot() + 
  aes(x = uf, y  = n_linhas) + 
  geom_col()

# exemplo do rafael
tab_contagem <- dados |> 
  filter(perc_desocupacao >= 20) |>
  count(uf) 

tab_contagem |> 
  ggplot() + 
  aes(x = uf, y  = n) + 
  geom_col()

# invertendo os eixos: sugestão do Rafael

dados_tri_recente |> 
  ggplot() +
  aes(x = uf, y = perc_desocupacao) +
  geom_col() +
  coord_flip()

# histograma e densidade ------------

dados |> 
  ggplot() +
  aes(x = perc_desocupacao) +
  geom_histogram() # valores absolutos

# `stat_bin()` using `bins = 30`. Pick better value with
# `binwidth`.

dados |> 
  ggplot() +
  aes(x = perc_desocupacao) +
  geom_histogram(binwidth = 1) # 1 é a largura da barra

dados |> 
  ggplot() +
  aes(x = perc_desocupacao) +
  geom_histogram(bins = 20) # 

dados |> 
  ggplot() +
  aes(x = perc_desocupacao) +
  geom_density()  # valores relativos

dados |> 
  ggplot() +
  aes(x = perc_desocupacao) +
  geom_density(aes(fill = regiao),
               #alpha = 0.5, # TRANSPARENCIA
               show.legend = FALSE) +
  facet_wrap(~regiao)

# Boxplot ---------------------------
dados |> 
  ggplot() +
  aes(x = regiao, y = perc_desocupacao) +
  geom_boxplot()

# exercicio
dados |> 
  ggplot() +
  aes(x = regiao, y = perc_desocupacao) +
  geom_boxplot(color = "green")

dados |> 
  ggplot() +
  aes(x = regiao, y = perc_desocupacao) +
  geom_boxplot(fill = "green")


dados |> 
  ggplot() +
  aes(x = regiao, y = perc_desocupacao) +
  geom_boxplot(aes(fill = regiao))



dados |> 
  ggplot() +
  aes(x = regiao, y = perc_desocupacao) +
  geom_boxplot(aes(fill = regiao), show.legend = FALSE)

# ?geom_boxplot
# The upper whisker extends from the hinge to the largest value no further 
# than 1.5 * IQR from the hinge (where IQR is the 
# inter-quartile range, or distance between the first
# and third quartiles). The lower whisker extends from 
# the hinge to the smallest value at most 1.5 * IQR of
# the hinge. Data beyond the end of the whiskers are 
# called "outlying" points and are plotted individually.

# facet ---------------


dados |> 
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line(aes(group = uf)) + 
  facet_wrap(~regiao, nrow = 1)

# cuidado para nao colocar muitas categorias
dados |> 
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line(aes(group = uf)) + 
  facet_wrap(~uf)

dados |> 
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line(aes(group = uf)) + 
  # 1 variável
  facet_wrap(~regiao, 
             # scales = "free_y",
             nrow = 1)




dados |> 
  ggplot() + 
  aes(y = perc_desocupacao) + 
  geom_boxplot() + 
  facet_grid(regiao ~ periodo_pandemia)


dados |> 
  ggplot() +
  aes(y = uf, x = perc_desocupacao) + 
  geom_boxplot() +
  facet_grid(regiao~periodo_pandemia,
              scales = "free_y"
             )

# Dica do Pedro: pedir ajuda ao Chat GPT ao usar o ggplot2
# Dica da Bea: escreva no prompt que está fazendo um gráfico com R e o 
# pacote ggplot2.
# adicionar o resultado do glimpse() também é uma boa ideia,
# assim as sugestões oferecidas usarão as colunas existentes

glimpse(dados)

# > glimpse(dados)
# Rows: 1,350
# Columns: 16
# $ uf                                       <chr> "Rondônia", "Rondônia", "Rondôn…
# $ uf_codigo                                <fct> 11, 11, 11, 11, 11, 11, 11, 11,…
# $ uf_sigla                                 <chr> "RO", "RO", "RO", "RO", "RO", "…
# $ regiao                                   <chr> "Norte", "Norte", "Norte", "Nor…
# $ trimestre                                <chr> "1º trimestre 2012", "2º trimes…
# $ trimestre_codigo                         <chr> "201201", "201202", "201203", "…
# $ ano                                      <dbl> 2012, 2012, 2012, 2012, 2013, 2…
# $ trimestre_inicio                         <date> 2012-01-01, 2012-04-01, 2012-0…
# $ mil_pessoas_total                        <dbl> 1210, 1217, 1226, 1219, 1233, 1…
# $ mil_pessoas_forca_de_trabalho            <dbl> 765, 782, 784, 805, 796, 800, 7…
# $ mil_pessoas_forca_de_trabalho_ocupada    <dbl> 703, 733, 738, 762, 746, 761, 7…
# $ mil_pessoas_forca_de_trabalho_desocupada <dbl> 62, 49, 46, 42, 49, 39, 36, 39,…
# $ mil_pessoas_fora_da_forca_de_trabalho    <dbl> 446, 434, 441, 415, 437, 443, 4…
# $ prop_desocupacao                         <dbl> 0.08104575, 0.06265985, 0.05867…
# $ perc_desocupacao                         <dbl> 8.104575, 6.265985, 5.867347, 5…
# $ periodo_pandemia                         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

# Comentário: cuidado com a interpolação

# O gráfico a seguir pode passar uma ideia errada:
dados |> 
  filter(uf_sigla == "BA") |>
  mutate(periodo_pandemia = as.character(periodo_pandemia)) |>
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line(aes(color = periodo_pandemia, group = "none"))

# melhor colorir os pontos
dados |> 
  filter(uf_sigla == "BA") |>
  mutate(periodo_pandemia = as.character(periodo_pandemia)) |>
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line() +
  geom_point(aes(color = periodo_pandemia, group = "none"))



