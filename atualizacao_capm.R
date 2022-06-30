# Atualização da Análise CAPM

# packages ----------------------------------------------------------------
library(dplyr)
library(purrr)
library(tidyr)
library(broom)
library(ggplot2)

#data de inicio da analise
first_date <- "2020-01-01"
last_date = Sys.Date()

# Get the data ------------------------------------------------------------

#passar o .SA para o vetor pra importar os dados do yahoo
symb <- paste0(b3_acoes$Código, ".SA")

#pegando os dados da b3
b3 <- yfR::yf_get(tickers =symb, 
             first_date = first_date,
             last_date = last_date)%>%
  select(ticker, ref_date,ret_adjusted_prices)

#checando o dataset
glimpse(b3)

# pegando a taxa selic mensal
Quandl::Quandl.api_key('TC1ow5j6G7s4SFHTzgDz') # set your API key = Comando necessário pra acessar o Quandl
selic <- Quandl::Quandl("BCB/4390", type = 'xts') %>%  # importando a serie do selic do Bacen
         ggplot2::fortify() %>% 
         tibble() %>% 
         transmute(date = lubridate::as_date(Index),
                   selic = ./100) %>% 
         filter(date >= first_date)

#transformando os valores da selic para valores diários
selic <- data.frame(date = seq(lubridate::ymd(first_date),
                               lubridate::ymd(last_date),
                               by = 1)) %>%
  mutate(dia_selic = lubridate::make_date(
    year = lubridate::year(date),
    month = lubridate::month(date),
    day = 1
  )) %>%
  left_join(selic,
            by = c("dia_selic" = "date")) %>%
  select(-dia_selic) %>% 
  tibble() 
  
#pega os valores do BVSP
bovespa <- yfR::yf_get(tickers ="^BVSP", 
                      first_date = first_date,
                      last_date = last_date) %>%
           select(ticker, ref_date, ret_adjusted_prices)

#dataset com os valores do bovesp e da selic
risco <- left_join(bovespa, selic, by = c("ref_date" = "date")) %>%
         select(ticker, ref_date, bvsp=ret_adjusted_prices, selic)
         
#Checando o percentual de valores  
tickers_out <- b3 %>%
  janitor::tabyl(ticker) %>%
  arrange(percent) %>%
  slice(1:7) %>%
  pull(ticker)
# Analise -----------------------------------------------------------------

# Aqui construímos um modelo em que calculamos a y = b1+b2
# beta 1 é o ativo - a taxa livre de risco
# beta 2 é mercado - a taxa livre de risco

#Tabela com os coeficientes de todos os modelos

retorno_ativos <- b3 %>%
  #filter(!ticker %in% tickers_out) %>% 
  tidyr::nest(-ticker) %>% 
  mutate(
    modelo = map(
      data, ~lm(I(ret_adjusted_prices - risco$selic)~ I(risco$bvsp - risco$selic),
                data = .)
    )
  ) %>%
  mutate(modelo = map(modelo, tidy))%>%
  tidyr::unnest(modelo)

readr::write_rds(retorno_ativos, "retorno_ativos.rds")

# Tabela visualizando o Beta Retorno de Cada um dos Ativos
retorno_ativos %>% 
  select(Ativo = ticker, termo=term,
         "Retorno Esperado" = estimate,
         "p valor" =p.value) %>% 
  filter(termo == "I(risco$bvsp - risco$selic)") %>% 
  select(Ativo, "Retorno Esperado") %>% 
  arrange(`Retorno Esperado`) %>% 
  gt::gt() %>%
  gt::tab_header("Retorno Esperado dos Ativos da B3") %>% 
  gt::fmt_number(columns = "Retorno Esperado", decimals = 2)

theme_set(theme_minimal())

n_ativos <- retorno_ativos %>% 
  filter(term == "I(risco$bvsp - risco$selic)") %>% 
  pull(ticker)


# Histograma com a visualização do risco retorno dos ativos listados na B3 
# Areas em cinza por desvio padrão
retorno_ativos %>% 
  filter(term == "I(risco$bvsp - risco$selic)") %>% 
  ggplot(aes( x= estimate))+
  geom_rect(aes(xmin = mean(estimate) +1*sd(estimate), ymin = 0,
                xmax = mean(estimate) -1*sd(estimate), ymax = Inf),
            fill = "lightgrey")+
  geom_rect(aes(xmin = mean(estimate) +1.96*sd(estimate), ymin = 0,
                xmax = mean(estimate) -1.96*sd(estimate), ymax = Inf),
            fill = "lightgrey", alpha = .03)+
  geom_histogram(fill = "white", color = "black")+
  geom_vline(aes(xintercept = mean(estimate)), linetype = "dashed")+
  ggrepel::geom_text_repel(aes(label=ticker, y = runif(0, 8, n = n_ativos)))+
  labs(y = NULL,
       x = "Risco Retorno",
       title = "Risco Retorno dos Ativos Listados na B3",
       caption = "@baruqrodrigues")+
  theme(plot.title = element_text(hjust = .5, size = 15),
        plot.caption = element_text(hjust = 0.05),
        panel.grid = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size = 12)
        )
  

