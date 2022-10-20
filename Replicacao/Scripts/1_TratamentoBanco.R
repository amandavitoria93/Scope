#---------------------------------------------------------------------------------------#

######################## O primeiro na linha sucessoria: ################################# 
#### uma revisao de escopo da literatura sobre a vice-presidencia na America Latina #####

## Revista Brasileira de Ciencia Politica (ano)
## Autoria: Amanda Vitoria Lopes (Instituto de Ciencia Politica/UnB)
## Correspondencia: amanda_vilopes@hotmail.com
## Citacao: [inserir citacao]

#---------------------------------------------------------------------------------------#

# > Este script detalha o processo de importacao dos bancos de dados originais,
# > e a juncao desses bancos.
# > Observacao: Nao se esqueca de definir o seu diretorio de trabalho.

## 1. Limpando o diretorio de trabalho e carregando os pacotes necessarios ----

(rm(list = ls()))

if (!require('tidyverse')) install.packages('tidyverse'); library('tidyverse')
if (!require('readxl')) install.packages('readxl'); library('readxl')
if (!require('writexl')) install.packages('writexl'); library('writexl')

## 2. Indique seu diretorio de trabalho ----

setwd("[...]")
# Obs.: apagar quando envia

## 3. Importando os bancos originais ----

scielo <- read_excel ("BancosDados/BancosOriginais/scielo_coleta09.03.2022.xlsx") # Banco Scielo

scopus <- read_excel ("BancosDados/BancosOriginais/scopus_coleta09.03.2022.xlsx") # Banco Scopus

wof <- read_excel ("BancosDados/BancosOriginais/WebOfScience_coleta09.03.2022.xls") # Banco Web Of Science

## 4. Criando um identificador para cada banco ----

scielo <- scielo %>% mutate("base" = "Scielo")

scopus <- scopus %>% mutate("base" = "Scopus")

wof <- wof %>% mutate("base" = "Web Of Science")

## 5. Criando uma identificacao para cada trabalho com autor e ano ----

scielo <- scielo %>% unite(col = "ID", c("autores", "ano"), sep = "_", remove = FALSE)

scopus <- scopus %>% unite(col = "ID", c("Authors", "Year"), sep = "_", remove = FALSE)

wof <- wof %>% unite(col = "ID", c("Authors", "Publication Year"), sep = "_", remove = FALSE)

## 6. Unindo os bancos ----

scopus_wof <- scopus %>% full_join(wof, by = "ID")

scopus_wof_scielo <- scopus_wof %>% full_join(scielo, by = "ID")

## 7. Exportando o banco de dados com todos os trabalhos ----

write_xlsx(scopus_wof_scielo, "BancosDados/BancosIntermediarios/scopus_wof_scielo.xlsx")

