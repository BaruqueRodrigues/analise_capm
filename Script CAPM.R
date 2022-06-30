#Projeto publicação Modern Portifolio Theory
#Consiste em um shiny.io de um painel com os as ações com o menor risco/maior retorno

#Chamando os pacotes
library(quantmod)#dados d mercado financeiro 
library(tidyverse)#manipulação de dados
library(BatchGetSymbols)#dados da b3
library(Quandl)
library(lmtest)
library(tseries)
library(broom)
library(timetk)
options(scipen = 999)#tirar as notações científcas
symb<-GetIbovStocks()$tickers#capturando os ticker das ações listadas na bovespa

symb<-paste0(symb,".SA")#adicionando .SA no final dos ticker para usar no financial yahoo

a<-symb[1:10]#reduzindo o tamanho da lista

dataEnv <- new.env()#criando um ambiente para receber os xts dos ativos

#capturando os dados
getSymbols.yahoo(symb,#vetor com o nome da ação
           periodicity='monthly',#periodicidade do ativo 
           from='2010-01-01',#inicio da serie temporal
           to=Sys.Date(),#fim da série temporal
           env = dataEnv#aplicando o ambiente
)
#manipulando os dados
t<-sapply(dataEnv, Ad)#extraindo o valor ajustado dos assets
t<-sapply(t, monthlyReturn)#extraindo o retorno mensal dos assets
asset_xts <- do.call(merge, t)#colocando todos os ativos no mesmo dataset
colnames(asset_xts)<-symb #renomeando os ativos

rm(list=c("dataEnv", "t", "symb"))#limpanodo a staging area

# pegando a taxa selic mensal
Quandl.api_key('TC1ow5j6G7s4SFHTzgDz') # set your API key = Comando necessário pra acessar o Quandl
selic <- Quandl("BCB/4390",type = 'xts') # importando a serie do selic do Bacen

#capturando dados do bovespa
getSymbols("^BVSP",
           periodicity='monthly', 
           from='2010-01-01',
           to=Sys.Date()
)
BVSP<-BVSP%>%Ad()%>%monthlyReturn()

# juntando os dados, ibov e selic
dados <- merge(BVSP,as.xts(selic/100),join="inner")
colnames(dados)<-c("ibovespa","selic")

#modelo colocando os dados no mesmo tamanho
asset_xts2<-asset_xts[-18,]
#fazendo um modelo simples
lm(I(ABEV3.SA-dados$selic)~I(dados$ibovespa-dados$selic),
   data= asset_xts%>%filter)%>%summary()
#preparando os dados em um formato long pra fazer multiplas regressões
asset_long<-asset_xts%>%
  tk_tbl(preserve_index = TRUE, rename_index = "data") %>%
  gather(ativo, retorno, -data)
#rodando os modelos de uma forma tidy
b_ativo<-asset_long%>%nest(-ativo)%>%
  mutate(model=map(data, ~lm(I(retorno-dados$selic)~I(dados$ibovespa-dados$selic), data = .)))%>%
  mutate(model = map(model, tidy))%>%
  unnest(model)

#visualização do efeito do aumento de uma unidade de Ibovespa em cima do ativo listado na b3
b_ativo%>%select(ativo,term,estimate,p.value)%>%filter(term=="I(dados$ibovespa - dados$selic)")
b_ativo<-b_ativo%>%mutate(p.value_rec=case_when(
  p.value<=0.05~"signicativo",
  p.value>=0.05~"não signifativo"
))
b_ativo%>%group_by(term)%>%count(p.value_rec)


#modelos já com os testes de autocorrelação e homocedasticidade
b_test <- asset_long %>% nest(-ativo) %>%
  mutate(model = map(data, ~ lm(
    I(retorno - dados$selic) ~ I(dados$ibovespa - dados$selic), data = .
  ))) %>%
  mutate(bptest = map(model, bptest)) %>% #teste de homocedasticidade
  mutate(bptest = map(bptest, tidy)) %>% unnest(bptest) %>% select(-statistic,-parameter,-method) %>%
  rename(bptest_p.value = p.value) %>%
  mutate(bgtest = map(model, bgtest)) %>% #teste de autocorrelação
  mutate(bgtest = map(bgtest, tidy)) %>% unnest(bgtest) %>% select(-statistic,-parameter,-method) %>%
  rename(bgtest_p.value = p.value) %>%
  mutate(model = map(model, tidy)) %>% unnest(model) %>%
  mutate(p.value_rec = case_when(p.value <= 0.05 ~ "signicativo",
                                 p.value >= 0.05 ~ "não signifativo")) %>%
  mutate(
    bp_p.value_rec = case_when(
      bptest_p.value <= 0.05 ~ "signicativo",
      bptest_p.value >= 0.05 ~ "não signifativo"
    )
  ) %>%
  mutate(
    bg_p.value_rec = case_when(
      bgtest_p.value <= 0.05 ~ "signicativo",
      bgtest_p.value >= 0.05 ~ "não signifativo"
    )
  )

a %>% map(model, bptest)
#Load data
write_rds(asset_long, "asset_long.rds")
write_rds(b_test, "b_testado.rds")
