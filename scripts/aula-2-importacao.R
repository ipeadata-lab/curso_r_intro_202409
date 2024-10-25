# Carregando o pacote necessário
library(tidyverse)

# Importar -------------------
## Importando um csv -----
dados_csv <- read_csv("dados/sidrar_4092_bruto.csv")

# Dúvida: Como saber se foi importado?
# veja se o objeto aparece no environment!
# ou tente usar ele
View(dados_csv) # Cuidado com bases grandes

# View(dados_csv2)
# Error in View : object 'dados_csv2' not found

# Podemos interagir com o objeto
head(dados_csv)
glimpse(dados_csv)

class(dados_csv)

## Importando um csv separado por ; -------------------
dados_csv_2 <- read_csv2("dados/sidrar_4092_bruto_2.csv")

## Usando o Import Dataset -----

library(readr)
sidrar_4092_bruto_2 <- read_delim("dados/sidrar_4092_bruto_2.csv",
  delim = ";", escape_double = FALSE, trim_ws = TRUE
)
View(sidrar_4092_bruto_2)


## Importando um Excel -----------------------

library(readxl)

# Quais são as abas disponíveis?
excel_sheets("dados/sidrar_4092_bruto.xlsx")

# Erro que aconteceu com algumas pessoas:
# > excel_sheets("dados/sidrar_4092_bruto.xlsx")
# Error in readBin(con, raw(), n = size) :
#   error reading from the connection

# Isso significa que o arquivo está corrompido, precisa baixar novamente.


# Importando a aba 1
dados_excel <- read_xlsx("dados/sidrar_4092_bruto.xlsx") # aba 1

# Importando a aba "Sheet1"
dados_excel <- read_xlsx("dados/sidrar_4092_bruto.xlsx", sheet = "Sheet1")

## Importando um rds ----------------------------
dados_rds <- read_rds("dados/sidrar_4092_bruto.rds")

## Classe dos objetos --------------------------
class(dados_excel)
class(dados_rds)

# podemos converter para tibble com a função as_tibble()
as_tibble(dados_rds)


# Salvar  -------------------------------------------

##  Salvando em csv ---------------------------
write_csv2(dados_rds, "dados_output/sidrar_4092_bruto.csv")


## Salvando em Excel ----
library(writexl)

# Erro: causado por erro de digitação no nome do caminho
write_xlsx(dados_rds, "dados_ouput/sidrar_4092_bruto.xlsx")
# [ERROR] workbook_close(): Error creating 'dados_ouput/sidrar_4092_bruto.xlsx'. System error = No such file or directory
# Error: Error in libxlsxwriter: 'Error creating output xlsx file. Usually a permissions error.'


write_xlsx(dados_rds, "dados_output/sidrar_4092_bruto.xlsx")

## Salvando em rds ---------------------------
write_rds(dados_rds, "dados_output/sidrar_4092_bruto.rds")

write_rds(starwars, "dados_output/starwars.rds")

# Importando de um pacote de dados ------
## Sidra/IBGE -----------------------
library(sidrar)

# Informações sobre a tabela 4092
info_4092 <- info_sidra("4092")
# É uma lista, podemos acessar o conteúdo com $
info_4092$classific_category
info_4092$geo

# Criando um vetor com períodos disponíveis
periodos_disponiveis <- str_split(info_4092$period, ", ")[[1]]
periodos_disponiveis

# Importando a tabela 4092
dados_brutos_4092 <- sidrar::get_sidra(
  x = 4092,
  period = periodos_disponiveis,
  geo = "State"
)
