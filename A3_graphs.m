load('\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\A2_TFR\Time_Frequency_Analysis') % Load data

addpath(pwd,'\\10.69.168.1\crnldata\cophy\Mathilde\fieldtrip-20240201'); % directory of the Fieldtrip functions                  
ft_defaults;

savdir = '\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\A3_graphs'; % directory where to save the graphs

% Plot with imageSC

tfr.powspctrm(isnan(tfr.powspctrm)) = 1;
% Avg_Name(isnan(Avg_Name))         = 1;
foi                               = [7 60];
toi                               = [-0.2 0.6];
toib                              = [-0.2 -0.1];

indexf                            = dsearchn(tfr.freq', foi(1)):dsearchn(tfr.freq',foi(2));
indext                            = dsearchn(tfr.time', toi(1)):dsearchn(tfr.time',toi(2));

indextb                           = dsearchn(tfr.time', toib(1)):dsearchn(tfr.time',toib(2));

time                              = tfr.time(indext);
freq                              = tfr.freq(indexf);
%figure % contrast



figure % Name
for j = 1:length(tfr.label) % or numel ?
    clims = [0.001 1]; % color interval
    subplot(4,5,j)
    baseline = repmat(mean(tfr(j,indexf,indextb),3),[1 1 numel(indext)]); % problem with this line
    imagesc(time, freq, (squeeze(mean(tfr.powspctrm(j,indexf,indext))-baseline))',clims)
    set(gca,'YDir','normal')
    colormap('jet')
    colorbar
    axis xy
    title(tfr.label{j})
end

% figure % Name
% for j = 1:numel(tfr1.label)
%     % good position ?
%     clims = [0.001 1]; % color interval
%     %subplot(1,2,j)
%     mean_val=mean(tfr.powspctrm,2);
%     imagesc(mean_val(j,1,:),clims)
%     colormap('jet')
%     colorbar
%     axis xy
%     title(tfr.label{j})
% end


% Distribution graphs

% tfr.powspctrm_values = tfr.powspctrm(:,:,229:381); % select only the time points without NaN
% tfr.pow_average = mean(tfr.powspctrm_values,3); % average power in time
% channel_data = tfr.pow_average(1, :);  % Select data for the first channel
% 
% figure('Visible','off')
% plot(channel_data,tfr.freq);
% xlabel('Power');
% ylabel('Frequencies');
% title('Frequency as a function of power for the 1st channel');
% 
% figname = fullfile(savdir, 'Frequency as a function of power for the 1st channel.png'); % specify the full file path and name
% saveas(gcf, figname);
% 
% % Plot with Fieldtrip
% 
% figure;
% for i=1:length(tfr.label)
%     cfg=[];
%     cfg.channel = tfr.label{i};
%     cfg.baselinetype    = 'absolute';
%     cfg.baseline        = [-0.1 0];
%     cfg.zlim    = [0.001 1];
%     cfg.xlim    = [-0.2 0.6];
%     cfg.ylim    = [5 30];
%     %subplot(2,2,i);
%     ft_singleplotTFR(cfg,tfr);
% end


% figure;
% cfg=[];
% cfg.channel = tfr.label{1};
% cfg.baselinetype    = 'absolute';
% cfg.baseline        = [-0.1 0];
% cfg.zlim    = [-1 1];
% cfg.xlim    = [0 0.4];
% cfg.ylim    = [5 30];   
% ft_singleplotTFR(cfg,tfr);
