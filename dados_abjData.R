install.packages("abjData")


uf_regiao <- abjData::muni |> 
  dplyr::distinct(uf_nm, uf_sigla, uf_id, regiao_nm) |> 
  dplyr::rename(
    uf = uf_nm,
    uf_codigo = uf_id,
    regiao = regiao_nm
  )


readr::write_csv(uf_regiao, "dados/uf_regiao.csv")
