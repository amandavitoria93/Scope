#---------------------------------------------------------------------------------------#

######################## O primeiro na linha sucessoria: ################################# 
#### uma revisao de escopo da literatura sobre a vice-presidencia na America Latina #####

## Revista Brasileira de Ciencia Politica (ano)
## Autoria: Amanda Vitoria Lopes (Instituto de Ciencia Politica/UnB)
## Correspondencia: amanda_vilopes@hotmail.com
## Citacao: [inserir citacao]

#---------------------------------------------------------------------------------------#

# > Este script detalha o processo de limpeza do banco de dados intermediários já categorizados.
# > Observacao: Nao se esqueca de definir o seu diretorio de trabalho.

## 1. Limpando o diretorio de trabalho e carregando os pacotes necessarios ----

(rm(list = ls()))

if (!require('tidyverse')) install.packages('tidyverse'); library('tidyverse')
if (!require('readxl')) install.packages('readxl'); library('readxl')
if (!require('writexl')) install.packages('writexl'); library('writexl')

## 2. Indique seu diretorio de trabalho ----

setwd("[...]")

## 3. Importando o banco com as categorias  ----

banco_categorizado <- read_excel ("BancosDados/BancosIntermediarios/banco_categorizado.xlsx")

## 4. Eliminando os registros indesejadas ----

#> Para acompanhar o diagrama de fluxo de exclusao, a triagem foi feita
#> #> passo-a-passo

#### 4.1 Registros duplicados ----

#> Contagem dos registros duplicados

banco_categorizado %>% group_by(repetido) %>%
  summarize(contagem = n()) # N = 95

#> Exclusao dos registros duplicados

sem_duplicados <- banco_categorizado %>% filter(repetido != "Sim") # Restam = 985

#### 4.2 Registros que nao se enquadram no tipo de publicacao (Artigo Cientifico) ----

#> Contagem dos registros que se enquadram no tipo de publicacao

sem_duplicados %>% filter (categoria == "NOTPAPER") %>%
  group_by(categoria) %>%
  summarize(contagem = n()) # N = 18

#> Exclusao dos registros que se enquadram no tipo de publicacao

sem_artcientifico <- sem_duplicados %>% filter(categoria != "NOTPAPER") # Restam = 967

#### 4.3 Registros sem acesso ----

#> Contagem dos registros sem acesso

sem_artcientifico %>% filter (categoria == "s/acesso") %>%
  group_by(categoria) %>%
  summarize(contagem = n()) # N = 11

#> Exclusao dos registros sem acesso

sem_acesso <- sem_artcientifico %>% filter(categoria != "s/acesso") # Restam = 956

#### 4.4 Registros que nao sao sobre vice-presidencia de Estado ----

#> Contagem dos registros

sem_acesso %>% filter (categoria == "X99") %>%
  group_by(categoria) %>%
  summarize(contagem = n()) # N = 559

#> Exclusao dos registros

sem_naoVP <- sem_acesso %>% filter(categoria != "X99") # Restam = 397

#### 4.5 Registros que nao tem a vice-presidencia como objeto de pesquisa ----

#> Contagem dos registros

sem_naoVP %>% filter (categoria == "Y88") %>%
  group_by(categoria) %>%
  summarize(contagem = n()) # N = 174

#> Exclusao dos registros

elegibilidade <- sem_naoVP %>% filter(categoria != "Y88") # Restam = 223

## 5. Filtrando os estudos incluidoss ----

#> Contando os estudos por categoria

elegibilidade %>% group_by(categoria) %>%
  summarize(contagem = n())

#> Filtrando os estudos de vice-presidencia na America Latina

RevEscopo_VPAL <- elegibilidade %>% filter(categoria == "AL")

#> Exportando o banco final para analise

write_xlsx(RevEscopo_VPAL, "BancosDados/BancosAnalise/RevEscopo_VPAL.xlsx")