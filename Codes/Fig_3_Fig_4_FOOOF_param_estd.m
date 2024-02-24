%% Code for extracting periodic (CF,PW,BW) and aperiodic (offset,exponent) parameters channel-wise & trial-wise
% Written by Vinsea AV Singh on August 2023

% ****NOTE****
% This script is to be run before plotting topoplots in python for generating Figure 3 and Figure 4 

%{
  Input: 'power_spec_data.mat' - Power Spectrum Densities of all Participants' illusory (McG ta) and
                                 non-illusory (McG pa) conditions (spec X channel X trials)
                                                                   
  Output: 'fooof_ch_tr.mat' - FOOOFed PSDs of all participants for illusory and non-illusory trials
          'pre_param_ch_tr_wise.mat' - Extracted periodic (CF,PW,BW) and aperiodic 
                                       (offset and exponent) parameters
 
  Toolbox used for estimating power spectrum - 'FOOOF: Fitting Oscillations & One-Over f (MATLAB wrapper)
                                                (Donoghue et al., 2020)

  Function file required -> 'Func_fooof_estm.m' - for parameterizing PSD both channel-wise and 
                                                  trial-wise using FOOOF
                         -> 'Func_fooof_getparams.m' - for extracting periodic (CF,PW,BW) and aperiodic 
                                                       (offset,exponent) parameters of the FOOOFed PSD
               
****DISCLAIMER****
Make sure you have installed pyhton wrapper for MATLAB in your system to run the FOOOF function in MATLAB. 
Check out the following link on how to install python for MATLAB: 
https://irenevigueguix.wordpress.com/2020/03/25/loading-python-into-matlab/
%}

%%%%%%%%%% Either run the section 1 below to estimate parameterized PSD or jump to Section 2 
%to extract estimated periodic and aperiodic parameters  %%%%%%%%%%

%% Section 1: Periodic and Aperiodic Activity Estimation (May take longer than expected to complete)
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
%%%% FOOOF model estimate for the prestimulus McGurk data for all participants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prestimulus
cfg.choice = 'ch_tr';
fooof_prestim_ch_tr = Func_fooof_estm(Power_prestim, cfg); 

% Poststimulus
cfg.choice = 'ch_tr';
fooof_poststim_ch_tr = Func_fooof_estm(Power_poststim, cfg);

save('Data\fooof_ch_tr','fooof_prestim_ch_tr','fooof_poststim_ch_tr')


%% Section 2: Extract periodic (CF,PW,BW) and aperiodic parameters estimated in Section 1 for the prestimulus duration 
% clearvars -except fooof_prestim_ch_tr
% Load the FOOOFed PSD for the prestimulus duration
load('Data\fooof_ch_tr.mat','fooof_prestim_ch_tr')

% Extract stimulus conditions
mcg_ta = fooof_prestim_ch_tr.McG_ta;
mcg_pa = fooof_prestim_ch_tr.McG_pa;

%%%% Extract aperiodic parameters
cfg.choice = 'aperiodic';
[off_ta, off_pa, exp_ta, exp_pa] = Func_fooof_getparams(mcg_ta,mcg_pa,cfg);

%%%% Extract alpha periodic parameters
cfg.choice = 'periodic_alpha';
[cf_ta_alpha, cf_pa_alpha, pw_ta_alpha, pw_pa_alpha,...
    bw_ta_alpha, bw_pa_alpha] = Func_fooof_getparams(mcg_ta,mcg_pa,cfg);

%%%% Extract beta periodic parameters
cfg.choice = 'periodic_beta';
[cf_ta_beta, cf_pa_beta, pw_ta_beta, pw_pa_beta,...
    bw_ta_beta, bw_pa_beta] = Func_fooof_getparams(mcg_ta,mcg_pa,cfg);

save('Data\pre_param_ch_tr_wise','off_ta','exp_ta','off_pa','exp_pa',...
    'cf_ta_alpha','cf_ta_beta','pw_ta_alpha','pw_ta_beta','bw_ta_alpha','bw_ta_beta',...
    'cf_pa_alpha','cf_pa_beta','pw_pa_alpha','pw_pa_beta','bw_pa_alpha','bw_pa_beta')
