

library(ggeffects)
library(sjPlot)
# pacman::p_load(sjPlot)
# pacman::p_load(cowplot)
library(ggplot2)
#library(plogr)

fit <- readRDS("data/Pred_Model.rds")
#load packages and data, although i could be missing some


shinyServer(function(input, output, session) {
  
  predicted_prob <- reactive({
    req(input$Age, input$Length_Of_Stay, input$Operative_Time)
    pred_prob_all <- ggpredict(fit, terms = "Age [18:95]", condition = c( DIABETES= input$DIABETES, Hypertension_On_Medication = input$Hypertension_On_Medication,
                                                                          SEX = input$SEX, SMOKing = input$SMOKing, Length_Of_Stay = input$Length_Of_Stay,
                                                                          Major_Morbidity = input$Major_Morbidity, Elective_Surgery = input$Elective_Surgery, Resection = input$Resection,
                                                                          Disease = input$Disease, ASA_Class = input$ASA_Class, Operative_Time = input$Operative_Time))
    pred_prob_all[which(pred_prob_all$x == input$Age),, drop = FALSE]  
  })
  
  
  predicted_prob_los <- reactive({
    req(input$Age, input$Length_Of_Stay, input$Operative_Time)
    pred_prob_all_los <- ggpredict(fit, terms = "Length_Of_Stay [1:395]", condition = c(Age = input$Age, DIABETES= input$DIABETES, Hypertension_On_Medication = input$Hypertension_On_Medication,
                                                                          SEX = input$SEX, SMOKing = input$SMOKing, 
                                                                          Major_Morbidity = input$Major_Morbidity, Elective_Surgery = input$Elective_Surgery, Resection = input$Resection,
                                                                          Disease = input$Disease, ASA_Class = input$ASA_Class, Operative_Time = input$Operative_Time))
    pred_prob_all_los[which(pred_prob_all_los$x == input$Length_Of_Stay),, drop = FALSE]  
  })
  
  predicted_prob_opt <- reactive({
    req(input$Age, input$Length_Of_Stay, input$Operative_Time)
    pred_prob_all_opt <- ggpredict(fit, terms = "Operative_Time[5:700]", condition = c(Age = input$Age, DIABETES= input$DIABETES, Hypertension_On_Medication = input$Hypertension_On_Medication,
                                                                                        SEX = input$SEX, SMOKing = input$SMOKing, Length_Of_Stay = input$Length_Of_Stay,
                                                                                        Major_Morbidity = input$Major_Morbidity, Elective_Surgery = input$Elective_Surgery, Resection = input$Resection,
                                                                                        Disease = input$Disease, ASA_Class = input$ASA_Class))
    pred_prob_all_opt[which(pred_prob_all_opt$x == input$Operative_Time),, drop = FALSE]  
  })
  
  plot_data <- reactive({
    
    res <- ggpredict(fit, terms = "Age [all]", condition = c( DIABETES= input$DIABETES, Hypertension_On_Medication = input$Hypertension_On_Medication,
                                                              SEX = input$SEX, SMOKing = input$SMOKing, Length_Of_Stay = input$Length_Of_Stay,
                                                              Major_Morbidity = input$Major_Morbidity, Elective_Surgery = input$Elective_Surgery, Resection = input$Resection,
                                                              Disease = input$Disease, ASA_Class = input$ASA_Class, Operative_Time = input$Operative_Time))
    res
    
  })
  
  plot_data_los <- reactive({
    
    res <- ggpredict(fit, terms = "Length_Of_Stay [all]", condition = c( DIABETES= input$DIABETES, Hypertension_On_Medication = input$Hypertension_On_Medication,
                                                              SEX = input$SEX, SMOKing = input$SMOKing, Age = input$Age, 
                                                              Major_Morbidity = input$Major_Morbidity, Elective_Surgery = input$Elective_Surgery, Resection = input$Resection,
                                                              Disease = input$Disease, ASA_Class = input$ASA_Class, Operative_Time = input$Operative_Time))
    res
    
  })
  
  plot_data_opt <- reactive({
    
    res <- ggpredict(fit, terms = "Operative_Time [all]", condition = c( DIABETES= input$DIABETES, Hypertension_On_Medication = input$Hypertension_On_Medication,
                                                              SEX = input$SEX, SMOKing = input$SMOKing, Length_Of_Stay = input$Length_Of_Stay,
                                                              Major_Morbidity = input$Major_Morbidity, Elective_Surgery = input$Elective_Surgery, Resection = input$Resection,
                                                              Disease = input$Disease, ASA_Class = input$ASA_Class,  Age = input$Age))
    res
    
  })
  # Generate an HTML table view of the data ----
  output$table <- renderTable({
    # 
   sjPlot::tab_model(fit)
   # pander::pander(summary(fit)$coefficients, split.table = Inf)
  })
  
  output$print_pred = renderPrint({
    sprintf("Probability of readmission: %.2f,\n 95%% Confidence Interval: [%.2f, %.2f]",
            predicted_prob()[,"predicted"],predicted_prob()[,"conf.low"],predicted_prob()[,"conf.high"])
    
    # predicted_prob()
    # predicted_prob[,"prob"]
    
    # input$preopventilat
    
  })
  
  
  output$prob1 <- renderText({
    paste("Probability of Readmission:",round(predicted_prob()[,"predicted"],3))
  })
  
  output$CI <- renderText({
    paste("95% Confidence Interval: [",round(predicted_prob()[,"conf.low"],3), ", ",
          round(predicted_prob()[,"conf.high"],3) ,"]")
  })
  
  
  
  output$plot <- renderPlot({
    
    trop <- c("darkorange", "dodgerblue", "hotpink"  ,  "limegreen" , "yellow")
    par(mfrow = c(3, 1))
    par(mai=c(0.65,0.9,0.1,0.1))
    par(oma = c(4, 1, 1, 1))

    
    plot(plot_data()[,"x"], plot_data()[,"predicted"], lwd = 4, type = "l", ylab = "Probability of Readmission", xlab = "Age", col = trop[2],
         bty="n", xaxt="n", cex.lab = 2.4, xlim = c(20,100), ylim = range(plot_data()[,c("predicted","conf.low","conf.high")]), cex.axis = 2)
    axis(1, labels = T, at = seq(20,90,10),cex.axis=2)
    lines(plot_data()[,"x"], plot_data()[,"conf.low"], lty = 2, col = "grey", lwd=3)
    lines(plot_data()[,"x"], plot_data()[,"conf.high"], lty = 2, col = "grey", lwd=3)
    points(x = input$Age,y =predicted_prob()[,"predicted"],  pch = 19, col = "red", cex = 2)
    

    
   plot(plot_data_los()[,"x"], plot_data_los()[,"predicted"], lwd = 4, type = "l", ylab = "Probability of Readmission", xlab = "Length of Stay", col = trop[2],
         bty="n", xaxt="n", cex.lab = 2.4, xlim = c(0,80), ylim = range(plot_data_los()[,c("predicted","conf.low","conf.high")]), cex.axis = 2)
    axis(1, labels = T, at = seq(1,400,10),  cex.axis=2)
    lines(plot_data_los()[,"x"], plot_data_los()[,"conf.low"], lty = 2, col = "grey", lwd=3)
    lines(plot_data_los()[,"x"], plot_data_los()[,"conf.high"], lty = 2, col = "grey", lwd=3)
    points(x = input$Length_Of_Stay,y =predicted_prob_los()[,"predicted"],  pch = 19, col = 'red', cex = 2)
    
    
    plot(plot_data_opt()[,"x"], plot_data_opt()[,"predicted"], lwd = 4, type = "l", ylab = "Probability of Readmission", xlab = "Operation Time", col = trop[2],
         bty="n", xaxt="n", cex.lab = 2.4, xlim = c(0,700), ylim = range(plot_data_opt()[,c("predicted","conf.low","conf.high")]), cex.axis = 2)
    axis(1, labels = T, at = seq(0,700,50), cex.axis=2)
    lines(plot_data_opt()[,"x"], plot_data_opt()[,"conf.low"], lty = 2, col = "grey", lwd=3)
    lines(plot_data_opt()[,"x"], plot_data_opt()[,"conf.high"], lty = 2, col = "grey", lwd=3)
    points(x = input$Operative_Time,y =predicted_prob_opt()[,"predicted"],  pch = 19, col = "red", cex = 2)
  
      # trop <- c("darkorange", "dodgerblue", "hotpink"  ,  "limegreen" , "yellow")
     
    #par(mai=c(0.85,0.9,0.1,0.2))
    #par(oma = c(4, 1, 1, 1))
    #plot(plot_data()[,"numage"], plot_data()[,"prob"], lwd = 4, type = "l", ylab = "Probability of Death", xlab = "Age", col = trop[2],
    #    bty="n", xaxt="n", cex.lab = 1.4, xlim = c(20,100), ylim = range(plot_data()[,c("prob","lower","upper")]))
    # axis(1, labels = T, at = seq(20,90,10))
    # lines(plot_data()[,"numage"], plot_data()[,"lower"], lty = 2, col = "grey")
    # lines(plot_data()[,"numage"], plot_data()[,"upper"], lty = 2, col = "grey")
    # points(x = input$numage,y = predicted_prob()[,"prob"],  pch = 19, col = "red", cex = 2)
    
    #plot(plot_data(), grid=F) + 
    #  theme(legend.position = "bottom",title = element_text(size = 20),
    #        axis.text.x = element_text(angle = 0, hjust = 1, size = 16),
    #        axis.text.y = element_text(size = 16),
    #        legend.text = element_text(size = 16), legend.title = element_text(size = 16),
    #        strip.text = element_text(size = 18)) +
    #  labs(x = "Age", y = " ")
      
    
  
    
  }, height = 900, width = 600)
  
  
})
