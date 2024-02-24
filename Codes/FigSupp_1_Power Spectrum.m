%% Code for generating Supplementary Figure 1
% Written by Vinsea AV Singh on June 2023
%{
  Input: 'preproc_data.mat'  - a struct file of preprocessed and epoched EEG time-series data for McGurk /ta/ and
                               McGurk /pa/ response conditions for all 18 participants. 
                               The data is a 3D matrix (datapoints x channels x trials).  
                                                                   
   Output: 'Power_prestim' - Power spectrum for all subjects of prestimulus duration
           'Power_poststim' - Power spectrum for all subjects of poststimulus duration

   Toolbox used for estimating power spectrum - 'Chronux: a platform for analyzing neural signals (Bokil H, et al.,2010)'
                                                   (http://chronux.org/)
                                              - 'Shaded Plots and Statistical Distribution Visualizations'
(https://www.mathworks.com/matlabcentral/fileexchange/69203-shaded-plots-and-statistical-distribution-visualizations), 
                                                MATLAB Central File Exchange. Retrieved December 1, 2023.
   Function file required -> 'Func_Power_estm.m' - for computing power spectrum 
                           
%}
%%%%%%%%%% Either run the sections below to estimate PSD or jump to the last section to load estimated PSD
% values for plotting Supplementary Figure 1 %%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 1: PSD estimation
%%-----------------------------------------Power spectrum analysis (PSD)----------------------------------------%%
%%%% Add 'Chronux' toolbox in MATLAB path
clear; clc
restoredefaultpath
addpath(genpath('Toolboxes\chronux_2_12'))

%%%% Load preprocessed EEG time-series data
load('Data\preproc_data.mat')
% clearvars -except preproc_data

%%%% PSD analysis for the prestimulus McGurk data
% The parameters
params.Fs = 1000;
params.tapers=[3 5];
params.pad = 0;
params.fpass = [0.1 45]; 

% Calculating PSD
cfg.choice = 'Prestim';
Power_prestim = Func_Power_estm(preproc_data, params, cfg);

%%%% PSD analysis for the poststimulus McGurk data
% The parameters
params.Fs = 1000;
params.tapers=[3 5];
params.pad = 0;
params.fpass = [0.1 45]; 

% Calculating PSD
cfg.choice = 'Poststim';
Power_poststim = Func_Power_estm(preproc_data, params, cfg);

% Tranform the data
Power_prestim = Power_prestim';
Power_poststim = Power_poststim';

% Save the data as a struct file
save('Data\power_spec_data','Power_prestim','Power_poststim','-v7.3')


%% Section 2: Plotting PSD for all the participants
% Either run the above sections to estimate PSD or load estimated PSD
% values for plotting Supplementary Figure 1
load('Data\power_spec_data.mat')

% Add shaded_plots toolbox for plotting
addpath('Toolboxes\shaded_plots')

% Extract data from the struct file
%%%% Prestimulus activity
S_mcg_ta_pre = []; f_mcg_ta_pre = [];
S_mcg_pa_pre = []; f_mcg_pa_pre = [];
for i = 1:length(Power_prestim)
    % McGurk /ta/
    S_ta = log10(mean(mean(Power_prestim{i}.McG_ta.S,2),3));
    S_mcg_ta_pre = cat(2, S_mcg_ta_pre, S_ta);
    f_mcg_ta_pre = cat(1, f_mcg_ta_pre, Power_prestim{i}.McG_ta.f);
    
    % McGurk /pa/
    if isempty(Power_prestim{i}.McG_pa.S) == 0
        S_pa = log10(mean(mean(Power_prestim{i}.McG_pa.S,2),3));
        S_mcg_pa_pre = cat(2, S_mcg_pa_pre, S_pa);
        f_mcg_pa_pre = cat(1, f_mcg_pa_pre, Power_prestim{i}.McG_pa.f);
    end
end

%%%% Poststimulus activity
S_mcg_ta = []; f_mcg_ta = [];
S_mcg_pa = []; f_mcg_pa = [];
for i = 1:length(Power_poststim)
    % McGurk /ta/
    S_ta = log10(mean(mean(Power_poststim{i}.McG_ta.S,2),3));
    S_mcg_ta = cat(2, S_mcg_ta, S_ta);
    f_mcg_ta = cat(1, f_mcg_ta, Power_poststim{i}.McG_ta.f);
    
    % McGurk /pa/
    if isempty(Power_poststim{i}.McG_pa.S) == 0
        S_pa = log10(mean(mean(Power_poststim{i}.McG_pa.S,2),3));
        S_mcg_pa = cat(2, S_mcg_pa, S_pa);
        f_mcg_pa = cat(1, f_mcg_pa, Power_poststim{i}.McG_pa.f);
    end
end

%%%% Plot
figure;
subplot(1,2,1) % Prestimulus
plot_distribution(mean(f_mcg_ta_pre,1), S_mcg_ta_pre', 'Color', [1 0 0], 'Alpha',0.2); hold on
plot_distribution(mean(f_mcg_pa_pre,1), S_mcg_pa_pre', 'Color', [0 0.4470 0.7410], 'Alpha', 0.2); hold on
xlabel('Frequency (in Hz)'); ylabel('Power'); xlim([0,45]); ylim([-2,1.5])
h = gca; h.Box = 'off'; h.FontSize = 16; 
title('Prestimulus McGurk','FontSize', 16)

subplot(1,2,2) % Poststimulus
plot_distribution(mean(f_mcg_ta,1), S_mcg_ta', 'Color', [1 0 0], 'Alpha',0.2); hold on
plot_distribution(mean(f_mcg_pa,1), S_mcg_pa', 'Color', [0 0.4470 0.7410], 'Alpha', 0.2);
xlabel('Frequency (in Hz)'); ylabel('Power'); ylim([-2,1.5]); xlim([0,45]); ylim([-2,1.5])
h = gca; h.Box = 'off'; h.FontSize = 16; 
[~,h_legend] = legend('McGurk /ta/ (Illusory)','McGurk /pa/ (Non-Illusory)');legend('boxoff')
PatchInLegend = findobj(h_legend, 'type', 'patch');
set(PatchInLegend(1), 'Facecolor', [1 0 0],'FaceAlpha', 0.2);
set(PatchInLegend(2), 'Facecolor', [0 0.4470 0.7410],'FaceAlpha', 0.2);
title('Poststimulus McGurk','FontSize', 16)
sgtitle('Power Spectrum Densities (PSDs)','FontSize',25)
