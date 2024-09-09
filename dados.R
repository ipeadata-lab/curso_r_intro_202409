library(sidrar)

# Sugestão de dados feita pelo Rafael: ------
# Dados trimestrais da PNADc: 
# "Pessoas de 14 anos ou mais de idade,
# por condição em relação à força de trabalho e condição de ocupação"
# Codigo: 4092

# Com o codigo abaixo, a baixa essa tabela que traz pop ocupada e desocupada 
# para cada UF em diferentes trimentes.
# Acho que um dos objetivos do exercicio poderia ser por exemplo calcular a 
# taxa de desocupação de cada estado e cada região ao longo do tempo. 
# Voces vao ver que a tabela é bem 'untidy', entao dá bastante pano pra manga.

dados <- sidrar::get_sidra(x = 4092, 
                        period = c("201402", "201702", "202002", "202302"),
                        geo = "State",
                        format  = 4
                        )
head(dados)