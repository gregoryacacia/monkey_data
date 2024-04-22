function get_TFR(cfg,data)

addpath(pwd,'\\10.69.168.1\crnldata\cophy\Mathilde\fieldtrip-20240201'); % directory of the Fieldtrip functions                  
ft_defaults;
load('\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\A1_preprocessing\Preprocessed_data')

cfg.foi = data.foi;

% Preprocess, to solve problem of NaN due to number of cycle

% if isfield(cfg,'side')
%     cfg.side            = cfg.side*data.fsample;
%     time_step           = 1/data.fsample;  
%     data.trial          = cellfun(@(x,y) horzcat(fliplr(x(:,1:cfg.side)), x, fliplr(x(:,end-(cfg.side-1):end))), data.trial,'UniformOutput', false);
%     data.time           = cellfun(@(x,y) [x(1)-(time_step*cfg.side):time_step:x(1)-time_step x x(end)+time_step:time_step:x(end)+(time_step*cfg.side)], data.time,'UniformOutput', false);
% end

tfr = ft_freqanalysis(cfg,data);
tfr.powspctrm = log(tfr.powspctrm);
tfr.foi=cfg.foi;

%eval(sprintf('%s%s%s;', 'TFR_', namecond{icond}, '= tfr'))
%Dif_cond(:,:,:,jj) = tfr.powspctrm;
%AChnV1Temp(:,:,:,jj) =  permute(,[2,3,1]);
%EnvV1Temp(:,:,jj) = mean(ENV(:,V1,trlsel),3);


%Do it for all condition (jj)
%replace in old order freq*time*ch
%AChnV1Temp(:,:,:,jj) = permute(tfr.powspctrm, [2, 3, 1]);

% cd '\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\V1_old-preprocess\output' % Saving
% 
% if JB == 1
%     F.AChnV1 = AChnV1Temp;
%     F.Label = selectedLabels;
%     F.sampf = sampf;
%     F.day=n;
%     F.Task=Task;
%     FJ=F;
%     filename = sprintf('WAVE_FG_Sweep_Josef_CSD_JS%d_n%d.mat', JF, n);
%     save(filename, 'FJ');
% elseif JB == 2
%     F.AChnV1 = AChnV1Temp;
%     F.Label = selectedLabels;
%     F.sampf = sampf;
%     F.days=n;
%     F.Task=Task;
%     FB=F;
%     filename = sprintf('WAVE_FG_Sweep_Bobo_CSD_JB%d_n%d.mat', JB, n);
%     save(filename, 'FB');
% end

%         end
%     end
% end

% Saving the tfr structure
%Ffull = struct();
%Ffull.AChnV1 = zeros(size(data1.FJ.AChnV1));




% directory = '\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\V1_old-preprocess\output';
% filenamePattern = 'WAVE_FG_Sweep_Josef_CSD_JB1_n*.mat';
% files = dir(fullfile(directory, filenamePattern));
% 
% F_Labels = cell(numel(files), 2);
% F_Tasks = cell(numel(files), 2);
% 
% for i = 1:numel(files)
%     
%     filepath = fullfile(directory, files(i).name);
%    
%     data = load(filepath);
%     
%     F_Labels{i, 1} = data.F.Label;
%     F_Labels{i, 2} = filepath;
% end

% path 
% files_group0 = {'\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\V1_old-preprocess\output\WAVE_FG_Sweep_Bobo_CSD_JB2_n1.mat', ...
%                 '\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\V1_old-preprocess\output\WAVE_FG_Sweep_Bobo_CSD_JB2_n4.mat', ...
%                 '\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\V1_old-preprocess\output\WAVE_FG_Sweep_Bobo_CSD_JB2_n5.mat'};
%             
% files_group1 = {'\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\V1_old-preprocess\output\WAVE_FG_Sweep_Bobo_CSD_JB2_n2.mat', ...
%                 '\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\V1_old-preprocess\output\WAVE_FG_Sweep_Bobo_CSD_JB2_n3.mat', ...
%                 '\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\V1_old-preprocess\output\WAVE_FG_Sweep_Bobo_CSD_JB2_n6.mat'};
%             
% 
% data_group0 = cell(numel(files_group0), 1);
% data_group1 = cell(numel(files_group1), 1);
% 
% for i = 1:numel(files_group0)
%     data_group0{i} = load(files_group0{i});
% end
% 
% for i = 1:numel(files_group1)
%     data_group1{i} = load(files_group1{i});
% end
% 
% 
% average_group0 = zeros(size(data_group0{1}.FB.AChnV1));
% average_group1 = zeros(size(data_group1{1}.FB.AChnV1));
% 
% for i = 1:numel(data_group0)
%     average_group0 = average_group0 + data_group1{i}.FB.AChnV1;
% end
% average_group0 = average_group0 / numel(data_group0);
% 
% for i = 1:numel(data_group1)
%     average_group1 = average_group1 + data_group1{i}.FB.AChnV1;
% end
% average_group1 = average_group1 / numel(data_group1);
% 
% 
% new_matrix = zeros(size(average_group0, 1), size(average_group0, 2), size(average_group0, 3), size(average_group0, 4), 2);
% new_matrix(:,:,:,:,1) = average_group0;
% new_matrix(:,:,:,:,2) = average_group1;
% 
% 
% save('\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\V1_old-preprocess\output\average_data_V1_Bobo.mat', 'new_matrix');

savdir = '\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\A2_TFR';
filename = 'Time_Frequency_Analysis.mat';
fullFileName = fullfile(savdir, filename);
save(fullFileName, 'tfr');