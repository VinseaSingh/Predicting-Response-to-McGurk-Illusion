# Script on plotting Figure 6 showcasing association between periodic alpha and beta power with 
# aperiodic parameters:offset and exponent

# Written by Vinsea AV Singh on September, 2023

##########################################################################################################################################
## Import Libraries (install packages if library not found - install.packages("<package name>"))
##########################################################################################################################################
library(ggplot2)    #library for plotting
library(cowplot)    #library for 'axis_canvas' function
library(patchwork)  #library for arranging plots

##########################################################################################################################################
## Load and scale the data
##########################################################################################################################################
# load the modified dataframe table
# Load the data (un-scaled)
data <- read.csv("Data\\Param_Prestim_Table_Sensor_Plot.csv", 
                 header = TRUE, na.strings=c("","NA","na"), stringsAsFactors = TRUE)
head(data)
str(data)

## Scale data
data[,4:11] <- scale(data[,4:11], center=TRUE)

## Convert categorical data to factor
data$Subject_ID <- as.factor(data$sub_idx)
data$Response_type <- factor(data$resp_idx, levels=c("1","0"), labels=c("Illusion","No-illusion"))

##########################################################################################################################################
## Rearrange data to estimate linear correlation between periodic and aperiodic parameters over the whole scalp
##########################################################################################################################################
group_mean <- aggregate(data[,4:11],
                        # Specify group indicator
                        by = list(data$Subject_ID,data$Response_type),      
                        # Specify function (i.e. mean)
                        FUN = mean)

## Rename some columns
group_mean = group_mean %>%
  rename(
    Subject_ID = Group.1,
    Response_type = Group.2
  )

##########################################################################################################################################
## Linear Correlation between periodic power and aperiodic parameters: Offset and Exponent
##########################################################################################################################################
###### Alpha PW vs Offset
alphapw_off <- ggscatter(group_mean, x = "off", y = "pw_alpha", xlab = "Offset", ylab = "Alpha Power",
                     add = "reg.line",                                   # Add regression line
                     conf.int = TRUE,                                    # Add confidence interval
                     color = "Response_type", palette = c('#FF0000','#0072BD'),         # Color by Response type
                     shape = "Response_type", size = 3                              # Change point shape by Response type
)+
  stat_cor(aes(color = Response_type))            # Add correlation coefficient

# Marginal densities along x axis
xdens <- axis_canvas(alphapw_off, axis = "x")+
  geom_density(data = group_mean, aes(x = off, fill = Response_type), alpha = 0.4, size = 0.2)+
  ggpubr::fill_palette(c('#FF0000','#0072BD'))

# Marginal densities along y axis
# Need to set coord_flip = TRUE, if you plan to use coord_flip()
ydens <- axis_canvas(alphapw_off, axis = "y", coord_flip = TRUE)+
  geom_density(data = group_mean, aes(x = pw_alpha, fill = Response_type),alpha = 0.4, size = 0.2)+
  coord_flip()+
  ggpubr::fill_palette(c('#FF0000','#0072BD'))

p1 <- insert_xaxis_grob(alphapw_off, xdens, grid::unit(.2, "null"), position = "top")
p2 <- insert_yaxis_grob(p1, ydens, grid::unit(.2, "null"), position = "right")
subfig01 <- ggdraw(p2)

##########################################################################################################################################
###### Alpha PW vs Exponent
alphapw_exp <- ggscatter(group_mean, x = "exp", y = "pw_alpha", xlab = "Exponent", ylab = "Alpha Power",
                         add = "reg.line",                         # Add regression line
                         conf.int = TRUE,                          # Add confidence interval
                         color = "Response_type", palette = c('#FF0000','#0072BD'),           
                         shape = "Response_type", size = 3,                             
)+
  stat_cor(aes(color = Response_type))           # Add correlation coefficient

