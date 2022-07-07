#Inflação por Ministro da Fazenda


# packages ----------------------------------------------------------------
library(tidyverse)
library(lubridate)

# Get the data ------------------------------------------------------------
url <- "https://www.gov.br/fazenda/pt-br/acesso-a-informacao/institucional/galeria-de-ministros/pasta-republica/republica"

min_fazenda_vec <- url %>%
  rvest::read_html() %>%
  rvest::html_nodes("th") %>%
  rvest::html_text()

#selic anual
selic_anual<- readr::read_csv2("http://api.bcb.gov.br/dados/serie/bcdata.sgs.1178/dados?formato=csv") %>%
  mutate(data = lubridate::dmy(data),
         selic_mes = format(data, "%Y-%m"))

# wrangling data ----------------------------------------------------------

df <- tibble(min_fazenda = str_squish(min_fazenda_vec),
             mandato = "") %>%
  mutate(min_fazenda = case_when(min_fazenda == "" ~ NA_character_,
                                 TRUE ~ min_fazenda)) %>%
  drop_na(min_fazenda) %>%
  mutate(mandato = str_match(min_fazenda, "\\d{2}.\\d{2}.\\d{4} a \\d{2}.\\d{2}.\\d{4}")) %>%
  separate(mandato,
           into = c("inicio_mandato", "fim_mandato"),
           sep = " a ")  %>% 
  mutate(
    across(inicio_mandato:fim_mandato,
           ~str_replace_all(string = .,
                                  pattern = "\\.",
                                  replacement = "-")),
    across(inicio_mandato:fim_mandato,
           ~lubridate::dmy(.)),
    min_fazenda = str_remove_all(min_fazenda, "\\d{2}.\\d{2}.\\d{4} a \\d{2}.\\d{2}.\\d{4}")
    )

#adicionar o Paulo Guedes
df <- df %>% add_row(min_fazenda = "Paulo Guedes", 
                   inicio_mandato = as_date("2019-01-01"),
                   fim_mandato = as_date("2022-07-07")) %>% 
  mutate(mes_inicio_mandato = format(inicio_mandato,"%Y-%m"),
              mes_fim_mandato =    format(fim_mandato, "%Y-%m"))

#Enriquecendo os dados

df_enriquecido<-df %>% 
  left_join(selic_anual,
            by = c("mes_inicio_mandato" = "selic_mes")) %>% 
  rename(valor_inicio_mandato = valor) %>% 
  select(-mes_inicio_mandato) %>% unique() %>%  
  left_join(selic_anual,
               by = c("mes_fim_mandato" = "selic_mes")) %>% 
  unique() %>% 
  rename(valor_fim_mandato = valor) %>% 
  select(-mes_fim_mandato, -data.x, -data.y) %>% 
  unique()



  

# Dados do bc -------------------------------------------------------------

  
url_bc <- "https://pt.wikipedia.org/wiki/Lista_de_presidentes_do_Banco_Central_do_Brasil"

pres_bc <- url_bc %>% 
  rvest::read_html() %>% 
  rvest::html_table() %>% 
  pluck(3) %>% 
  janitor::clean_names() %>% 
  select(nome, inicio_do_mandato, fim_do_mandato) %>% 
  mutate(inicio_do_mandato = dmy(inicio_do_mandato),
         fim_do_mandato = dmy(fim_do_mandato))
pres_bc[22,3] <- ymd("2022-07-07")
 
pres_bc_enri <- pres_bc %>% 
  mutate(mes_inicio_mandato = format(inicio_do_mandato, "%Y-%m"),
         mes_fim_mandato = format(fim_do_mandato, "%Y-%m")) %>% 
  left_join(selic_anual,
            by = c("mes_inicio_mandato" = "selic_mes")) %>% unique()%>% 
  rename(valor_inicio_mandato = valor) %>% 
  select(-mes_inicio_mandato) %>% unique() %>%  
  left_join(selic_anual,
            by = c("mes_fim_mandato" = "selic_mes")) %>% 
  unique() %>% 
  rename(valor_fim_mandato = valor) %>% 
  select(-mes_fim_mandato, -data.x, -data.y)

# Visualização
df_enriquecido %>%
  filter(inicio_mandato >= "1994-07-01") %>% 
  ggplot(aes(x = valor_inicio_mandato, xend = valor_fim_mandato,
             y=reorder(min_fazenda, -year(inicio_mandato) ))) +
  ggalt::geom_dumbbell(color = "#a3c4dc",
                       colour_xend = "#0e668b",
                       size = 4.0,
                       dot_guide = TRUE,
                       dot_guide_size = 0.15,
                       dot_guide_colour = "grey60")+
  theme_minimal()+
  labs(x="Variação da Taxa Selic",
       y= NULL,
       title = "Variação da Taxa Selic por Ministro da Fazenda Pós Plano Real (1994-2022)",
       caption = "@baruqrodrigues")+
  theme(plot.title = element_text(hjust = .5),
        plot.caption = element_text(hjust = .01),
        axis.text = element_text(size = 12))+
  scale_x_continuous(breaks = seq(0, 60, 5))

pres_bc_enri %>% 
  filter(inicio_do_mandato >= "1994-07-01") %>% 
  ggplot(aes(x = valor_inicio_mandato, xend = valor_fim_mandato,
             y=reorder(nome, -year(inicio_do_mandato) ))) +
  ggalt::geom_dumbbell(color = "#a3c4dc",
                       colour_xend = "#0e668b",
                       size = 4.0,
                       dot_guide = TRUE,
                       dot_guide_size = 0.15,
                       dot_guide_colour = "grey60")+
  theme_minimal()+
  labs(x="Variação da Taxa Selic",
       y= NULL,
       title = "Variação da Taxa Selic por Presidente do Banco Central Pós Plano Real (1994-2022)",
       caption = "@baruqrodrigues")+
  theme(plot.title = element_text(hjust = .5),
        plot.caption = element_text(hjust = .01),
        axis.text = element_text(size = 12))+
  scale_x_continuous(breaks = seq(0, 60, 5))


