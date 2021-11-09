rm(list=ls())


library(shiny)
library(shinydashboard)
library(fresh)
library(plotly)
library(ggplot2)

setwd("C:/Users/Doctoralia/Documents/TCC")

df_et <- data.table::fread('resultado_et.csv', na.strings = '')
df_rf <- data.table::fread('resultado_rf.csv', na.strings = '')

data <- read.csv("C:/Users/Doctoralia/Documents/TCC/PainelPassageiro.csv") 

data$DATA <- lubridate::dmy(data$DATA)

tema_urbs <- create_theme(
    adminlte_color(
        red = "#fab370",
        light_blue = '#1a1f33'
    ),
    adminlte_sidebar(
        dark_bg = '#1a1f33'
    )
)


#####


ui <- dashboardPage(
        skin = "blue",
    dashboardHeader(
        title = "Previsão de Passageiros - URBS",
        titleWidth = 350,
        dropdownMenu(type = "messages",
                     messageItem(
                         from = "Universidade",
                         message = "FAE Centro Universitário",
                         icon = icon("university")
                     ),
                     messageItem(
                         from = "Curso",
                         message = "Engenharia de Produção",
                         icon = icon("line-chart")
                     ),
                     messageItem(
                         from = "Integrantes",
                         message = "Ana Clara, Caroline e Gabriela",
                         icon = icon("user-circle")
                     ))
    ),
    dashboardSidebar(
        width = 350,
        sidebarMenu(
            menuItem("Projeto", tabName = "projeto", icon = icon("folder")),
            menuItem("Gráficos",tabName = "graficos", icon = icon("line-chart"),
                     badgeLabel = "CONFIRA", badgeColor = "green")),
            menuItem("Sobre nós",tabName = "graficos", icon = icon("commenting"))
    ),
    dashboardBody(
        tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Arial","Work Sans";
        font-size: 18px;}'))),
        
    tabItems(
      tabItem(tabName = "projeto",
              h2("Big Data - Análise de dados em metodologias Data Driven no contexto de indústria 4.0"),
              br(),
             box(solidHeader = TRUE, width=12,
                 collapsible = TRUE, 
                 br(),title = "Resumo", status = "primary",
                "Considerando as presentes mudanças que a 4° Revolução Industrial tem gerado no modo de produção e no mercado, de modo que a sociedade presencia uma nova quebra de paradigmas técno-econômicos, torna-se fundamental estar adaptado e atualizado para se manter competitivo. Deste modo, percebe-se a crescente necessidade da utilização de novos métodos e tecnologias para definir as estratégias mais efetivas, principalmente visto o contexto em que os dados se tornam uma grande ferramenta quando inseridos nas tecnologias de Big Data. Porém, para transformar simples dados em informações e utilizá-las de forma a gerar um diferencial no mercado, é necessário utilizar métodos hoje conhecidos como mineração de dados. Este trabalho propõe uma pesquisa sobre as metodologias de Data Mining mais utilizadas dentro de um contexto de Big Data e visa testar sua aplicabilidade a fim de comprovar seu potencial como vantagem competitiva."),
             box(solidHeader = TRUE, width=12,
                 collapsible = TRUE, 
                 br(),title = "Objetivos", status = "primary",
                 "O objetivo deste projeto é realizar um levantamento de metodologias data-driven (metodologia orientada por dados) – CRISP-DM, SEMMA, KDD – que possam ser usadas em um contexto a explorar a atual quebra do paradigma tecnológico visto, com o advento da 4° Revolução Industrial. Com o intuito de demonstrar a sua importância dentro do pilar de Big Data e da aplicação de técnicas de Data Mining, através da melhora dos indicadores de performance da corporação, obtenção de dados para tomada de decisões mais inteligentes, alcançando assim uma inteligência competitiva entre os concorrentes."),
             box(solidHeader = TRUE, width=12,
                 collapsible = TRUE, 
                 br(),title = "Objetivos específicos", status = "primary",
                 "Compreender e conceituar o termo de Indústria 4.0 e sua importância visto a quebra de paradigmas tecnológicos;
                  Conceituar os pilares da Indústria 4.0 com foco específico para o pilar de Big Data;
                  Compreender o papel do Data Mining dentro do pilar de BD  e conceitualizar as metodologia data-driven aplicadas a análise de dados;
                  Aplicação e validação do método de análise de dados em um caso real.")
             ),
      tabItem(tabName = "graficos",
              h2("Gráficos"),
              br(),
              plotlyOutput("graph"),
              br(),
              plotlyOutput("graph2")
              )))
    )
    



##### server #####

server <- function(input, output, session) {
  
  output$graph<- renderPlotly({
    p <- data %>%
      ggplot(aes(x = DATA, y = Total)) +
      geom_line(colour = "#317291") + 
      scale_y_continuous() +
      labs(title = "Passageiros diários URBS 03/2020 - 10/2021",
           x = "Data",
           y = "Passageiros")
    p <- plotly::ggplotly(p)
    p
  })
  
  output$graph2<- renderPlotly({
    p2021 <- data %>%
      filter(DATA >= '2021-01-01') %>% 
      ggplot(aes(x = DATA, y = Total)) +
      geom_line(colour = "#317291") + 
      scale_y_continuous() +
      labs(title = "Passageiros diários URBS 2021", 
           y = "Passageiros", x = "Data") 
    p2021 <- plotly::ggplotly(p2021)
    p2021
  })
  
}

##### App #####

shinyApp(ui = ui, server = server)