# Marginal densities along x axis
xdens <- axis_canvas(alphapw_exp, axis = "x")+
  geom_density(data = group_mean, aes(x = exp, fill = Response_type), alpha = 0.4, size = 0.2)+
  ggpubr::fill_palette(c('#FF0000','#0072BD'))

# Marginal densities along y axis
# Need to set coord_flip = TRUE, if you plan to use coord_flip()
ydens <- axis_canvas(alphapw_exp, axis = "y", coord_flip = TRUE)+
  geom_density(data = group_mean, aes(x = pw_alpha, fill = Response_type),alpha = 0.4, size = 0.2)+
  coord_flip()+
  ggpubr::fill_palette(c('#FF0000','#0072BD'))

p1 <- insert_xaxis_grob(alphapw_exp, xdens, grid::unit(.2, "null"), position = "top")
p2 <- insert_yaxis_grob(p1, ydens, grid::unit(.2, "null"), position = "right")
subfig02 <- ggdraw(p2)

##########################################################################################################################################
###### Beta Power vs Offset
betapw_off <- ggscatter(group_mean, x = "off", y = "pw_beta", xlab = "Offset", ylab = "Beta Power",
                    add = "reg.line",                         # Add regression line
                    conf.int = TRUE,                          # Add confidence interval
                    color = "Response_type", palette = c('#FF0000','#0072BD'),  
                    shape = "Response_type", size = 3                            
)+
  stat_cor(aes(color = Response_type))           # Add correlation coefficient

# Marginal densities along x axis
xdens <- axis_canvas(betapw_off, axis = "x")+
  geom_density(data = group_mean, aes(x = off, fill = Response_type), alpha = 0.4, size = 0.2)+
  ggpubr::fill_palette(c('#FF0000','#0072BD'))

# Marginal densities along y axis
# Need to set coord_flip = TRUE, if you plan to use coord_flip()
ydens <- axis_canvas(betapw_off, axis = "y", coord_flip = TRUE)+
  geom_density(data = group_mean, aes(x = pw_beta, fill = Response_type),alpha = 0.4, size = 0.2)+
  coord_flip()+
  ggpubr::fill_palette(c('#FF0000','#0072BD'))

p1 <- insert_xaxis_grob(betapw_off, xdens, grid::unit(.2, "null"), position = "top")
p2 <- insert_yaxis_grob(p1, ydens, grid::unit(.2, "null"), position = "right")
subfig03 <- ggdraw(p2)

##########################################################################################################################################
###### Beta Power vs Exponent
betapw_exp <- ggscatter(group_mean, x = "exp", y = "pw_beta", xlab = "Exponent", ylab = "Beta Power",
                        add = "reg.line",                         # Add regression line
                        conf.int = TRUE,                          # Add confidence interval
                        color = "Response_type", palette = c('#FF0000','#0072BD'),           
                        shape = "Response_type", size = 3                            
)+
  stat_cor(aes(color = Response_type))           # Add correlation coefficient

# Marginal densities along x axis
xdens <- axis_canvas(betapw_exp, axis = "x")+
  geom_density(data = group_mean, aes(x = exp, fill = Response_type), alpha = 0.4, size = 0.2)+
  ggpubr::fill_palette(c('#FF0000','#0072BD'))

# Marginal densities along y axis
# Need to set coord_flip = TRUE, if you plan to use coord_flip()
ydens <- axis_canvas(betapw_exp, axis = "y", coord_flip = TRUE)+
  geom_density(data = group_mean, aes(x = pw_beta, fill = Response_type),alpha = 0.4, size = 0.2)+
  coord_flip()+
  ggpubr::fill_palette(c('#FF0000','#0072BD'))

p1 <- insert_xaxis_grob(betapw_exp, xdens, grid::unit(.2, "null"), position = "top")
p2 <- insert_yaxis_grob(p1, ydens, grid::unit(.2, "null"), position = "right")
subfig04 <- ggdraw(p2)

##########################################################################################################################################
###### Plotting Figure 6 (using patchwork)
(subfig01 | subfig02) / (subfig03 | subfig04)
