function [fooof_params] = Func_fooof_estm(stim,cfg)
%{
    Function script to estimate periodic and aperiodic activity using FOOOF
    algorithm developed by Donoghue & Voytek, 2020

    -------Written by Vinsea AV Singh on July 2023-------
%}

%%%%----Participant-wise seperating periodic and aperiodic component (channel-wise and trial-wise)----%%%%
choice = cfg.choice;

% Extract PSDs of illusory and non-illusory McGurk trials
for i = 1:size(stim,1)
    mcg_ta{i} = stim{i}.McG_ta; %Illusory
    mcg_pa{i} = stim{i}.McG_pa; %Non-illusory
end

switch choice
    case 'channel_avg' % Channel averaged
        %%%% McGurk /ta/ (Illusory)
        settings = struct();
        f_range = [0.1 45];
        for prt = 1:18
            fprintf('\nApplying FOOOF on McGurk /ta/ PSD of participant %s ...',prt);
            prtpnt = mcg_ta{prt};
            chavg = squeeze(mean(prtpnt.S,2));
            chavg(~any(chavg,2),:) = [];  %rows
            chavg(:,~any(chavg,1)) = [];  %columns
            for tr = 1:(size(chavg,2))
                S_tr = chavg(:,tr);
                f_tr = prtpnt.f;
                fooof_results{tr} = fooof(f_tr, S_tr, f_range, settings, true);     
            end
            fooof_prpnt{prt} = fooof_results;
            fprintf('Done.\n');
        end
        fooof_params.McG_ta = fooof_prpnt;
        clear fooof_prpnt fooof_results prtpnt
        
        %%%% McGurk /pa/ (Non-Illusory)
        settings = struct();
        f_range = [0.1 45];
        for prt = 2:length(mcg_pa) % 1st partcipant's data empty
            fprintf('\nApplying FOOOF on McGurk /pa/ PSD of participant %s ...',prt);
            prtpnt = mcg_pa{prt};
            chavg = squeeze(mean(prtpnt.S,2));
            chavg(~any(chavg,2),:) = [];  %rows
            chavg(:,~any(chavg,1)) = [];  %columns
            for tr = 1:(size(chavg,2))
                S_tr = chavg(:,tr);
                f_tr = prtpnt.f;
                fooof_results{tr} = fooof(f_tr, S_tr, f_range, settings, true);     
            end
            fooof_prpnt{prt} = fooof_results;
            fprintf('Done.\n');
        end
        fooof_params.McG_pa = fooof_prpnt;
        clear fooof_prpnt fooof_results prtpnt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'ch_tr'
    %%%% McGurk /ta/ (Illusory)
    settings = struct(); %default fooof settings
    f_range = [0.1 45];  %Frequency range
    for prt = 1:length(stim)
        fprintf('\nApplying FOOOF on McGurk /ta/ PSD of participant %s ...',prt);
        prtpnt = mcg_ta{prt};
        for ch = 1:size(prtpnt.S,2)   
            for tr = 1:size(prtpnt.S,3)
                S_tr = prtpnt.S(:,ch,tr);
                f_tr = prtpnt.f;
                fooof_tr_results{tr} = fooof(f_tr, S_tr, f_range, settings, true);     
            end
            fooof_ch_results{ch} = fooof_tr_results;
        end
        fooof_prpnt{prt} = fooof_ch_results;
        fprintf('Done.\n');
    end
    fooof_params.McG_ta = fooof_prpnt;
    clear fooof_tr_results fooof_ch_results fooof_prpnt

    %%%% McGurk /pa/ (Non-Illusory)
    settings = struct(); %default fooof settings
    f_range = [0.1 45];
    for prt = 1:length(stim)
        fprintf('\nApplying FOOOF on McGurk /ta/ PSD of participant %s ...',prt);
        if prt ~= 1
            prtpnt = mcg_pa{prt};
            for ch = 1:size(prtpnt.S,2)   
                for tr = 1:size(prtpnt.S,3)
                    S_tr = prtpnt.S(:,ch,tr);
                    f_tr = prtpnt.f;
                    fooof_tr_results{tr} = fooof(f_tr, S_tr, f_range, settings, true);     
                end
                fooof_ch_results{ch} = fooof_tr_results;
            end
            fooof_prpnt{prt} = fooof_ch_results;
        else
            continue 
        end
        fprintf('Done.\n');
    end
    fooof_params.McG_pa = fooof_prpnt;
    clear fooof_tr_results fooof_ch_results fooof_prpnt
end
end %End of the function

