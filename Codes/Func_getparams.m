function [CF,PW,BW] = Func_getparams(stim,band)
%{
'Func_fooof_getparams' is a fuction to extract periodic parameters CF,PW,BW at
    alpha (8-12 Hz) and beta (15-30 Hz) frequency bands
    
    Outputs:
    CF - Center Frequency
    PW - Aperiodic Adjusted Power
    BW - Bandwidth

    -------Written by Vinsea AV Singh on August 2023-------
%}

switch band
    case 'alpha'
        idx = find(stim.peak_params(:,1)>=8 & stim.peak_params(:,1)<=12);
        if isempty(idx) == 0
            if size(idx) == 1
                CF = stim.peak_params(idx,1); %Center-Frequency
                PW = stim.peak_params(idx,2); %Aperiodic adjusted power
                BW = stim.peak_params(idx,3); %Bandwidth
            else
                CF = stim.peak_params(min(idx),1);
                PW = stim.peak_params(min(idx),2);
                BW = stim.peak_params(min(idx),3);
            end
       
        else
            CF = NaN;PW = NaN;BW = NaN;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    case 'beta'
        idx = find(stim.peak_params(:,1)>=15 & stim.peak_params(:,1)<=30);
        if isempty(idx) == 0
            if size(idx) == 1
                CF = stim.peak_params(idx,1);
                PW = stim.peak_params(idx,2);
                BW = stim.peak_params(idx,3);
            else
                CF = stim.peak_params(min(idx),1);
                PW = stim.peak_params(min(idx),2);
                BW = stim.peak_params(min(idx),3);
            end
       
        else
            CF = NaN;PW = NaN;BW = NaN;
        end      
end % End of Switch
end %End of Function 


