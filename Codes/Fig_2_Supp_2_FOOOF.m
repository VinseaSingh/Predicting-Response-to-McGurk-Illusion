%% Code for generating Figure 2 and Supplementary Figure 2
% Written by Vinsea AV Singh on July 2023
%{
  Input: 'power_spec_data.mat' - Power Spectrum Densities of all Participants' illusory (McG ta) and
                                 non-illusory (McG pa) conditions (spec X channel X trials) 
                                                                   
   Output: 'fooof_prestim', 'fooof_poststim' - After parameterizing the PSDs using FOOOF 
           'prestim', 'poststim' - After extracting periodic and aperiodic distributions 
                                   from 'fooof_prestim' and 'fooof_poststim' struct file 
                                   
   Toolbox used for estimating power spectrum - 'FOOOF: Fitting Oscillations & One-Over f (MATLAB wrapper)
                                                (Donoghue et al., 2020)
                                              - 'Shaded Plots and Statistical Distribution Visualizations'
(https://www.mathworks.com/matlabcentral/fileexchange/69203-shaded-plots-and-statistical-distribution-visualizations), 
                                                MATLAB Central File Exchange.
 
   Function file required -> 'Func_fooof_estm.m' - for parameterizing PSD trial-wise using FOOOF
                          -> 'Func_fooof_getdistrib' - for extracting periodic and 
                                                       aperiodic distributions
               
****DISCLAIMER****
Make sure you have installed python wrapper for MATLAB in your system to run the FOOOF function in MATLAB. 
Check out the following link on how to install python for MATLAB: 
https://irenevigueguix.wordpress.com/2020/03/25/loading-python-into-matlab/
%}

%%%%%%%%%% Either run the section 1 below to estimate parameterized PSD or jump to Section 2 
%to load estimated periodic and aperiodic distributions for plotting Figure 2 & Supplementary Figure 2 %%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 1: Periodic and Aperiodic Activity Estimation
%%----------------Applying FOOOF on PSD to estimate periodic oscillations and aperiodic activity----------------%%
% Add 'FOOOF' toolbox in MATLAB path
clear; clc
restoredefaultpath
addpath(genpath('Toolboxes\fooof_mat-main'))

% Check if MATLAB has loaded Python (Here I used python 3.7 version)
pyenv

% Load preprocessed EEG time-series data
load('Data\power_spec_data.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% FOOOF model estimate for the McGurk data for all participants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prestimulus
cfg.choice = 'channel_avg';
fooof_prestim = Func_fooof_estm(Power_prestim, cfg); 

% Poststimulus
cfg.choice = 'channel_avg';
fooof_poststim = Func_fooof_estm(Power_poststim, cfg);

% save('Data\fooof_ch_avg','fooof_prestim','fooof_poststim')

%% Section 2: Plot periodic and aperiodic distributions in Figure 2 & Supplementary Figure 2
load('Data\fooof_ch_avg.mat')
addpath('Toolboxes\shaded_plots')

%%%% Extract Prestimulus distributions
prestim = Func_fooof_getdistrib(fooof_prestim);

%%%% Extract Poststimulus distributions
poststim = Func_fooof_getdistrib(fooof_poststim);

%% Plotting Figure 2
figure;
subplot(1,2,1)
plot_distribution(prestim.freqs_ta, prestim.periodic_ta, 'Color', [1 0 0], 'Alpha',0.2); hold on
plot_distribution(prestim.freqs_pa, prestim.periodic_pa, 'Color', [0 0.4470 0.7410], 'Alpha', 0.2); 
xlabel('Frequency (in Hz)'); ylabel('log(Power)'); xlim([0,45])
h = gca; h.Box = 'off'; h.FontSize = 16;
[~,h_legend] = legend('McGurk /ta/ (Illusory)','McGurk /pa/ (Non-Illusory)');legend('boxoff')
PatchInLegend = findobj(h_legend, 'type', 'patch');
set(PatchInLegend(1), 'Facecolor', [1 0 0],'FaceAlpha', 0.2);
set(PatchInLegend(2), 'Facecolor', [0 0.4470 0.7410],'FaceAlpha', 0.2);
title('(A) Parametrized Power','FontSize', 16)

subplot(1,2,2)
plot_distribution(prestim.freqs_ta, prestim.aperiodic_ta, 'Color', [1 0 0], 'Alpha',0.2); hold on
plot_distribution(prestim.freqs_pa, prestim.aperiodic_pa, 'Color', [0 0.4470 0.7410], 'Alpha', 0.2); 
xlabel('Frequency (in Hz)'); ylabel('log(Power)'); xlim([0,45]);
h = gca; h.Box = 'off'; h.FontSize = 16; 
[~,h_legend] = legend('McGurk /ta/ (Illusory)','McGurk /pa/ (Non-Illusory)'); legend('boxoff')
PatchInLegend = findobj(h_legend, 'type', 'patch');
set(PatchInLegend(1), 'Facecolor', [1 0 0],'FaceAlpha', 0.2);
set(PatchInLegend(2), 'Facecolor', [0 0.4470 0.7410],'FaceAlpha', 0.2);
title('(B) Aperiodic Distribution','FontSize', 16)
sgtitle('Parametrized Power before McGurk trials (Prestimulus)','FontSize',20)


%% Plotting Supplementary Figure 2
figure;
subplot(1,2,1)
plot_distribution(poststim.freqs_ta, poststim.periodic_ta, 'Color', [1 0 0], 'Alpha',0.2); hold on
plot_distribution(poststim.freqs_pa, poststim.periodic_pa, 'Color', [0 0.4470 0.7410], 'Alpha', 0.2); 
xlabel('Frequency (in Hz)'); ylabel('log(Power)'); xlim([0,45]); ylim([-0.2,0.8])
h = gca; h.Box = 'off'; h.FontSize = 16;
[~,h_legend] = legend('McGurk /ta/ (Illusory)','McGurk /pa/ (Non-Illusory)');legend('boxoff')
PatchInLegend = findobj(h_legend, 'type', 'patch');
set(PatchInLegend(1), 'Facecolor', [1 0 0],'FaceAlpha', 0.2);
set(PatchInLegend(2), 'Facecolor', [0 0.4470 0.7410],'FaceAlpha', 0.2);
title('(A) Parametrized Power','FontSize', 16)

subplot(1,2,2)
plot_distribution(poststim.freqs_ta, poststim.aperiodic_ta, 'Color', [1 0 0], 'Alpha',0.2); hold on
plot_distribution(poststim.freqs_pa, poststim.aperiodic_pa, 'Color', [0 0.4470 0.7410], 'Alpha', 0.2); 
xlabel('Frequency (in Hz)'); ylabel('log(Power)'); xlim([0,45]);
h = gca; h.Box = 'off'; h.FontSize = 16; 
[~,h_legend] = legend('McGurk /ta/ (Illusory)','McGurk /pa/ (Non-Illusory)'); legend('boxoff')
PatchInLegend = findobj(h_legend, 'type', 'patch');
set(PatchInLegend(1), 'Facecolor', [1 0 0],'FaceAlpha', 0.2);
set(PatchInLegend(2), 'Facecolor', [0 0.4470 0.7410],'FaceAlpha', 0.2);
title('(B) Aperiodic Distribution','FontSize', 16)
sgtitle('Parametrized Power after McGurk stimulus (Poststimulus)','FontSize',20)
