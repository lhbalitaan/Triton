%%%detector for running echosounders- created with testing done on Kona
%%%data, by MAZ, on 10/30/2020

templateFilePath = 'G:\code\misc_code\echosounderTemplate.mat';
dataFilePath = 'F:\';
depName = 'HAWAII01';
outDir = 'E:\echoTests\echoLowT\HI01-50-ICImodetest';

%%%%%thresholds
lowF = 20000; %lower cutoff in Hz
highF = 80000; %high cutoff in Hz
prcTh = 50; %percent threshold for correlation calcuation
gapT = 0.05; %gap time in seconds for between detections
thresholdC = 50^2; %base threshold for c2 for keeping detections from correlation
threshPP = -500; %threshold for ddPP difference between noise sample and signal
ICI_range = [0.2,4]; %allowable ICI range, remove detections outside of this
ICIpad = 0.1; %time in seconds for padding around ICI mode for allowable ICI range
fftLength = 400;

template = templateFilePath;
% template = fullfile(templateFilePath,'echosounderTemplate.mat'); % Make sure that this line is correct for the input template folder!
load(template)

tempData = DATA(100:800);

pre_env_temp=hilbert(tempData.');
env_temp=sqrt((real(pre_env_temp)).^2+(imag(pre_env_temp)).^2); % Au 1993, S.178, equation 9-4.
env_temp = (env_temp - min(env_temp))./max(env_temp); %normalize env_temp


p.thresholdC = thresholdC;
p.lowF = lowF;
p.highF = highF;
p.threshPP = threshPP;
p.gapT = gapT;
p.prcTh = prcTh;
p.fftLength = fftLength;

inFolders = dir([dataFilePath,'\',depName,'*']);

for iF = 1:size(inFolders,1)
    iFold = inFolders(iF).name;
    iFoldPath = fullfile(inFolders(iF).folder,inFolders(iF).name);
    outFold = fullfile(outDir,iFold);
    
    if ~isdir(outFold)
        mkdir(outFold)
    end
    
    allFiles = dir([iFoldPath,'\',depName,'*.x.wav']);
    
    for iF2 = 1:size(allFiles,1)
        
        testFile = fullfile(allFiles(iF2).folder,allFiles(iF2).name);
        [rawStart,rawDur,fs,rawByteLoc] = ed_readxwavhd(testFile);
        p.fs = fs;
        f = 0:((p.fs/2)/1000)/((fftLength/2)):((p.fs/2)/1000);
        fInd1= find(f==(p.lowF/1000));
        fInd2 = find(f==(p.highF/1000));
        f = f(fInd1:fInd2);
        
        dataTimes = [];
        c_above = [];
        keepCorr_final = [];
        dataSeg_final = [];
        keepTimes_final = [];
        ED_stTimes_final = [];
        keepWV_final = [];
        noiseSeg_final = [];
        dataSeg_final = [];
        deltPP_final = [];
        detDur_final = [];
        spNoise_final = [];
        spData_final = [];
        diffC = [];
        csq = [];
        keepIDs = [];
        
        for iR = 1:size(rawDur,2)
            %get start and end of xwav file
            rStart = datenum(rawStart(iR,:));
            rEnd = rStart + datenum(0,0,0,0,0,rawDur(iR));
            lStart = ((rawByteLoc(iR)-rawByteLoc(1))./2)+1;
            lEnd = lStart + round(rawDur(iR)*fs)-1;
            
            testData = audioread(testFile,[lStart lEnd]);
            
            %get a vector of same length as testData with corresponding correct times
            %of each spot in test dataset
            dataTimes = linspace(rStart,rEnd,size(testData,1));
            
            %%apply a BP filter to y \
            N1= 10; %order of filter; 10 chosen because it was used for explosion detector. Don't @ me.
            [B,A] = butter(N1/2, [lowF highF]/(fs/2));
            filtData = filtfilt(B,A,testData); % Filter click.
            
            pre_env_y = hilbert(filtData.');
            env_y = sqrt((real(pre_env_y)).^2+(imag(pre_env_y)).^2); %Au 1993, S.178, equation 9-4
            %normalize env_y
            env_yNorm = (env_y-min(env_y))./max(env_y);
            
            % Calculate cross correlation with template echosounder
            c = xcorr(env_yNorm,env_temp);
            
            %have to find median and add threshold value to determine what's above
            %threshold (i.e. what to keep)
            c(1:length(env_y)-1)= [];
            
            csq = c.*c; %square c so that true peaks show up better
            
            medianC = prctile(csq,prcTh); %calculate median
            aboveThr = medianC + thresholdC;
            
            c_above = find(csq > aboveThr); %indices saved in c_above will theoretically be useful for finding w/e that's associated with echosounder signal
            
            diffC{iR} = diff(c_above);
            expGaps = find(diffC{iR} > gapT.*fs); %finds gaps greater than this threshold
            
            keepCorr = [];
            keepTimes = [];
            ED_stTimes = [];
            keepTS = [];
            keepWV = [];
            noiseSeg = [];
            dataSeg = [];
            deltPP = [];
            deltPP_all = [];
            spDataKeep = [];
            spNoiseKeep = [];
            detDur_keep = [];
            keepNoise = [];
            noiseTS = [];
            
            step = 1;
            
            
            for iG = 1:size(expGaps,2)
                c_aboveSeg = c_above(step:expGaps(iG));
                SS = c_aboveSeg(1);
                eS = c_aboveSeg(end);
                
                %%calculate ppRL and remove if lower than thresh
                
                dataSeg = filtData(SS:eS);
                highP = max(dataSeg);
                lowP = min(dataSeg);
                ppSeg = highP + abs(lowP);
                ppRLSeg = 20*log10(ppSeg);
                
                %get noise sample from after signal
                if SS <= 500
                    noiseSeg = filtData(eS:(eS+500)); 
                else
                    %take a noise sample from before instead
                    noiseSeg = filtData((SS-500):SS);
                end
                
                highPN = max(noiseSeg);
                lowPN = min(noiseSeg);
                ppNoise = highPN + abs(lowPN);
                ppRLNoise = 20*log10(ppNoise);
                
                deltPP = ppRLSeg - ppRLNoise;
                deltraw = ppSeg - ppNoise;
                deltPP_all(iG) = deltPP;
                
                if deltPP >= threshPP
                    dataKeep = dataSeg;
                    timesKeep = dataTimes(c_aboveSeg);
                    corrKeep  = c(c_aboveSeg);
                    segWAV = env_y(SS:eS);
                    detDur = timesKeep(end)-timesKeep(1);
                    ED_stTimes{iG} = timesKeep(1);
                    keepNoise = noiseSeg;
                else
                    dataKeep = [];
                    timesKeep = [];
                    corrKeep = [];
                    ED_stTimes{iG} = [];
                    detDur = [];
                    segWAV = [];
                    keepNoise = [];
                end
                
                %calculate signal and noise spectras
                if ~isempty(dataKeep)
                    N = fftLength;
                    sub = 10*log10(p.fs/N);
                    dataWin = hann(length(dataKeep));
                    wData = dataWin.*dataKeep;
                    spData = 20*log10(abs(fft(wData,N)));
                    %account for bin width
                    spDataMod = spData - sub;
                    %only save first half
                    spDataKeep(iG,:) = spDataMod(fInd1:fInd2);
                    
                    %for noise
                    noiseWin = hann(length(keepNoise));
                    wNoise = noiseWin.*keepNoise;
                    spNoise = 20*log10(abs(fft(wNoise,N)));
                    spNoiseMod = spNoise - sub;
                    spNoiseKeep(iG,:) = spNoise(fInd1:fInd2);
                end
                
                
                detDur_keep{iG} = detDur;
                keepWV{iG} = segWAV;
                keepCorr{iG} = corrKeep;
                keepTS{iG} = dataKeep;
                keepTimes{iG} = timesKeep;
                noiseTS{iG} = keepNoise;
                
                
                step = expGaps(iG)+1;
            end
            
            %calculate ICI and only keep ones with good ICI
            keepIDs = [];
            icS = cell2mat(ED_stTimes);
            
            if ~isempty(icS)
                icE = [icS(2:end),icS(end)];
                ICIall = icE - icS;
                ICIdv = datevec(ICIall);
                ICIsecs = ICIdv(:,6);
                %                 plot(ICIsecs,'.')
                %                 ylim([0 3])
                modeICI = mode(ICIsecs);
                if modeICI >= ICI_range(1) & modeICI <= ICI_range(2)
                    ICImode = [(modeICI-ICIpad),(modeICI+ICIpad)];
                    keepIDs = find(ICIsecs>=ICImode(1) & ICIsecs<=ICImode(2));
                else
                    keepIDs = [];
                end
            end
            
            if ~isempty(keepIDs)
                dataSeg_final{iR} = keepTS{keepIDs};
                keepCorr_final{iR} = keepCorr{keepIDs};
                keepTimes_final{iR} = keepTimes{keepIDs};
                ED_stTimes_final{iR} = ED_stTimes(keepIDs);
                noiseSeg_final{iR} = noiseTS{keepIDs};
                %             deltPP_final{iR} = deltPP_all{keepIDs};
                keepWV_final{iR} = keepWV{keepIDs};
                detDur_final{iR} = detDur_keep{keepIDs};
                spNoise_final{iR} = spNoiseKeep(keepIDs,:);
                spData_final{iR} = spDataKeep(keepIDs,:);
            else
                dataSeg_final{iR} = [];
                keepCorr_final{iR} = [];
                keepTimes_final{iR} = [];
                ED_stTimes_final{iR} =[];
                noiseSeg_final{iR} = [];
                %             deltPP_final{iR} = deltPP_all{keepIDs};
                keepWV_final{iR} = [];
                detDur_final{iR} = [];
                spNoise_final{iR} = [];
                spData_final{iR} = [];
            end
            
        end
        
        %remove empty rows
        detDur_final = detDur_final(~cellfun('isempty',detDur_final));
        ED_stTimes_final = ED_stTimes_final(~cellfun('isempty',ED_stTimes_final));
        keepCorr_final = keepCorr_final(~cellfun('isempty',keepCorr_final));
        dataSeg_final = dataSeg_final(~cellfun('isempty',dataSeg_final));
        keepWV_final = keepWV_final(~cellfun('isempty',keepWV_final));
        noiseSeg_final = noiseSeg_final(~cellfun('isempty',noiseSeg_final));
        spData_final = spData_final(~cellfun('isempty',spData_final));
        spNoise_final = spNoise_final(~cellfun('isempty',spNoise_final));
        
        outName = [char(extractBefore(allFiles(iF2).name,'.x')),'echo.mat'];
        saveFile = fullfile(outFold,outName);
        
        save(saveFile,'ED_stTimes_final','p','keepCorr_final','noiseSeg_final','dataSeg_final','keepWV_final','detDur_final','f','spData_final','spNoise_final','-v7.3');%,'deltPP_final','-v7.3');%'diffC','csq','-v7.3')
        dispTxt = ['Done with file ',allFiles(iF2).name];
        disp(dispTxt)
        
    end
    dispTxt2 = ['Done with folder ',iFold];
    disp(dispTxt2)
end
