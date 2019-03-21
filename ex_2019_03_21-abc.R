library(shiny)
library(dplyr)
library(ggplot2)

shinyApp(
  ui = fluidPage(
    title = "Beta-Binomial",
    titlePanel("Beta-Binomial Visualizer"),
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        h4("Data:"),
        sliderInput("x", "# of heads", min=0, max=100, value=10),
        sliderInput("n", "# of flips", min=0, max=100, value=20),
        h4("Prior:"),
        numericInput("alpha", "Prior # of head", min=0, value=5),
        numericInput("beta", "Prior # of tails", min=0, value=5),
        h4("ABC:"),
        checkboxInput("abc", "Include ABC posterior"),
        conditionalPanel(
          "input.abc == true",
          numericInput("nsims", "# of simulations", 100000),
          numericInput("min_post", "Minimum # of posterior samples", 1000)
        )
      ),
      mainPanel = mainPanel(
        plotOutput("plot")
      )
    )
  ),
  server = function(input, output, session) {
    
    observeEvent(
      input$n,
      {
        updateSliderInput(session, "x", max = input$n)
      }
    )
    
    output$plot = renderPlot({
      
      d = tibble(
        p = seq(0, 1, length.out = 1000)
      ) %>%
        mutate(
          prior = dbeta(p, input$alpha, input$beta),
          likelihood = dbinom(input$x, size = input$n, prob = p),
          posterior = dbeta(p, input$alpha + input$x, input$beta + input$n - input$x)
        ) %>%
        tidyr::gather(distribution, density, -p) %>%
        group_by(distribution) %>%
        mutate(
          density = density / sum(density / n())
        )
      
      if (input$abc) {
      
        prior = rbeta(input$nsims, input$alpha, input$beta)
        
        gen_proc_sims = rbinom(input$nsims, size = input$n, prob = prior)
        
        posterior = prior[ gen_proc_sims == input$x ]
        
        if (length(posterior) < input$min_post)
            stop("Not enough posterior samples, try increasing the number of simulations.")
        
        post_dens = density(posterior)
        abc = tibble(
          distribution = "posterion (ABC)",
          p = post_dens$x,
          density = post_dens$y
        )
        
        d = bind_rows(
          d,
          abc
        )
      }
      
      pal = c("#66c2a5","#fc8d62","#8da0cb","#e78ac3")
        
      g = ggplot(d, aes(x=p, y=density, color=forcats::as_factor(distribution))) +
        geom_line(size=2, alpha=0.5) + 
        scale_color_manual(values = pal) +
        theme_bw() +
        labs(color = "Distribution")
      
      g
    })
  }
)
