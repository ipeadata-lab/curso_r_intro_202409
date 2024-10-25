# Materiais:
# https://ipeadata-lab.github.io/curso_r_intro_202409/

# Conhecendo o R e o RStudio: ------------------------------------
# https://ipeadata-lab.github.io/curso_r_intro_202409/01_r_rstudio.html

## Como executar códigos em um script?  ----
# Selecionar e clicar em Run, ou ctrl+enter.
1 + 2
1 + 2

# Dúvida:
# como executar todas as linhas?
# selecionar tudo: ctrl + A
# executar o código: ctrl + enter

## Funções ---
Sys.Date()

# Argumentos
Sys.Date() # não precisa de argumentos

sqrt()
# Error in sqrt() : 0 arguments passed to 'sqrt' which requires 1

sqrt(25)

## Pacotes ------
# Como instalar pacotes?
install.packages("tidyverse")

# Aviso que apareceu para algumas pessoas:
# WARNING: Rtools is required to build R packages but is not currently installed.
# Please download and install the appropriate version of Rtools before proceeding:
#
# https://cran.rstudio.com/bin/windows/Rtools/
# Instalando pacote em ‘C:/Users/R1275378/AppData/Local/R/win-library/4.4’
# (como ‘lib’ não foi especificado)

# Carregando um pacote:
library(tidyverse)

# starwars é uma tabela disponível no pacote dplyr,
# que faz parte do tidyverse
starwars

# podemos falar explicitamente quais funções vamos usar,
# indicando o pacote:
dplyr::glimpse()
dplyr::starwars

## Documentação ---------------
?mean
??mean
browseVignettes("dplyr")

# Instalação de pacotes necessários nas aulas iniciais
pacotes_necessarios <- c(
  "tidyverse",
  "janitor",
  "sidrar",
  "readxl",
  "writexl",
  "fs",
  "naniar",
  "skimr"
)


install.packages(pacotes_necessarios)

# Diretório de trabalho e projetos ---------------------------------
# https://ipeadata-lab.github.io/curso_r_intro_202409/01_1_rproj.html

# podemos consultar nosso diretório de trabalho
getwd()
"/Users/beatrizmilz"

"C:/" # no windows é comum os caminhos começarem assim

"./" # pasta que estamos
"../../" # subir na hierarquia de pastas

"~/" # mac e linux

"" # RStudio ajuda a navegar nas pastas:
# escrever Aspas, adicionar o cursor entre as aspas,
# e clicar em tab

# Criando um projeto para o curso ----------------

# Crie um projeto para o curso.

# As instruções estão disponíveis em:
# https://ipeadata-lab.github.io/curso_r_intro_202409/01_1_rproj.html#criando-um-projeto-para-o-curso

# Os comandos a seguir devem ser executados com
# o projeto aberto.

## Criando as pastas que vamos usar no curso: -----
dir.create("dados")
dir.create("dados_output") # atenção: não use espaços nos nomes das pastas
dir.create("scripts")
dir.create("graficos") # atenção: não use acentos ou caracteres especiais nos nomes das pastas

# Dúvida: Como criar uma pasta dentro de outra pasta?
# dir.create("dados/sidra/")
# dir.create("dados/geobr/")
# dir.create("dados/pnad/")

## Download dos arquivos -----------------------------------
download.file(
  url = "https://github.com/ipeadata-lab/curso_r_intro_202409/raw/refs/heads/main/dados/sidrar_4092_bruto_2.csv",
  destfile = "dados/sidrar_4092_bruto_2.csv"
)

download.file(
  url = "https://github.com/ipeadata-lab/curso_r_intro_202409/raw/refs/heads/main/dados/sidrar_4092_bruto.csv",
  destfile = "dados/sidrar_4092_bruto.csv"
)

download.file(
  url = "https://github.com/ipeadata-lab/curso_r_intro_202409/raw/refs/heads/main/dados/sidrar_4092_bruto.xlsx",
  destfile = "dados/sidrar_4092_bruto.xlsx"
)

download.file(
  url = "https://github.com/ipeadata-lab/curso_r_intro_202409/raw/refs/heads/main/dados/sidrar_4092_bruto.rds",
  destfile = "dados/sidrar_4092_bruto.rds"
)
