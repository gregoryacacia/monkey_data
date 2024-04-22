function get_preprocessing(cfg,sessioninfo,dummy)

%Josef & Bobo data analysis
foi = cfg.foi;

for n=1:size(sessioninfo,1)                                                                         % for every id % 1
    disp(['Session = ', num2str(n)]);                                                               % display session number
    clear handles;                                                                                  % clear handles                           

    sdir = '\\10.69.168.1\cophy\Mathilde\Danila\MonkeyData\V1-V4\rawdata\';                         % directory where raw data is located

    name = sprintf('%s%s.mat',sdir,sessioninfo{n,1});                                               % name of the file to load it
    load(name,'cfg','idinf','handles','SIG','SIGLFP','SIGEYE','TIMEYE','sel','EYEDATA','condpool','t','datalabel','EVENT');

    name = sprintf('%s%s_D2.mat',sdir,sessioninfo{n,1});                                            % name of the file to load it
    load(name,'STRAT','PSTH');                                                                      % load STRAT and PSTH contained in D2 file

    sampf = EVENT.strms.Envl.sampf;                                                                 % sampling frequency = why 762.9395?                  

    handles.data.PSTH.timebsl = [-100,0];                                                           % set baseline time                
    handles.data.PSTH.timestm = [0,100];                                                            % set stimulus time
    handles.data.PSTH.norm    = 1;                                                                  % if need normalization

    rng_b=handles.data.PSTH.timebsl./1000; rng_bsl=find(t>rng_b(1) & t<rng_b(2));                   % convert in seconds + find indices of baseline in t
    rng_s=handles.data.PSTH.timestm./1000; rng_stm=find(t>rng_s(1) & t<rng_s(2));                   % convert in seconds + find indices of stimulus in t
    nsmp = round(EVENT.strms.(EVENT.Myevent).sampf*0.025); if mod(nsmp,2)==0, nsmp = nsmp + 1; end  % sampf*0.025 rounded + be sure that nsmp is odd number. Why?

    % make single PSTH: see if responses ok
    sbsl = std(mean(SIG(rng_bsl,:,:)),1,3);                                                         % mean over time, std over trials
    mbsl = mean(mean(SIG(rng_bsl,:,:)),3);                                                          % mean over time, mean over trials
    PSTHt = mean(SIG,3);

    nmax = max(PSTHt(rng_stm,:));
    VISRESP = (nmax-mbsl)./sbsl;                                                                    % mean peak divided by std bsl
    VRcrt   = 1;
    chnbad = find(VISRESP<3);

    V1orV4([strmatch('pb',datalabel);strmatch('ar',datalabel);strmatch('cd',datalabel)])=1;         % V1 channels
    V1orV4([strmatch('pa',datalabel);strmatch('by',datalabel);strmatch('br',datalabel)])=2;         % V4 channels
    chnbad = find(~ismember([1:length(datalabel)],sessioninfo{n,5}));
    V1orV4andOK=V1orV4;                                                                             % 25-32 bad channels?
    V1orV4andOK(chnbad)=0;                                                                          % V1-V4 and ok channel index
    xaxislabel=cell(length(STRAT),1);

    for j=1:length(STRAT)                                                                           % find labels in STRAT cell
        if STRAT{1,j}.label
            xaxislabel{j}=STRAT{1,j}.label;
        else
            xaxislabel{j}='empty';
        end
    end

    for j=1:length(datalabel)                                                                       % match channels to STRAT structure
        if isempty(strmatch(datalabel(j),xaxislabel))
           V1orV4andOK(j)=0;
        end
    end

    ChInd_V1=find(V1orV4andOK==1);                                                                  %V1 and ok channel index V1orV4andOK==1 ismember(V1orV4andOK1
    ChInd_V4=find(V1orV4andOK==2);                                                                  %V4 and ok channel index

    V1=1:length(ChInd_V1);

    xaxispositionV1=zeros(length(ChInd_V1),1);

    for j=1:length(ChInd_V1)                                                                        % match channels to STRAT structure            
        dum =strmatch(datalabel(ChInd_V1(j)),xaxislabel);
        xaxispositionV1(j)= dum(1);
    end

    SIG=SIG-repmat(mean(mean(SIG(rng_bsl,:,:)),3),[size(SIG,1) 1 size(SIG,3)]);                     %baseline correction
    SIG=SIG./repmat(max(mean(SIG(rng_stm,:,:),3)),[size(SIG,1) 1 size(SIG,3)]);                     %normalisation
    ENV=SIG(:,ChInd_V1,:);

    RDS=SIGLFP(:,ChInd_V1,:);
    NSmpl = size(RDS,1);                                                                            %freq/samp 
    NCh = size(RDS,2);                                                                              %channels
    NTr = size(RDS,3);                                                                              % time?
    
    % subtract 50Hz sinusoid
    f50=2*pi*50;                                                                                    %frequency in rad/sec.
    f100=2*pi*99;                                                                                   %frequency in rad/sec. % Why? To test with 100 
    f150=2*pi*150;                                                                                  %frequency in rad/sec.
    t=[0:size(RDS,1)-1]/sampf;

    for h=1:size(RDS,2)
        EMF=mean(RDS(:,h,:),3);                                                                     %ensemble mean of figure
        EMPT=max(EMF)-min(EMF);                                                                     %ensemble mean peak-to-trough
        EMSTD=std(mean(RDS(rng_bsl,h,:),1),0,3);
        for k=1:size(RDS,3)
            [Ahat,ThetaRDS,RMS]=sinefit2(RDS(:,h,k)',f50,0,1/sampf);
            RDS(:,h,k)=RDS(:,h,k)-(Ahat*sin(f50*t+ThetaRDS))';
        end
    end

    %Subtract neighboring electrodes (local reference)
    for ch=V1(1:end-1)
        RDS(:,ch,:)=RDS(:,ch,:)-RDS(:,ch+1,:);
    end
    RDS(:,V1(end),:)=[];
    V1(end)=[];
    % for what do we need lines below
    RDStemp = rand(NSmpl, 1);
    [Wtemp,frq,filter]=gaborspace(RDStemp, [5,floor(NSmpl/3),75]); %254 max for full trials
    Ffilter=fourier_embed(filter, length(RDStemp));                                   

    if dummy == 0
        dummy=1;
        AChnV1=nan(size(foi,2),size(RDStemp,1),23,1,2);
        EnvV1=nan(size(SIG,1),23,1,2);
    end

    Messg = ['Processing ' num2str(n) ' and block '];
    Task(n)=STRAT{1,2}.tsk;
    c=1;                                                                                            % for every comparison
    AChnV1Temp=nan(size(foi,2),size(RDStemp,1),length(V1),23);
    Dif_cond=nan(17,76,610,23);
    EnvV1Temp=nan(size(SIG,1),length(V1),23);

%     for j=1:length(condpool{c})
%         if length(condpool{c})==17
%             jj=j+3;
%         elseif length(condpool{c})==23
%             jj=j;
%         end
% 
%         trlsel=find(ismember(sel.cond,condpool{c}{j}-1));%extract id trial with the same position but why -1 
%         
%         
%         %RDSTemp=RDS(:,:,trlsel); %extract trial with the same position
%         
%         %RDSTemp=RDSTemp-repmat(mean(mean(RDSTemp,1),3),[NSmpl 1 length(trlsel)]); %aplly correction based on mean by time and trials , do we need it 
% 
% 
%         % Creation of the structure which contains preprocess data
%         if dummy == 0
%             clear data
%         end
        
        
     selectedLabels = datalabel(ChInd_V1);
     data.label = selectedLabels(1:end-1);
     data.fsample = sampf;
     ntrials = size(RDS, 3);
     data.trial = cell(ntrials, 1);
     data.trialinfolabels = sel.cond;
     data.trialinfo = zeros(ntrials, 1);
     data.foi = foi;
     % time = EVENT.Start:1/sampf:EVENT.Start+EVENT.Triallngth;
     time = (1:size(RDSTemp, 1)) / sampf;
     time = time - 0.2;


     for i = 1:ntrials % 
        mt = squeeze(RDS(:, :, i));
        data.trial{i} = mt';
        data.time{i} = time;
        data.trialinfo(i, 1) = i; %   
     end
    
end


% Preprocess.trialinfo    = array2table(sessioninfo{1},  ...                              % remove the column base_of_sample (trial info has a l
%                                       cfg.VariableNames.trialinfo); 

savdir = '\\10.69.168.1\crnldata\cophy\Mathilde\Danila\MonkeyData\V1-V4\A1_preprocessing';
filename = 'Preprocessed_data.mat';
fullFileName = fullfile(savdir, filename);
save(fullFileName, 'data');