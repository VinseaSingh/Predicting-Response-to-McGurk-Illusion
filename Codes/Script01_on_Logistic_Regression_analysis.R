# Script on GLMER analysis on predicting response based on prestimulus periodic and aperiodic parameters
# Written by Vinsea AV Singh on October, 2023

##########################################################################################################################################
## Import Libraries (install packages if library not found - install.packages("<package name>"))
##########################################################################################################################################
library(lme4)        #library for mixed models 
library(lmerTest)    #library for estimating P values for GLMER model
library(lattice)     #library to use 'dotplot' function
library(effects)     #Plotting effects of all fixed-effects
library(sjPlot)      #library for 'tab_model' and 'plot_model' functions 
library(BayesFactor) #Estimate Bayes Factor

##########################################################################################################################################
## Load and rearrange the data
##########################################################################################################################################
data <- read.csv("Data\\Param_Prestim_Table_Sensor_GLMER_Bayes.csv", 
                 header = TRUE,na.strings=c("","NA","na"),stringsAsFactors = TRUE)
head(data) 
str(data)

## Format and scale the data
data[,3:42] <- scale(data[,3:42], center=TRUE)

## Convert categorical data to factor
data$Response <- as.factor(data$Response)
data$Response_num <- as.numeric(data$Response) 
data$Subject_ID <- as.factor(data$Subject_ID)
str(data)

##########################################################################################################################################
## Apply GLMER on full model
##########################################################################################################################################
## Full model
formula <- Response ~ 1+(CF_alpha_F+CF_alpha_C+CF_alpha_P+CF_alpha_T+CF_alpha_O+
                           PW_alpha_F+PW_alpha_C+PW_alpha_P+PW_alpha_T+PW_alpha_O+
                           BW_alpha_F+BW_alpha_C+BW_alpha_P+BW_alpha_T+BW_alpha_O+
                           CF_beta_F+CF_beta_C+CF_beta_P+CF_beta_T+CF_beta_O+
                           PW_beta_F+PW_beta_C+PW_beta_P+PW_beta_T+PW_beta_O+
                           BW_beta_F+BW_beta_C+BW_beta_P+BW_beta_T+BW_beta_O+
                           Off_F+Off_C+Off_P+Off_T+Off_O+
                           Exp_F+Exp_C+Exp_P+Exp_T+Exp_O) + (1|Subject_ID) 

control <- glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=2e5))
model <- glmer(formula, data=data, control=control, family="binomial", na.action=na.exclude)
summary(model)
tab_model(model, transform = NULL, show.aic=TRUE) # make APA table

##########################################################################################################################################
## Post-Hoc analysis and Plotting the model effects
##########################################################################################################################################
## Post-Hoc ANOVA 
anova_model <- Anova(model,type="III")
anova_model
summary(anova_model)

## Predictor Effects Plots
plot(allEffects(model))

## Plotting Log-Odds (Model estimates) of all predictors of the model
plot_model(model, transform = NULL, show.values = T, show.p = T,value.offset = 0.4, type="est")

## Caterpillar plots to look at the distribution of random effect (Subject ID)
lattice::dotplot(ranef(model, which = "Subject_ID", condVar = TRUE))


##########################################################################################################################################
## Bayes Factor (Full model)
##########################################################################################################################################
formula <- Response_num ~ 1+(CF_alpha_F+CF_alpha_C+CF_alpha_P+CF_alpha_T+CF_alpha_O+
                           PW_alpha_F+PW_alpha_C+PW_alpha_P+PW_alpha_T+PW_alpha_O+
                           BW_alpha_F+BW_alpha_C+BW_alpha_P+BW_alpha_T+BW_alpha_O+
                           CF_beta_F+CF_beta_C+CF_beta_P+CF_beta_T+CF_beta_O+
                           PW_beta_F+PW_beta_C+PW_beta_P+PW_beta_T+PW_beta_O+
                           BW_beta_F+BW_beta_C+BW_beta_P+BW_beta_T+BW_beta_O+
                           Off_F+Off_C+Off_P+Off_T+Off_O+
                           Exp_F+Exp_C+Exp_P+Exp_T+Exp_O)

bf_factor <- generalTestBF(formula, data=data, whichModels = "all", whichRandom="Subject_ID", progress=TRUE)
summary(bf_factor)
plot(bf_factor)
