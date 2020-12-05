library('shiny')

shinyUI(navbarPage(
  title = 'Prediction of Readmission for Dehydration following Creation of Diverting Loop Ileostomies in Colorectal Surgery',
  windowTitle = 'Readmission for Dehydration Following Creation of Diverting Loop Ileostomies',
  theme = 'flatly.css',
  
  tabPanel(title = 'Home',
           
           # fluidRow(
           #
           #   column(width = 4, offset = 1,
           #          sidebarPanel(width = 12,
           #                       h4('Please answer the following questions:'),
           #                       uiOutput('prediction_controls')
           #          )
           #   ),
           #
           #   column(width = 3,
           #          sidebarPanel(width = 12,
           #                       numericInput('pred_at',
           #                                    label = 'Prediction time point:',
           #                                    min = 0, value = 365),
           #                       actionButton(inputId = 'calc_pred_button',
           #                                    label = 'Predict Survival Probability',
           #                                    icon = icon('wrench'), class = 'btn-primary')
           #          )
           #   ),
           #
           #   column(width = 3,
           #          mainPanel(width = 12,
           #                    tabsetPanel(
           #                      tabPanel('Predicted Overall Survival Probability',
           #                               h2(textOutput('print_pred')))
           #                    )))
           #
           # ),
           
           
           fluidPage(
             # titlePanel("Please answer the following questions:"),
             fluidRow(
               column(width = 4,
                      wellPanel(
                        h4("Please answer the following questions:"),
                        numericInput("Age", label = h4("Age [18-95]"), value = 60, min = 21, max = 95, step = 1),
                        selectInput("SEX", label = h4("Sex"),
                                    choices = list("Male" = "male", "Female" = "female"),
                                    selected = "male"),
                        selectInput("ASA_Class", label = h4("ASA Class"),
                                    choices = list("1-Healthy" = "1", "2-Mild to Moderate" = "2", "3-Severe" ="3"),
                                    selected = "3"),
                        numericInput("Length_Of_Stay", label = h4("Length of stay (day) [1-395]"), value = 2, min = 1, max = 375, step = 1),
                        numericInput("Operative_Time", label = h4("Operation time (minute) [5-700]"), value = 600, min = 5, max = 700, step = 1),
                        selectInput("Disease", label = h4("Type of Disease"),
                                     choices = list("Benign Neoplasms" = "BENIGN_NEOPLASMS", "Colon Cancer" = "Colon_Cancer", "Crohns Disease" = "Crohns_Disease",
                                                    "Diverticulitis"="DIVERTICULITIS", "Rectal Cancer"= "Rectal_Cancer", "Ulcerative Colitis"="ULCERATIVE_COLITIS" ),
                                     selected = "ULCERATIVE_COLITIS"),
                        selectInput("Resection", label = h4("Type of Procedure "),
                                     choices = list("Sigmoid colectomy" = "PARTIAL_COLECTOMY", "Ileonanal Pouch" = "POUCH", 
                                                    "Proctectomy" = "PROCTECTOMY",
                                                    "Total Colectomy"="TOTAL_COLECTOMY","Ulcerative Colitis"="ULCERATIVE_COLITIS" ),
                                     selected = "POUCH"),
                        selectInput("Elective_Surgery", label = h4("Elective Surgery"),
                                     choices = list("No" = "No", "Yes" = "Yes"),
                                     selected = "Yes"),
                        selectInput("Major_Morbidity", label = h4("Major Morbidity"),
                                     choices = list("No" = "0", "Yes" = "1"),
                                     selected = "1"),
                        selectInput("SMOKing", label = h4("Smoking"),
                                     choices = list("No" = "No", "Yes" = "Yes"),
                                     selected = "Yes"),
                        selectInput("Hypertension_On_Medication", label = h4("Hypertension"),
                                     choices = list("No" = "No", "Yes" = "Yes"),
                                     selected = "Yes"),
                        selectInput("DIABETES", label = h4("Diabete"),
                                     choices = list("No" = "NO", "Yes" = "YES"),
                                     selected = "YES")
                      ),
                      
                      # Built with Shiny by RStudio
                      br(), br(),
                      h5("Built with",
                         img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
                         "by",
                         img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
                         ".")
                      
               ),
               
               column(width = 8,
                      mainPanel(width = 12,
                                tabsetPanel(
                                  tabPanel('Predicted 30-day Readmission Probability',
                                           h2(textOutput('prob1')),
                                           h2(textOutput('CI')))
                                  
                                ),
                                br(),
                                br(),
                                plotOutput('plot'),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                helpText("The solid black line represents probabilities for different ages, length of stay and operation time, while holding all other variables at their inputted value. ",
                                         "The grey region represents the 95% confidence interval.")#,
                                # "The red dot represents the inputted age.")
                      )
               )
             )
           )
           
           
           
           
  ),
  
  tabPanel(title = 'About',
           
           fluidRow(
             column(width = 10, offset = 1,
                    includeMarkdown('about.md')
                    #htmlOutput("table")
             )))
  
))
