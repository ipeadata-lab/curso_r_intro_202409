# Instalar pacotes
pacotes <- c("abjData", "broom", "car", "fixest", "report")
install.packages(pacotes)

# Carregar pacotes
library(ggplot2)
# Impedir notação científica
options(scipen = 999) 

# Importando dados, filtrando para 2010
pnud_muni_2010 <- abjData::pnud_muni |> 
  dplyr::filter(ano == 2010)

# Dicionario
nomes_col_pnud_muni_2010 <- abjData::pnud_siglas |> 
  dplyr::filter(sigla %in% names(pnud_muni_2010))

nomes_col_pnud_muni_2010 |> 
  DT::datatable()

# Regressão linear -----------------------------
modelo_linear <- lm(mort5 ~ t_agua, data = pnud_muni_2010)
modelo_linear

summary(modelo_linear)

broom::tidy(modelo_linear)

broom::glance(modelo_linear)

report::report(modelo_linear) 


## Visualizando o ajuste ----------
pnud_muni_2010_adjusted <- pnud_muni_2010 |>
  dplyr::mutate(
    valores_ajustados = predict(modelo_linear),
    residuos = mort5 - valores_ajustados
  ) 


pnud_muni_2010_adjusted |> 
  ggplot() + 
  aes(x = t_agua, y = mort5) + 
  geom_point(alpha = 0.5) + 
  geom_line(aes(y = valores_ajustados),
            color = "blue", linewidth = 1) +
  theme_light()

# geom_smooth  - NÃO USA O MODELO QUE AJUSTAMOS
pnud_muni_2010 |> 
  ggplot() + 
  aes(x = t_agua, y = mort5) + 
  geom_point(alpha = 0.5) + 
  geom_smooth(method = "lm", se = FALSE, color = "blue") + 
  theme_light()

## Diagnóstico -----

pnud_muni_2010_adjusted |>
  ggplot(aes(x = residuos)) +
  geom_histogram(
    aes(y = after_stat(density)),
    fill = "lightblue"
  ) +
  geom_density() +
  theme_light()


car::residualPlot(modelo_linear)
car::ncvTest(modelo_linear)
car::qqPlot(modelo_linear)


pnud_muni_2010_adjusted$residuos
?shapiro.test()

## Tabelas -----
# install.packages("stargazer")

stargazer::stargazer(modelo_linear, type = "html")

stargazer::stargazer(modelo_linear, type = "html",
                     out = "scripts/stargazer_output.html") 


# Regressão Linear múltipla ---------------

modelo_linear_multiplo <- lm(mort5 ~ t_agua + rdpc, data = pnud_muni_2010)
modelo_linear_multiplo


summary(modelo_linear_multiplo)


## Visualizando o ajuste -----

pnud_muni_2010_ajustado_agua <- pnud_muni_2010 |> 
  dplyr::mutate(
    rdpc = mean(rdpc)
  )

pnud_muni_2010_ajustado_rdpc <- pnud_muni_2010 |>
  dplyr::mutate(
    t_agua = mean(t_agua)
  )


pnud_muni_2010_ajustado_multiplo <- pnud_muni_2010 |>
  dplyr::mutate(
    valores_ajustados_agua = predict(
      modelo_linear_multiplo, 
      newdata = pnud_muni_2010_ajustado_agua
      ),
    
    valores_ajustados_rdpc = predict(
      modelo_linear_multiplo, 
      newdata = pnud_muni_2010_ajustado_rdpc
      )
  ) 


pnud_muni_2010_ajustado_multiplo |> 
  ggplot() +
  geom_point(aes(x = t_agua, y = mort5), alpha = 0.5) +
  geom_line(aes(x = t_agua, y = valores_ajustados_agua),
            color = "red") +
  theme_light()

pnud_muni_2010_ajustado_multiplo |> 
  ggplot() +
  geom_point(aes(x = rdpc, y = mort5), alpha = 0.5) +
  geom_line(aes(x = rdpc, y = valores_ajustados_rdpc), color = "red") +
  theme_light() 

## Vamos tentar novamente, com log na variável rdpc -------
pnud_muni_2010_com_log <- pnud_muni_2010 |> 
  dplyr::mutate(rdpc_log = log(rdpc)) 


modelo_linear_multiplo_log <- lm(mort5 ~ t_agua + rdpc_log,
                                 data = pnud_muni_2010_com_log)

## Visualizando o ajuste -------
pnud_muni_2010_ajustado_agua_log <- pnud_muni_2010_com_log |> 
  dplyr::mutate(
    rdpc_log = mean(rdpc_log),
  )

pnud_muni_2010_ajustado_rdpc_log  <- pnud_muni_2010_com_log |>
  dplyr::mutate(
    t_agua = mean(t_agua)
  )

pnud_muni_2010_ajustado_multiplo_log <- pnud_muni_2010_com_log |>
  dplyr::mutate(
    valores_ajustados_agua = predict(
      modelo_linear_multiplo_log,
      newdata = pnud_muni_2010_ajustado_agua_log),
    
    valores_ajustados_rdpc = predict(
      modelo_linear_multiplo_log,
      newdata = pnud_muni_2010_ajustado_rdpc_log),
    
    valores_ajustados = predict(modelo_linear_multiplo_log),
    
    residuos = mort5 - valores_ajustados
  ) 


pnud_muni_2010_ajustado_multiplo_log |> 
  ggplot() +
  geom_point(aes(x = t_agua, y = mort5), alpha = 0.5) +
  geom_line(aes(x = t_agua, y = valores_ajustados_agua), color = "red") +
  theme_light() 

pnud_muni_2010_ajustado_multiplo_log |> 
  ggplot() +
  geom_point(aes(x = rdpc_log, y = mort5), alpha = 0.5) +
  geom_line(aes(x = rdpc_log, y = valores_ajustados_rdpc),
            color = "red") +
  theme_light() 

## Tabelas -------

stargazer::stargazer(modelo_linear_multiplo_log,
                     type = "html",
                     out = "tabelas/modelo_linear_multiplo_log.html"
                     )

# podemos passar uma lista de modelos para o stargazer
stargazer::stargazer(list(modelo_linear_multiplo,
                          modelo_linear_multiplo_log),
                     type = "html",
                     out = "tabelas/modelo_linear_multiplo_log-2.html"
                     )
