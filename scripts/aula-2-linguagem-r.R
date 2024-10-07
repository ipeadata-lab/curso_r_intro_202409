# Linguagem R --------------------------
# https://ipeadata-lab.github.io/curso_r_intro_202409/02_conceitos_basicos_r.html
# Para criar objetos, utilizamos a atribuição com o operador <-.

nome_do_curso <- "introdução ao R"

toupper(nome_do_curso)

# Cuidado para não sobrescrever objetos no R ao usar o mesmo nome!
# nome_do_curso <- "IPEA"

# Painel Environment ---------------------
ls() # quais são os objetos atualmente no enviromnet

x <- 1 # criando um objeto de exemplo

rm(x) # removendo o objeto

# Tipos de objetos -----------------------
# Datas -----------------------
class("2024-10-02")

as.Date("2024-10-02")

class(as.Date("2024-10-02"))

# NA -----------------------
numeros_com_na <- c(1, 2, NA, 4, 5)
mean(numeros_com_na, na.rm = TRUE)


# Listas -----------------------
lista_exemplo <- list(numero_pi = pi,
                      df_qualidade_do_ar = airquality,
                      letras = letters)
class(lista_exemplo)

lista_exemplo


qualidade_do_ar <- airquality

# Dúvida: podemos passar uma lista de pacotes para a função install.packages?
# Não! A função install.packages espera um vetor de caracteres, não uma lista.
# isso não vai funcionar
pacotes_necessarios <- list(
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
# Error in install.packages : invalid subscript type 'list'

# Case sensitive -----------------------

# O R é case sensitive, ou seja, diferencia maiúsculas de minúsculas.

MeUnOmE <- "BEATRIZ"
# CASE SENSITIVE 

meunome 
MeUnOme


