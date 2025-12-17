# Aplicación Shiny para Análisis de Prensa - Carabineros
# Observatorio de Legitimidad

library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(DT)
library(plotly)
library(shinythemes)

# Cargar datos
# Priorizar data/ local (para shinyapps.io), luego buscar en directorio padre
data_paths <- c(
  file.path("data", "noticias_carabineros.rds"),  # Primero buscar localmente
  file.path("..", "data", "noticias_carabineros.rds"),  # Luego en directorio padre
  file.path(getwd(), "data", "noticias_carabineros.rds"),
  file.path(getwd(), "..", "data", "noticias_carabineros.rds")
)

data_path <- NULL
for (path in data_paths) {
  if (file.exists(path)) {
    data_path <- path
    break
  }
}

if (is.null(data_path)) {
  stop("No se encontró el archivo de datos noticias_carabineros.rds. 
       Asegúrate de que el archivo esté en shiny-app/data/ para el despliegue.")
}

noticias <- readRDS(data_path)
cat("Datos cargados desde:", data_path, "\n")
cat("Total de noticias:", nrow(noticias), "\n")

# Preparar datos
noticias <- noticias %>%
  mutate(
    año = year(fecha),
    mes = month(fecha),
    año_mes = floor_date(fecha, "month"),
    medio = as.factor(medio)
  )

# Variables de delitos
delitos_vars <- c(
  "abuso_sexual", "asalto", "encerrona", "femicidio", "homicidio",
  "hurto", "lesiones", "microtrafico", "narcotrafico", "portonazo",
  "riña", "robo", "trafico_drogas", "violencia_intrafamiliar", "violacion"
)

# UI
ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  tags$head(
    tags$style(HTML("
      .main-header {
        background: linear-gradient(135deg, #4E4976 0%, #3F3351 100%);
        color: white;
        padding: 2rem;
        margin-bottom: 2rem;
        border-radius: 0.5rem;
      }
      .main-header h1 {
        margin: 0;
        font-size: 2.5rem;
      }
      .main-header p {
        margin: 0.5rem 0 0 0;
        opacity: 0.9;
      }
      .sidebar {
        background-color: #f8f9fa;
        padding: 1.5rem;
        border-radius: 0.5rem;
        margin-bottom: 1rem;
      }
      .content-box {
        background: white;
        padding: 1.5rem;
        border-radius: 0.5rem;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        margin-bottom: 1.5rem;
      }
      h3 {
        color: #4E4976;
        margin-top: 0;
      }
    "))
  ),
  
  div(class = "main-header",
      h1("Análisis de Prensa: Cobertura de Legitimidad Institucional"),
      p("Observatorio de Legitimidad - Análisis de cobertura mediática sobre Carabineros")
  ),
  
  sidebarLayout(
    sidebarPanel(
      class = "sidebar",
      h3("Filtros"),
      
      dateRangeInput(
        "fecha_range",
        "Rango de fechas:",
        start = as.Date("2016-01-01"),
        end = as.Date("2025-03-03"),
        min = min(noticias$fecha),
        max = max(noticias$fecha),
        language = "es",
        separator = " a "
      ),
      
      selectInput(
        "medio_select",
        "Medio de comunicación:",
        choices = c("Todos" = "all", sort(unique(noticias$medio))),
        selected = "all"
      ),
      
      selectInput(
        "delito_select",
        "Tipo de delito (filtro):",
        choices = c(
          "Todos" = "all",
          "Delitos Comunes" = "delitos_comunes",
          "Abuso Sexual" = "abuso_sexual",
          "Asalto" = "asalto",
          "Encerrona" = "encerrona",
          "Femicidio" = "femicidio",
          "Homicidio" = "homicidio",
          "Hurto" = "hurto",
          "Lesiones" = "lesiones",
          "Microtráfico" = "microtrafico",
          "Narcotráfico" = "narcotrafico",
          "Portonazo" = "portonazo",
          "Riña" = "riña",
          "Robo" = "robo",
          "Tráfico de Drogas" = "trafico_drogas",
          "Violencia Intrafamiliar" = "violencia_intrafamiliar",
          "Violación" = "violacion"
        ),
        selected = "all"
      ),
      
      hr(),
      
      h4("Comparación de Delitos"),
      p("Selecciona los delitos a comparar:"),
      checkboxGroupInput(
        "delitos_comparar",
        "",
        choices = c(
          "Homicidio" = "homicidio",
          "Robo" = "robo",
          "Lesiones" = "lesiones",
          "Violencia Intrafamiliar" = "violencia_intrafamiliar",
          "Narcotráfico" = "narcotrafico",
          "Asalto" = "asalto",
          "Hurto" = "hurto",
          "Portonazo" = "portonazo",
          "Abuso Sexual" = "abuso_sexual",
          "Femicidio" = "femicidio",
          "Violación" = "violacion",
          "Encerrona" = "encerrona",
          "Riña" = "riña",
          "Microtráfico" = "microtrafico",
          "Tráfico de Drogas" = "trafico_drogas"
        ),
        selected = c("homicidio", "robo", "lesiones", "violencia_intrafamiliar", "narcotrafico")
      ),
      
      hr(),
      
      h4("Información"),
      p(strong("Total de noticias:"), textOutput("total_noticias", inline = TRUE)),
      p(strong("Período:"), textOutput("periodo", inline = TRUE)),
      p(strong("Medios:"), textOutput("num_medios", inline = TRUE))
    ),
    
    mainPanel(
      tabsetPanel(
        type = "tabs",
        
        tabPanel(
          "Resumen",
          div(class = "content-box",
              h3("Tendencias Temporales"),
              plotlyOutput("tendencia_temporal", height = "400px")
          ),
          div(class = "content-box",
              h3("Noticias por Medio"),
              plotlyOutput("noticias_medio", height = "400px")
          )
        ),
        
        tabPanel(
          "Análisis de Delitos",
          div(class = "content-box",
              h3("Evolución de Delitos en el Tiempo"),
              plotlyOutput("delitos_tiempo", height = "400px")
          ),
          div(class = "content-box",
              h3("Comparación de Delitos"),
              plotlyOutput("delitos_comparacion", height = "400px")
          )
        ),
        
        tabPanel(
          "Análisis por Medio",
          div(class = "content-box",
              h3("Cobertura por Medio de Comunicación"),
              plotlyOutput("medio_tiempo", height = "400px")
          ),
          div(class = "content-box",
              h3("Top 10 Medios por Número de Noticias"),
              DT::dataTableOutput("top_medios")
          )
        ),
        
        tabPanel(
          "Búsqueda de Noticias",
          div(class = "content-box",
              h3("Búsqueda en Contenido"),
              textInput("busqueda_texto", "Buscar en títulos y contenido:", placeholder = "Ej: Carabineros, violencia, etc."),
              numericInput("max_resultados", "Máximo de resultados:", value = 50, min = 10, max = 200, step = 10),
              actionButton("buscar", "Buscar", class = "btn-primary")
          ),
          div(class = "content-box",
              h3("Resultados"),
              DT::dataTableOutput("tabla_noticias")
          )
        ),
        
        tabPanel(
          "Datos",
          div(class = "content-box",
              h3("Tabla de Datos"),
              p("Mostrando las noticias filtradas. Puedes descargar los datos usando el botón de descarga."),
              DT::dataTableOutput("tabla_datos")
          )
        )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Datos filtrados reactivos
  datos_filtrados <- reactive({
    datos <- noticias %>%
      filter(
        fecha >= input$fecha_range[1],
        fecha <= input$fecha_range[2]
      )
    
    if (input$medio_select != "all") {
      datos <- datos %>% filter(medio == input$medio_select)
    }
    
    if (input$delito_select != "all") {
      if (input$delito_select == "delitos_comunes") {
        datos <- datos %>% filter(delitos_comunes > 0)
      } else {
        datos <- datos %>% filter(!!sym(input$delito_select) > 0)
      }
    }
    
    return(datos)
  })
  
  # Información resumen
  output$total_noticias <- renderText({
    nrow(datos_filtrados())
  })
  
  output$periodo <- renderText({
    paste(
      format(min(datos_filtrados()$fecha), "%d/%m/%Y"),
      "-",
      format(max(datos_filtrados()$fecha), "%d/%m/%Y")
    )
  })
  
  output$num_medios <- renderText({
    length(unique(datos_filtrados()$medio))
  })
  
  # Gráfico de tendencia temporal
  output$tendencia_temporal <- renderPlotly({
    datos_mensual <- datos_filtrados() %>%
      group_by(año_mes) %>%
      summarise(total = n(), .groups = "drop")
    
    p <- ggplot(datos_mensual, aes(x = año_mes, y = total)) +
      geom_line(color = "#4E4976", size = 1.2) +
      geom_point(color = "#4E4976", size = 2) +
      labs(
        x = "Fecha",
        y = "Número de Noticias",
        title = "Evolución del Número de Noticias en el Tiempo"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 14, face = "bold", color = "#4E4976"),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
    
    ggplotly(p, tooltip = c("x", "y"))
  })
  
  # Noticias por medio
  output$noticias_medio <- renderPlotly({
    datos_medio <- datos_filtrados() %>%
      count(medio, sort = TRUE) %>%
      slice_head(n = 10)
    
    p <- ggplot(datos_medio, aes(x = reorder(medio, n), y = n, fill = medio)) +
      geom_bar(stat = "identity", fill = "#4E4976") +
      coord_flip() +
      labs(
        x = "Medio",
        y = "Número de Noticias",
        title = "Top 10 Medios"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 12, face = "bold", color = "#4E4976"),
        legend.position = "none"
      )
    
    ggplotly(p, tooltip = c("y"))
  })
  
  # Evolución de delitos en el tiempo
  output$delitos_tiempo <- renderPlotly({
    if (is.null(input$delitos_comparar) || length(input$delitos_comparar) == 0) {
      return(plotly_empty() %>% 
             layout(title = "Selecciona al menos un delito para comparar"))
    }
    
    delitos_seleccionados <- input$delitos_comparar
    
    delitos_mensual <- datos_filtrados() %>%
      group_by(año_mes) %>%
      summarise(
        across(all_of(delitos_seleccionados), sum),
        .groups = "drop"
      ) %>%
      tidyr::pivot_longer(-año_mes, names_to = "delito", values_to = "total")
    
    if (nrow(delitos_mensual) == 0 || sum(delitos_mensual$total) == 0) {
      return(plotly_empty() %>% 
             layout(title = "No hay datos para los delitos seleccionados"))
    }
    
    p <- ggplot(delitos_mensual, aes(x = año_mes, y = total, color = delito)) +
      geom_line(size = 1) +
      geom_point(size = 1.5) +
      labs(
        x = "Fecha",
        y = "Número de Noticias",
        title = "Evolución de Delitos en el Tiempo",
        color = "Tipo de Delito"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 14, face = "bold", color = "#4E4976"),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom"
      )
    
    ggplotly(p)
  })
  
  # Comparación de delitos
  output$delitos_comparacion <- renderPlotly({
    if (is.null(input$delitos_comparar) || length(input$delitos_comparar) == 0) {
      return(plotly_empty() %>% 
             layout(title = "Selecciona al menos un delito para comparar"))
    }
    
    delitos_seleccionados <- input$delitos_comparar
    
    delitos_totales <- datos_filtrados() %>%
      summarise(
        across(all_of(delitos_seleccionados), sum)
      ) %>%
      tidyr::pivot_longer(everything(), names_to = "delito", values_to = "total") %>%
      filter(total > 0) %>%
      arrange(desc(total))
    
    if (nrow(delitos_totales) == 0) {
      return(plotly_empty() %>% 
             layout(title = "No hay datos para los delitos seleccionados"))
    }
    
    p <- ggplot(delitos_totales, aes(x = reorder(delito, total), y = total, fill = delito)) +
      geom_bar(stat = "identity", fill = "#4E4976") +
      coord_flip() +
      labs(
        x = "Tipo de Delito",
        y = "Número de Noticias",
        title = "Comparación de Delitos"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 14, face = "bold", color = "#4E4976"),
        legend.position = "none"
      )
    
    ggplotly(p, tooltip = c("y"))
  })
  
  # Cobertura por medio en el tiempo
  output$medio_tiempo <- renderPlotly({
    medios_top <- datos_filtrados() %>%
      count(medio, sort = TRUE) %>%
      slice_head(n = 5) %>%
      pull(medio)
    
    datos_medio_tiempo <- datos_filtrados() %>%
      filter(medio %in% medios_top) %>%
      group_by(año_mes, medio) %>%
      summarise(total = n(), .groups = "drop")
    
    p <- ggplot(datos_medio_tiempo, aes(x = año_mes, y = total, color = medio)) +
      geom_line(size = 1) +
      geom_point(size = 1.5) +
      labs(
        x = "Fecha",
        y = "Número de Noticias",
        title = "Evolución de Cobertura por Medio (Top 5)",
        color = "Medio"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 14, face = "bold", color = "#4E4976"),
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom"
      )
    
    ggplotly(p)
  })
  
  # Tabla top medios
  output$top_medios <- DT::renderDataTable({
    datos_filtrados() %>%
      count(medio, sort = TRUE) %>%
      slice_head(n = 10) %>%
      rename("Medio" = medio, "Número de Noticias" = n) %>%
      DT::datatable(
        options = list(
          pageLength = 10,
          dom = "t",
          language = list(url = "//cdn.datatables.net/plug-ins/1.10.24/i18n/Spanish.json")
        ),
        rownames = FALSE
      )
  })
  
  # Búsqueda de noticias
  resultados_busqueda <- eventReactive(input$buscar, {
    if (is.null(input$busqueda_texto) || input$busqueda_texto == "") {
      return(datos_filtrados() %>% slice_head(n = input$max_resultados))
    }
    
    texto_buscar <- tolower(input$busqueda_texto)
    
    datos_filtrados() %>%
      filter(
        grepl(texto_buscar, tolower(titular), fixed = FALSE) |
        grepl(texto_buscar, tolower(texto_clean), fixed = FALSE)
      ) %>%
      slice_head(n = input$max_resultados) %>%
      select(fecha, medio, titular, url) %>%
      arrange(desc(fecha))
  })
  
  output$tabla_noticias <- DT::renderDataTable({
    resultados_busqueda() %>%
      mutate(
        url = paste0('<a href="', url, '" target="_blank">Ver noticia</a>'),
        fecha = format(fecha, "%d/%m/%Y")
      ) %>%
      rename("Fecha" = fecha, "Medio" = medio, "Título" = titular, "Enlace" = url) %>%
      DT::datatable(
        escape = FALSE,
        options = list(
          pageLength = 10,
          language = list(url = "//cdn.datatables.net/plug-ins/1.10.24/i18n/Spanish.json"),
          scrollX = TRUE
        ),
        rownames = FALSE
      )
  })
  
  # Tabla de datos completa
  output$tabla_datos <- DT::renderDataTable({
    datos_filtrados() %>%
      select(fecha, medio, titular, url, delitos_comunes) %>%
      mutate(
        fecha = format(fecha, "%d/%m/%Y"),
        url = paste0('<a href="', url, '" target="_blank">Ver</a>')
      ) %>%
      rename(
        "Fecha" = fecha,
        "Medio" = medio,
        "Título" = titular,
        "Enlace" = url,
        "Delitos Comunes" = delitos_comunes
      ) %>%
      DT::datatable(
        escape = FALSE,
        options = list(
          pageLength = 25,
          language = list(url = "//cdn.datatables.net/plug-ins/1.10.24/i18n/Spanish.json"),
          scrollX = TRUE,
          dom = "Bfrtip",
          buttons = c("copy", "csv", "excel")
        ),
        extensions = "Buttons",
        rownames = FALSE
      )
  })
}

# Ejecutar aplicación
shinyApp(ui = ui, server = server)

