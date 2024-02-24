# Script on GLMER interaction analysis on predicting response based on interactions 
# between prestimulus periodic power and aperiodic parameters

# Written by Vinsea AV Singh on October, 2023

##########################################################################################################################################
## Import Libraries (install packages if library not found - install.packages("<package name>"))
##########################################################################################################################################
library(lme4)        #library for mixed models 
library(lmerTest)    #library for estimating P values for GLMER model
library(sjPlot)      #library for 'tab_model' and 'plot_model' functions 
library(ggplot2)     #library for plotting
library(ggeffects)   #Plotting fixed effects
library(patchwork)   #library for arranging plots

##########################################################################################################################################
## Load the data
##########################################################################################################################################
# load the modified dataframe table
# Load the data (un-scaled)
data <- read.csv("Data\\Param_Prestim_Table_Sensor_Plot.csv", 
                 header = TRUE, na.strings=c("","NA","na"), stringsAsFactors = TRUE)
head(data)
str(data)

## Format and scale the data
## Scale data
data[,4:11] <- scale(data[,4:11], center=TRUE)

## Convert categorical data to factor
data$Response <- as.factor(data$resp_idx)
data$Subject_ID <- as.factor(data$sub_idx)
data$sensor_region <- as.factor(data$sensor_idx)

##########################################################################################################################################
## Convert exponent continuous values into categorical predictors for plotting Figure 7:interaction plots
##########################################################################################################################################
##### Exponent
# Function to classify slopes into categories
classify_slope <- function(slope){
  if (0 < abs(slope) && abs(slope) <= 2) {
    return("Flatter")
  } else if (2 < abs(slope) && abs(slope) <= 6) {
    return("Steeper")
  } 
}

# Apply the function to each slope value
expcat <- sapply(data$exp, classify_slope)
data$expCat <- as.factor(expcat)
str(data)

##########################################################################################################################################
## Functions to apply GLMER on interacting predictors for alpha and beta models
##########################################################################################################################################
## Interact model
interact_model <- function(pw){
  formula <- Response ~ 1+ (pw * off * exp * sensor_region) + (1|Subject_ID)
  control <- glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=2e5))
  model <- glmer(formula, data=data, control=control, family="binomial", na.action=na.exclude)
  return(model)
}

## Interact model with exponent category to plot
interact_model_plot <- function(pw){
  formula <- Response ~ 1+ (pw * off * expCat * sensor_region) + (1|Subject_ID)
  control <- glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=2e5))
  model <- glmer(formula, data=data, control=control, family="binomial", na.action=na.exclude)
  return(model)
}

##########################################################################################################################################
## Apply GLMER on alpha and beta interaction models (May take longer than expected to run)
##########################################################################################################################################
## -------------------------------- Whole Brain Alpha Model -------------------------------- ##
#### Alpha Model results
model_alpha <- interact_model(data$pw_alpha)
summary(model_alpha)
tab_model(model_alpha, show.reflvl = TRUE)
Anova(model_alpha,type="III")  #Post-Hoc test

#### Alpha Model Plot results
model_alpha_plot <- interact_model_plot(data$pw_alpha)

alpha <- ggpredict(model_alpha_plot, c("pw[all]","off"),) 
alpha_plot <- plot(alpha) + labs(x = "Alpha Power",y = "Response",colour = "Offset",title = "Alpha Model")+
  scale_colour_brewer(palette = "Set1", labels = c("-1 SD", "Mean", "+1 SD")) +
  scale_fill_brewer(palette = "Set1")


## -------------------------------- Whole Brain Beta Model -------------------------------- ##
#### Beta Model results
model_beta <- interact_model(data$pw_beta)
tab_model(model_beta, show.reflvl = TRUE)
Anova(model_beta,type="III")  #Post-Hoc test

#### Beta Model Plot results
model_beta_plot <- interact_model_plot(data$pw_beta)

beta <- ggpredict(model_beta_plot, c("pw[all]","off","expCat"),) 
beta_plot <- plot(beta) + labs(x = "Beta Power",y = "Response",colour = "Offset",title = "Beta Model")+
  scale_colour_brewer(palette = "Set1", labels = c("-1 SD", "Mean", "+1 SD")) +
  scale_fill_brewer(palette = "Set1")


## -------------------------------- Plotting Figure 7: Interaction plots (using patchwork) -------------------------------- ## 
alpha_plot | beta_plot
