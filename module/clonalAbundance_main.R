library("alakazam")

clonalAbundance_mainUI <- function(id) {
  ns <- NS(id)
  mainPanel(
    plotOutput(ns('clonal_abundance_plot')),
    downloadButton(ns("download_data"), "Download data (.csv)"),
    downloadButton(ns("download_plot"), "Download plot (.pdf)")
  )
}


clonalAbundance_mainServer <- function(id, data, group_cols) {
  moduleServer(id, function(input, output, session) {
    
    plot_width <- reactive(input$plot_width)
    plot_height <- reactive(input$plot_height)
    legend <- reactive(ifelse(input$legend, "right", "none"))
    observe(updateSelectInput(session, "group_by", choices = group_cols))
    
    # get clonal_abundance
    clonalAbundance <- reactive({
      data <- data %>%
        drop_na(any_of(c("raw_clonotype_id", input$group_by)))
      alakazam::estimateAbundance(
        data,
        clone  = "raw_clonotype_id",
        group  = input$group_by,
        ci     = 0.95,
        nboot  = 100
      )
    })
    
    # get plot
    clonalAbundancePlot <- reactive({
      g <- plot(clonalAbundance())
      if (!input$sd){
        g$layers <- g$layers[-1]
      }
      my_colors <- my_palette(length(unique(pull(clonalAbundance()@abundance, !!clonalAbundance()@group_by))), input$palette)
      g <- g +
        labs(title=NULL) +
        scale_color_manual(values = my_colors) +
        scale_fill_manual(values = my_colors) +
        theme_classic() +
        theme(legend.position = legend())
      
      return(g)
    })
    
    # output plot
    output$clonal_abundance_plot <- renderPlot(
      clonalAbundancePlot(),
      width  = plot_width,
      height = plot_height
    )
    
    output$download_data <- downloadHandler(
      filename = function() {"clonal_abundance.csv"},
      content = function(file) {
        write_csv(clonalAbundance()@abundance, file)
      }
    )
    
    output$download_plot <- downloadHandler(
      filename = function() {"clonal_abundance.pdf"},
      content = function(file) {
        ggsave(file, plot = clonalAbundancePlot(), width = plot_width(), height = plot_height(), unit = "px", dpi = "screen")
      }
    )
    
  })
}

