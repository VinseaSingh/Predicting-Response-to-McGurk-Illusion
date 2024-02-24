function [dist] = Func_fooof_getdistrib(stim)
%{
    Function script to extract periodic and aperiodic distributions for
    Prestimulus (Figure 2) & Poststimulus (Supplementary Figure 2)
    durations

    -------Written by Vinsea AV Singh on July 2023-------
%}
%%%%--Participant-wise extracting periodic and aperiodic distribution (channel & trial average)--%%%%
%%%% Extracting periodic and aperiodic distrubutions

pnt_periodic_ta = []; pnt_aperiodic_ta = []; pnt_freqs_ta = [];
pnt_periodic_pa = []; pnt_aperiodic_pa = []; pnt_freqs_pa = [];

for prt = 1:length(stim.McG_ta)
    % McG /ta/
    mcg_ta = stim.McG_ta{prt};
    periodic_ta = []; aperiodic_ta = []; freqs_ta =[];
    for tr = 1:length(mcg_ta)
        % Periodic oscillations
        spec_ta = mcg_ta{tr}.power_spectrum - mcg_ta{tr}.ap_fit;
        periodic_ta = cat(1,periodic_ta,spec_ta);
        
        % Aperiodic distributions
        ap_ta = mcg_ta{tr}.ap_fit;
        aperiodic_ta = cat(1,aperiodic_ta,ap_ta);
        
        % Frequencies
        fq_ta = mcg_ta{tr}.freqs;
        freqs_ta = cat(1,freqs_ta,fq_ta);
    end
    periodic_avg_ta = mean(periodic_ta,1);
    pnt_periodic_ta = cat(1,pnt_periodic_ta,periodic_avg_ta);
    
    aperiodic_avg_ta = mean(aperiodic_ta,1);
    pnt_aperiodic_ta = cat(1,pnt_aperiodic_ta,aperiodic_avg_ta);
    
    freqs_avg_ta = mean(freqs_ta,1);
    pnt_freqs_ta = cat(1,pnt_freqs_ta, freqs_avg_ta);
    clear periodic_ta aperiodic_ta freqs_ta 
   
    % McG /pa/
    if prt ~= 1
        mcg_pa = stim.McG_pa{prt};
        periodic_pa = []; aperiodic_pa = []; freqs_pa =[];
        for tr = 1:length(mcg_pa)
            % Periodic oscillations
            spec_pa = mcg_pa{tr}.power_spectrum - mcg_pa{tr}.ap_fit;
            periodic_pa = cat(1,periodic_pa,spec_pa);
            
            % Aperiodic distributions
            ap_pa = mcg_pa{tr}.ap_fit;
            aperiodic_pa = cat(1,aperiodic_pa,ap_pa);
            
            % Frequencies
            fq_pa = mcg_pa{tr}.freqs;
            freqs_pa = cat(1,freqs_pa,fq_pa);
        end
        periodic_avg_pa = mean(periodic_pa,1);
        pnt_periodic_pa = cat(1,pnt_periodic_pa,periodic_avg_pa);
        
        aperiodic_avg_pa = mean(aperiodic_pa,1);
        pnt_aperiodic_pa = cat(1,pnt_aperiodic_pa,aperiodic_avg_pa);
        
        freqs_avg_pa = mean(freqs_pa,1);
        pnt_freqs_pa = cat(1,pnt_freqs_pa, freqs_avg_pa);
        clear periodic_pa aperiodic_pa freqs_pa
        
    end % End of if statement
end % End of for loop

% Store all the extracted distributions in a struct variable 'dist'
dist.periodic_ta = pnt_periodic_ta;
dist.aperiodic_ta = pnt_aperiodic_ta;
dist.periodic_pa = pnt_periodic_pa;
dist.aperiodic_pa = pnt_aperiodic_pa;
dist.freqs_ta = mean(pnt_freqs_ta,1);
dist.freqs_pa = mean(pnt_freqs_pa,1);

end % End of the function

