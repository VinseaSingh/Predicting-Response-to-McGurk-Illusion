%% Code for Figure 1B: Behavior
% Written by Vinsea AV Singh on June 2023
%% This code plots Figure 1B (i): Behavior (Inter-individual variability)
%{
   Input: 'BehaviorResponse\ta' - total percentage of McGurk /ta/ illusory response of all the participants
   Output: Scatter plot showing distribituion of total %age of McGurk illusion response for all participants
%}
clear; clc
load('Data\BehaviorResponse.mat')

Sort_McG_ta = sort(ta);          % Sort the percentage of /ta/ responses in ascending order
num = 1:18;                      % Participant number
median_ta = median(Sort_McG_ta); % Median

figure;
b = barh(num, Sort_McG_ta);
b.FaceColor = [0,.7,.7]; b.EdgeColor = [0,.4,.5]; b.LineWidth = 1.5;
xl = xline(median_ta,'--','Median = 60.83','LineWidth',2,'FontSize',18);
xl.LabelVerticalAlignment = 'bottom';
xl.LabelOrientation = 'horizontal';
title('Inter-Individual Variability','FontSize',25);
ylabel('Participant number','FontSize',20); xlabel('% McGurk percept /ta/','FontSize',20);

%% This code plots Figure 1B (ii): Behavior (Inter-trial variability)
%{
   Input: 'BehaviorResponse\ta' - total percentage of McGurk /ta/ illusory response of all the participants
          'BehaviorResponse\Sub_Percent_Cong' - total percentage of congruent /pa/, /ta/, /ka/, and other 
                                       responses of all the participants during congruent trials
          'BehaviorResponse\Sub_Percent_McG' - total percentage of McGurk /pa/ (unisensory), /ta/ (illusory), 
                                      /ka/, and other responses of all the participants during McGurk trials

   Output: Violin plot showing inter-trial variability during incongruent and congruent stimulus 
           responses for both the rare and frequent group of perceivers

   Toolbox used for violin plot is 'Violin Plots for Matlab' by Bechtold and Bastian, 2016 
   (https://github.com/bastibe/Violinplot-Matlab) 
%}
% Add the violinplot toolbox to the MATLAB path
% All toolboxes are present in the folder "Toolboxes"

addpath('Toolboxes\Violinplot-Matlab-master') 

Sort_McG_ta = sort(ta);          % Sort the percentage of /ta/ responses in ascending order
median_ta = median(Sort_McG_ta); % Median

rare_idx = find(ta <= median_ta);
freq_idx = find(ta > median_ta);

%%%%%%%%%%% Extract the percentage responses groupwise %%%%%%%%%%%
%%%%------------------------- rare (less than the median percentage)------------------------- %%%%
for i = 1:length(rare_idx)
    sub = rare_idx(i);
    Cong_pa_rare(i) = Sub_Percent_Cong{sub}(1);
    Cong_ta_rare(i) = Sub_Percent_Cong{sub}(2);
    Cong_ka_rare(i) = Sub_Percent_Cong{sub}(3);
    McG_pa_rare(i)  = Sub_Percent_McG{sub}(1);
    McG_ta_rare(i)  = Sub_Percent_McG{sub}(2);
end

m_Cong_pa_rare = mean(Cong_pa_rare);
m_Cong_ta_rare = mean(Cong_ta_rare);
m_Cong_ka_rare = mean(Cong_ka_rare);
m_rare.Cong = (m_Cong_pa_rare+m_Cong_ta_rare+m_Cong_ka_rare)./3;

m_rare.McG_pa = mean(McG_pa_rare);
m_rare.McG_ta = mean(McG_ta_rare);

std_pa_rare = std(Cong_pa_rare);
std_ta_rare = std(Cong_ta_rare);
std_ka_rare = std(Cong_ka_rare); 

sd_rare.Cong = (std_pa_rare+std_ta_rare+std_ka_rare)./3;                    
sd_rare.McG_pa = std(McG_pa_rare);            
sd_rare.McG_ta = std(McG_ta_rare); 


%%%%------------------------- frequent (more than the median percentage)------------------------- %%%%
for i = 1:length(freq_idx)
    sub = freq_idx(i);
    Cong_pa_freq(i) = Sub_Percent_Cong{sub}(1);
    Cong_ta_freq(i) = Sub_Percent_Cong{sub}(2);
    Cong_ka_freq(i) = Sub_Percent_Cong{sub}(3);
    McG_pa_freq(i)  = Sub_Percent_McG{sub}(1);
    McG_ta_freq(i)  = Sub_Percent_McG{sub}(2);
end

m_Cong_pa_freq = mean(Cong_pa_freq);
m_Cong_ta_freq = mean(Cong_ta_freq);
m_Cong_ka_freq = mean(Cong_ka_freq);
m_freq.Cong = (m_Cong_pa_freq+m_Cong_ta_freq+m_Cong_ka_freq)./3;  

m_freq.McG_pa = mean(McG_pa_freq);
m_freq.McG_ta = mean(McG_ta_freq);

std_pa_freq = std(Cong_pa_freq);
std_ta_freq = std(Cong_ta_freq);
std_ka_freq = std(Cong_ka_freq); 

sd_freq.Cong = (std_pa_freq+std_ta_freq+std_ka_freq)./3;                    
sd_freq.McG_pa = std(McG_pa_freq);            
sd_freq.McG_ta = std(McG_ta_freq);

%%%% Plot
grouporder = {'Non-illusory','Illusory /ta/','/pa/-/pa/','/ta/-/ta/','/ka/-/ka/'};
figure;
subplot(2,2,[1,2])
violinplot([McG_pa_rare',McG_ta_rare',Cong_pa_rare', Cong_ta_rare', Cong_ka_rare'],grouporder,'GroupOrder',grouporder)
ylabel('Percentage responses','FontSize',18);
title('Participants less prone to illusory percept','FontSize',18);
h = gca; h.Box = 'off'; h.FontSize = 18; 

subplot(2,2,[3,4])
violinplot([McG_pa_freq',McG_ta_freq',Cong_pa_freq', Cong_ta_freq', Cong_ka_freq'],grouporder,'GroupOrder',grouporder)
ylabel('Percentage responses','FontSize',18);
title('Participants more prone to illusory percept','FontSize',18);
xlabel('Stimuli','FontSize',18)
h = gca; h.Box = 'off'; h.FontSize = 18; 
sgtitle('(ii) Inter-trial Variability','FontSize',30)
