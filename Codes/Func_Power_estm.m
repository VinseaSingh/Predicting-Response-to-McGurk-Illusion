function [PowerSpec] = Func_Power_estm(preproc_data, params, cfg)
%{
    Function script to estimate power spectral densities (PSD) using multi-taper spectrum function
    'mtspectrumc' of the 'Chronux' toolbox

    -------Written by Vinsea AV Singh on June 2023-------
%}

%%%% Participant-wise power spectral analysis %%%%
choice = cfg.choice;

Sub_len = length(preproc_data);       % number of subjects
trnum_ta  = zeros(Sub_len,1);         % stores the NUMBER of /ta/ trials of each subject
trnum_pa  = zeros(Sub_len,1);         % stores the NUMBER of /pa/ trials of each subject

for sub = 1: length(preproc_data)
    trnum_ta(sub) = size(preproc_data{sub}.Prestim.McG_ta,3);
    trnum_pa(sub) = size(preproc_data{sub}.Prestim.McG_pa,3);
end

ta_tr = [];
pa_tr = [];
switch choice
    case 'Prestim'
        for i = 1:length(preproc_data)
            ta_tr{i} = preproc_data{i}.Prestim.McG_ta;
            pa_tr{i} = preproc_data{i}.Prestim.McG_pa;
        end
        
    case 'Poststim'
        for i = 1:length(preproc_data)
            ta_tr{i} = preproc_data{i}.Poststim.McG_ta(350:1150,:,:);
            if isempty(preproc_data{i}.Poststim.McG_pa) == 0
                pa_tr{i} = preproc_data{i}.Poststim.McG_pa(350:1150,:,:);
            else
                pa_tr{i} = [];
            end
        end
end

%% Computing the power spectrum
%%%%%% McGurk /ta/
fprintf('\nComputing PSD for %s McGurk /ta/ (illusory) trials...',choice);

S_mcg_ta = []; f_mcg_ta = [];
for i = 1:length(preproc_data)
   for ch = 1:size(ta_tr{i},2)
       for j = 1:size(ta_tr{i},3)
          [S_mcg_ta(:,ch,j), f_mcg_ta] = mtspectrumc(ta_tr{i}(:,ch,j), params);            
       end        
   end
    S_mcg_ta(isinf(S_mcg_ta) | isnan(S_mcg_ta)) = 0;
    Prpnt{i}.McG_ta.S = S_mcg_ta;
    Prpnt{i}.McG_ta.f = f_mcg_ta;
end
clear i ch j
fprintf('Done.\n');

%%%%%% McGurk /pa/
fprintf('\nComputing PSD for %s McGurk /pa/ (illusory) trials...',choice);

S_mcg_pa = []; f_mcg_pa = [];
for i = 1:length(preproc_data)
   for ch = 1:size(pa_tr{i},2)
       for j = 1:size(pa_tr{i},3)
           [S_mcg_pa(:,ch,j), f_mcg_pa] = mtspectrumc(pa_tr{i}(:,ch,j), params);  
       end        
   end
    S_mcg_pa(isinf(S_mcg_pa) | isnan(S_mcg_pa)) = 0;
    Prpnt{i}.McG_pa.S = S_mcg_pa;
    Prpnt{i}.McG_pa.f = f_mcg_pa;
end
clear i ch j 
fprintf('Done.\n');

PowerSpec = Prpnt;
        
end