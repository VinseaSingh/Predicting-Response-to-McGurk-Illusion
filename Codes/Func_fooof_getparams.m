function [varargout] = Func_fooof_getparams(mcg_ta,mcg_pa,cfg)
%{
    'Func_fooof_getparams' is a fuction to extract periodic parameters (CF,PW,BW) at alpha (8-12 Hz) 
    and beta (15-30 Hz) frequency bands and aperiodic parameters (offset, exponent)

    -------Written by Vinsea AV Singh on August 2023-------
%}

% Extract the parameters 
o_ta = []; o_pa = []; % Aperiodic Offset 
e_ta = []; e_pa = []; % Aperiodic Exponent
c_ta_alpha = []; c_ta_beta = []; % Periodic CF
c_pa_alpha = []; c_pa_beta = []; 
p_ta_alpha = []; p_ta_beta = []; % Periodic PW
p_pa_alpha = []; p_pa_beta = [];
b_ta_alpha = []; b_ta_beta = []; % Periodic BW
b_pa_alpha = []; b_pa_beta = []; 

for prt = 1:length(mcg_ta)
    off_ta_epoch = []; off_pa_epoch = [];
    exp_ta_epoch = []; exp_pa_epoch = [];
    cf_ta_alpha = []; cf_ta_beta = []; 
    cf_pa_alpha = []; cf_pa_beta = []; 
    pw_ta_alpha = []; pw_ta_beta = []; 
    pw_pa_alpha = []; pw_pa_beta = []; 
    bw_ta_alpha = []; bw_ta_beta = [];
    bw_pa_alpha = []; bw_pa_beta = [];
    
    % McG /ta/
    ta = mcg_ta{prt};
    for ch = 1:length(ta)
        ta_ch = ta{ch};
        for tr = 1:length(ta_ch)
            off_ta(tr) = ta_ch{tr}.aperiodic_params(1);
            exp_ta(tr) = ta_ch{tr}.aperiodic_params(2);
            [cf_alpha(tr),pw_alpha(tr),bw_alpha(tr)] = Func_getparams(ta_ch{tr}, 'alpha');
            [cf_beta(tr),pw_beta(tr),bw_beta(tr)] = Func_getparams(ta_ch{tr}, 'beta');  
        end 
        off_ta_epoch = cat(1,off_ta_epoch,off_ta); exp_ta_epoch = cat(1,exp_ta_epoch,exp_ta);
        cf_ta_alpha = cat(1,cf_ta_alpha,cf_alpha); pw_ta_alpha = cat(1,pw_ta_alpha,pw_alpha); 
        bw_ta_alpha = cat(1,bw_ta_alpha,bw_alpha);
        cf_ta_beta = cat(1,cf_ta_beta,cf_beta); pw_ta_beta = cat(1,pw_ta_beta,pw_beta); 
        bw_ta_beta = cat(1,bw_ta_beta,bw_beta);
    end
    o_ta = cat(2,o_ta,off_ta_epoch); e_ta = cat(2,e_ta,exp_ta_epoch);
    c_ta_alpha = cat(2,c_ta_alpha,cf_ta_alpha); p_ta_alpha = cat(2,p_ta_alpha,pw_ta_alpha); 
    b_ta_alpha = cat(2,b_ta_alpha,bw_ta_alpha);
    c_ta_beta = cat(2,c_ta_beta,cf_ta_beta); p_ta_beta = cat(2,p_ta_beta,pw_ta_beta); 
    b_ta_beta = cat(2,b_ta_beta,bw_ta_beta);
    
    clear off_ta off_ta_epoch exp_ta exp_ta_epoch tr ch 
    clear cf_alpha pw_alpha bw_alpha
    clear cf_beta pw_beta bw_beta
    clear cf_ta_alpha pw_ta_alpha bw_ta_alpha
    clear cf_ta_beta pw_ta_beta bw_ta_beta

    % McG /pa/
    if prt ~= 1
        pa = mcg_pa{prt};
        for ch = 1:length(pa)
            pa_ch = pa{ch};
            for tr = 1:length(pa_ch)
                off_pa(tr) = pa_ch{tr}.aperiodic_params(1);
                exp_pa(tr) = pa_ch{tr}.aperiodic_params(2);
                [cf_alpha(tr),pw_alpha(tr),bw_alpha(tr)] = Func_getparams(pa_ch{tr}, 'alpha');
                [cf_beta(tr),pw_beta(tr),bw_beta(tr)] = Func_getparams(pa_ch{tr}, 'beta');        
            end
            off_pa_epoch = cat(1,off_pa_epoch,off_pa); exp_pa_epoch = cat(1,exp_pa_epoch,exp_pa);
            cf_pa_alpha = cat(1,cf_pa_alpha,cf_alpha); pw_pa_alpha = cat(1,pw_pa_alpha,pw_alpha); 
            bw_pa_alpha = cat(1,bw_pa_alpha,bw_alpha);
            cf_pa_beta = cat(1,cf_pa_beta,cf_beta); pw_pa_beta = cat(1,pw_pa_beta,pw_beta); 
            bw_pa_beta = cat(1,bw_pa_beta,bw_beta);
        end
        o_pa = cat(2,o_pa,off_pa_epoch); e_pa = cat(2,e_pa,exp_pa_epoch);
        c_pa_alpha = cat(2,c_pa_alpha,cf_pa_alpha); p_pa_alpha = cat(2,p_pa_alpha,pw_pa_alpha); 
        b_pa_alpha = cat(2,b_pa_alpha,bw_pa_alpha);
        c_pa_beta = cat(2,c_pa_beta,cf_pa_beta); p_pa_beta = cat(2,p_pa_beta,pw_pa_beta); 
        b_pa_beta = cat(2,b_pa_beta,bw_pa_beta); 
        
        clear off_pa off_pa_epoch exp_pa exp_pa_epoch tr ch 
        clear cf_alpha pw_alpha bw_alpha
        clear cf_beta pw_beta bw_beta
        clear cf_pa_alpha pw_pa_alpha bw_pa_alpha
        clear cf_pa_beta pw_pa_beta bw_pa_beta
    else
        continue
    end % End of if statement  
end % End of for loop

%%%% Store all the extracted parameters in a struct variable 'varargout'
choice = cfg.choice;

% Number of output arguments requested
numOutputs = nargout;

% Assign the outputs based on the number of output arguments
varargout = cell(1, numOutputs);
switch choice
    case 'aperiodic'
        varargout{1} = o_ta; varargout{2} = o_pa; %Offset
        varargout{3} = e_ta; varargout{4} = e_pa; %Exponent
        
    case 'periodic_alpha'
        varargout{1} = c_ta_alpha; varargout{2} = c_pa_alpha;   %CF alpha
        varargout{3} = p_ta_alpha; varargout{4} = p_pa_alpha;   %PW alpha
        varargout{5} = b_ta_alpha; varargout{6} = b_pa_alpha;   %BW alpha
        
    case 'periodic_beta'
        varargout{1} = c_ta_beta; varargout{2} = c_pa_beta;     %Cf beta
        varargout{3} = p_ta_beta; varargout{4} = p_pa_beta;     %PW beta
        varargout{5} = b_ta_beta; varargout{6} = b_pa_beta;     %BW beta   
end %End of switch

end % End of the function
