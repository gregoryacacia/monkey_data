addpath(pwd,'\\10.69.168.1\crnldata\cophy\Mathilde\fieldtrip-20240201'); % directory of the Fieldtrip functions                  
ft_defaults;
load('\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\A1_preprocessing\Preprocessed_data')

% Time frequency analysis
cfg                            = [];
cfg.numcycle_freq              = 3;
cfg.output                     = 'pow';
% cfg.channel                    = 'all';
cfg.keeptrials                1               %do the mean with "no"
cfg.toi                        = 'all';
cfg.padtype                    = 'zero';             % see for applying mirror panning;
cfg.pad                        = 'nextpow2';
cfg.side                       = 1;                  % mirror pading 
cfg.foi                        = data.foi;
% cfg.trials                                           % trials of the condition

% mtmconvol

cfg.method                     = 'mtmconvol';      
cfg.taper                      = 'hanning';
cfg.t_ftimwin                  = cfg.numcycle_freq./cfg.foi;

%superlet
%             cfg.method                     =  'superlet';     
%             cfg.width                      = 3;                           % number of cycles, of the base wavelet (default = 3)
%             cfg.gwidth                     = 3;                           % determines the length of the used wavelets in standard deviations of the implicit Gaussian kernel and should be chosen >= 3
%             cfg.order                      = 3*ones(1,numel(freq));       % vector 1 x numfoi, superlet order, i.e. number of combined wavelets, for individual frequencies of interest.
%             cfg.combine                    = 'additive';

get_TFR(cfg,data)