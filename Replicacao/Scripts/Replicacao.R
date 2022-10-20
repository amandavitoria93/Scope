#---------------------------------------------------------------------------------------#

######################## O primeiro na linha sucessoria: ################################# 
#### uma revisao de escopo da literatura sobre a vice-presidencia na America Latina #####

## Revista Brasileira de Ciencia Politica (ano)
## Autoria: Amanda Vitoria Lopes (Instituto de Ciencia Politica/UnB)
## Correspondencia: amanda_vilopes@hotmail.com

#---------------------------------------------------------------------------------------#

# > Este script detalha o processo de importacao dos bancos de dados originais,
# > a juncao desses bancos e a filtragem para o banco final.
# > Observacao: Nao se esqueca de definir o seu diretorio de trabalho.

## 1. Limpando o diretorio de trabalho e carregando os pacotes necessarios ----

(rm(list = ls()))

if (!require('tidyverse')) install.packages('tidyverse'); library('tidyverse')
if (!require('readxl')) install.packages('readxl'); library('readxl')
if (!require('writexl')) install.packages('writexl'); library('writexl')

## 2. Indique seu diretorio de trabalho ----

setwd("[...]")

## Para acessar os bancos originais e intermediarios, acesse: https://osf.io/qndjh/

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

## 8. Importando o banco com as categorias  ----

banco_categorizado <- read_excel ("BancosDados/BancosIntermediarios/banco_categorizado.xlsx")

## 9. Eliminando os registros indesejadas ----

#> Para acompanhar o diagrama de fluxo de exclusao, a triagem foi feita
#> #> passo-a-passo

#### 9.1 Registros duplicados ----

#> Contagem dos registros duplicados

banco_categorizado %>% group_by(repetido) %>%
  summarize(contagem = n()) # N = 95

#> Exclusao dos registros duplicados

sem_duplicados <- banco_categorizado %>% filter(repetido != "Sim") # Restam = 985

#### 9.2 Registros que nao se enquadram no tipo de publicacao (Artigo Cientifico) ----

#> Contagem dos registros que se enquadram no tipo de publicacao

sem_duplicados %>% filter (categoria == "NOTPAPER") %>%
  group_by(categoria) %>%
  summarize(contagem = n()) # N = 18

#> Exclusao dos registros que se enquadram no tipo de publicacao

sem_artcientifico <- sem_duplicados %>% filter(categoria != "NOTPAPER") # Restam = 967

#### 9.3 Registros sem acesso ----

#> Contagem dos registros sem acesso

sem_artcientifico %>% filter (categoria == "s/acesso") %>%
  group_by(categoria) %>%
  summarize(contagem = n()) # N = 11

#> Exclusao dos registros sem acesso

sem_acesso <- sem_artcientifico %>% filter(categoria != "s/acesso") # Restam = 956

#### 9.4 Registros que nao sao sobre vice-presidencia de Estado ----

#> Contagem dos registros

sem_acesso %>% filter (categoria == "X99") %>%
  group_by(categoria) %>%
  summarize(contagem = n()) # N = 559

#> Exclusao dos registros

sem_naoVP <- sem_acesso %>% filter(categoria != "X99") # Restam = 397

#### 9.5 Registros que nao tem a vice-presidencia como objeto de pesquisa ----

#> Contagem dos registros

sem_naoVP %>% filter (categoria == "Y88") %>%
  group_by(categoria) %>%
  summarize(contagem = n()) # N = 174

#> Exclusao dos registros

elegibilidade <- sem_naoVP %>% filter(categoria != "Y88") # Restam = 223

## 10. Filtrando os estudos incluidoss ----

#> Contando os estudos por categoria

elegibilidade %>% group_by(categoria) %>%
  summarize(contagem = n())

#> Filtrando os estudos de vice-presidencia na America Latina

RevEscopo_VPAL <- elegibilidade %>% filter(categoria == "AL")

#> Exportando o banco final para analise

write_xlsx(RevEscopo_VPAL, "BancosDados/BancosAnalise/RevEscopo_VPAL.xlsx")