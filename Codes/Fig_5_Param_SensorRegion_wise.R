# Script to plot Figure 5: Sensor-region wise differences in periodic and aperiodic parameters 
# before illusory and non-illusory perception of the McGurk trials

# Written by Vinsea AV Singh on October, 2023

##########################################################################################################################################
## Import Libraries (install packages if library not found - install.packages("<package name>"))
##########################################################################################################################################
library(ggplot2)    #library for plotting
library(ggpubr)     #library for 'ggboxplot' function
library(patchwork)  #library for arranging plots
library(rstatix)    #library for statistics

##########################################################################################################################################
## Load and scale the data
##########################################################################################################################################
## Load the data (un-scaled)
data <- read.csv("Data\\Param_Prestim_Table_Sensor_Plot.csv", 
                 header = TRUE, na.strings=c("","NA","na"), stringsAsFactors = TRUE)

## Scale data
data[,4:11] <- scale(data[,4:11], center=TRUE)

## Convert categorical data to factor
data$Subject_ID <- as.factor(data$sub_idx)        #Subject ID
data$sensor_region <- as.factor(data$sensor_idx)  #Sensor Regions (Frontal,Central,Parietal,Occipital,Temporal)
data$Response_type <- factor(data$resp_idx, levels=c("1","0"), labels=c("Illusion","No-illusion"))  #Response index (1-Illusion, and 0-No illusion)

str(data)

##########################################################################################################################################
## Parameter Plotting in Figure 5
##########################################################################################################################################
#### Aperiodic (Offset, Exponent)
## Offset
off <- ggboxplot(data,x="sensor_idx",y="off",color="Response_type",xlab="Sensor Regions",add="mean_se",ylab="Offset",size=1.15)
off_stat <- off+stat_pvalue_manual(data %>%
                                     group_by(sensor_idx) %>%
                                     rstatix::wilcox_test(off ~ Response_type)%>%
                                     adjust_pvalue(method = "holm") %>% 
                                     add_significance("p.adj") %>%
                                     add_xy_position(x="sensor_idx",dodge = 0.8))

## Exponent
exp <- ggboxplot(data,x="sensor_idx",y="exp",color="Response_type",xlab="Sensor Regions",add="mean_se",ylab="Exponent",size=1.15)
exp_stat <- exp+stat_pvalue_manual(data %>%
                                     group_by(sensor_idx) %>%
                                     rstatix::wilcox_test(exp ~ Response_type) %>% 
                                     adjust_pvalue(method = "holm") %>% 
                                     add_significance("p.adj") %>%
                                     add_xy_position(x="sensor_idx",dodge = 0.8))


## Plotting Figure 5A (using patchwork)
off_stat/exp_stat


##########################################################################################################################################
#### Periodic alpha parameters (CF,PW,BW)
## CF alpha
cf_alpha <- ggboxplot(data,x="sensor_idx",y="cf_alpha",color="Response_type",xlab="Sensor Regions",add="mean_se",
                      ylab="Alpha Frequency (Hz)",size=1.15)
cf_alpha_stat <- cf_alpha+stat_pvalue_manual(data %>%
                                               group_by(sensor_idx) %>%
                                               rstatix::wilcox_test(cf_alpha ~ Response_type) %>% 
                                               adjust_pvalue(method = "holm") %>% 
                                               add_significance("p.adj") %>%
                                               add_xy_position(x="sensor_idx",dodge = 0.8))

## PW (alpha)
pw_alpha <- ggboxplot(data,x="sensor_idx",y="pw_alpha",color="Response_type",xlab="Sensor Regions",add="mean_se",
                      ylab="Alpha Peak Power",size=1.15)
pw_alpha_stat <- pw_alpha+stat_pvalue_manual(data %>%
                                               group_by(sensor_idx) %>%
                                               rstatix::wilcox_test(pw_alpha ~ Response_type) %>%
                                               adjust_pvalue(method = "holm") %>% 
                                               add_significance("p.adj") %>%
                                               add_xy_position(x="sensor_idx",dodge = 0.8))

## BW (alpha)
bw_alpha <- ggboxplot(data,x="sensor_idx",y="bw_alpha",color="Response_type",xlab="Sensor Regions",add="mean_se",
                      ylab="Alpha Bandwidth (Hz)",size=1.15)
bw_alpha_stat <- bw_alpha+stat_pvalue_manual(data %>%
                                               group_by(sensor_idx) %>%
                                               rstatix::wilcox_test(bw_alpha ~ Response_type) %>%
                                               adjust_pvalue(method = "holm") %>% 
                                               add_significance("p.adj") %>%
                                               add_xy_position(x="sensor_idx",dodge = 0.8))


##########################################################################################################################################
#### Periodic beta parameters (CF,PW,BW)
## CF (beta)
cf_beta <- ggboxplot(data,x="sensor_idx",y="cf_beta",color="Response_type",xlab="Sensor Regions",add="mean_se",
                     ylab="Beta Frequency (Hz)",size=1.15)
cf_beta_stat <- cf_beta+stat_pvalue_manual(data %>%
                                             group_by(sensor_idx) %>%
                                             rstatix::wilcox_test(cf_beta ~ Response_type) %>% 
                                             adjust_pvalue(method = "holm") %>% 
                                             add_significance("p.adj") %>%
                                             add_xy_position(x="sensor_idx",dodge = 0.8))

## PW (beta)
pw_beta <- ggboxplot(data,x="sensor_idx",y="pw_beta",color="Response_type",xlab="Sensor Regions",add="mean_se",
                     ylab="Beta Peak Power",size=1.15)
pw_beta_stat <- pw_beta+stat_pvalue_manual(data %>%
                                             group_by(sensor_idx) %>%
                                             rstatix::wilcox_test(pw_beta ~ Response_type) %>%
                                             adjust_pvalue(method = "holm") %>% 
                                             add_significance("p.adj") %>%
                                             add_xy_position(x="sensor_idx",dodge = 0.8))

## BW (beta)
bw_beta <- ggboxplot(data,x="sensor_idx",y="bw_beta",color="Response_type",xlab="Sensor Regions",add="mean_se",
                     ylab="Beta Bandwidth (Hz)",size=1.15)
bw_beta_stat <- bw_beta+stat_pvalue_manual(data %>%
                                             group_by(sensor_idx) %>%
                                             rstatix::wilcox_test(bw_beta ~ Response_type) %>%
                                             adjust_pvalue(method = "holm") %>% 
                                             add_significance("p.adj") %>%
                                             add_xy_position(x="sensor_idx",dodge = 0.8))

##########################################################################################################################################
## Plotting Figure 5B (using patchwork)
(cf_alpha_stat|cf_beta_stat)/(pw_alpha_stat|pw_beta_stat)/(bw_alpha_stat|bw_beta_stat)
