# Preparação para a próxima aula!
# Importante instalar o censobr:
install.packages("censobr")

# Carregando o pacote
library(censobr)

# Leitura dos dados de população em 2010, para deixar em cache
populacao_2010 <- read_population(year = 2010)

# caso tenha sido corrompido, usar cache = FALSE
# populacao_2010 <- read_population(year = 2010, cache = FALSE)

nrow(populacao_2010)
# [1] 20635472

ncol(populacao_2010)
# [1] 251
