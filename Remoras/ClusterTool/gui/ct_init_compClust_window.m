function ct_init_compClust_window

global REMORA

defaultPos = [0.25,0.35,0.33,0.4];
if isfield(REMORA.fig, 'ct')
    % check if the figure already exists. If so, don't move it.
    if isfield(REMORA.fig.ct, 'CC_settings') && isvalid(REMORA.fig.ct.CC_settings)
        defaultPos = get(REMORA.fig.ct.CC_settings,'Position');
    else
        REMORA.fig.ct.CC_settings = figure;
    end
else 
    REMORA.fig.ct.CC_settings = figure;
end
clf(REMORA.fig.ct.CC_settings)
set(REMORA.fig.ct.CC_settings, 'NumberTitle','off', ...
    'Name','Composite Clustering Tool - v1.0',...
    'Units','normalized',...
    'MenuBar','none',...
    'Position',defaultPos,...
    'Visible', 'on',...
    'ToolBar', 'none');

figure(REMORA.fig.ct.CC_settings)


% Load/save settings pulldown
if ~isfield(REMORA.fig.ct,'CCfileMenu') || ~isvalid(REMORA.fig.ct.CCfileMenu)
    REMORA.fig.ct.CCfileMenu = uimenu(REMORA.fig.ct.CC_settings,'Label',...
        'Save/Load Settings','Enable','on','Visible','on');
    
    % Spectrogram load/save params
    uimenu(REMORA.fig.ct.CCfileMenu,'Label','&Load settings',...
        'Callback','ct_cc_control(''ct_cc_settingsLoad'')');
    uimenu(REMORA.fig.ct.CCfileMenu,'Label','&Save settings',...
        'Callback','ct_cc_control(''ct_cc_settingsSave'')');
end

% button grid layouts
% 14 rows, 4 columns
r = 21; % rows      (extra space for separations btw sections)
c = 4;  % columns
h = 1/r;
w = 1/c;
dy = h * 0.8;
% dx = 0.008;
ybuff = h*.2;
% y position (relative units)
y = 1:-h:0;

% x position (relative units)
x = 0:w:1;

% colors
bgColor = [1 1 1];  % white
bgColorRed = [1 .6 .6];  % red
bgColorGray = [.86 .86 .86];  % gray
bgColor3 = [.75 .875 1]; % light green 
bgColor4 = [.76 .87 .78]; % light blue 

REMORA.ct.CC_params_help = ct_cc_get_help_strings;

REMORA.ct.CC_verify = [];
labelStr = 'Verify Composite Clustering Options';
btnPos=[x(1) y(2) 4*w h];
REMORA.ct.CC_verify.headtext = uicontrol(REMORA.fig.ct.CC_settings, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'String',labelStr, ...
    'FontUnits','points', ...
    'FontWeight','bold',...
    'FontSize',12,...
    'Visible','on');  %'BackgroundColor',bgColor3,...

% Set paths and strings
%***********************************
%% Base Folder Text
labelStr = 'Input Folder';
btnPos=[x(1) y(3)-ybuff w h];
REMORA.ct.CC_verify.inDirTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'FontUnits','normalized', ...
   'Visible','on');%   'BackgroundColor',bgColor3,...

% Base Folder Editable Text
labelStr=num2str(REMORA.ct.CC_params.inDir);
btnPos=[x(2) y(3) (w*3)*.95 h];
REMORA.ct.CC_verify.inDirEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'HorizontalAlignment','left',...
    'Visible','on',...
    'Callback','ct_cc_control(''setInDir'')');


%% Output Folder Text
labelStr = 'Output Folder';
btnPos=[x(1) y(5)-ybuff w h];
REMORA.ct.CC.verify.outDirTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'FontUnits','normalized', ...
   'Visible','on');%   'BackgroundColor',bgColor3,...

% Output Folder Editable Text
labelStr=num2str(REMORA.ct.CC_params.outDir);
btnPos=[x(2) y(5) (w*3)*.95 h];
REMORA.ct.CC_verify.outDirEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'HorizontalAlignment','left',...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback','ct_cc_control(''setOutDir'')');


%% Deployment Name Wildcard Text
labelStr = 'Input File Name Wildcard';
btnPos=[x(1) y(4)-ybuff w h];
REMORA.ct.CC_verify.inFileStringTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'FontUnits','normalized', ...
   'Visible','on',...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.inFileString));%   'BackgroundColor',bgColor3,...

% Deployment Name Wildcard Editable Text
if ~isfield(REMORA.ct.CC_params,'inFileString')
    REMORA.ct.CC_params.inFileString = '';
end
labelStr=num2str(REMORA.ct.CC_params.inFileString);
btnPos=[x(2) y(4) w h];
REMORA.ct.CC_verify.inFileStringEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'HorizontalAlignment','left',...
    'Visible','on',...
    'Callback','ct_cc_control(''setInFileString'')');

%% Output File Name
labelStr = 'Output File Name';
btnPos=[x(1) y(6)-ybuff w h];
REMORA.ct.CC_verify.outputNameTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'FontUnits','normalized', ...
   'Visible','on',...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.outputName));%   'BackgroundColor',bgColor3,...

% Output File Name Editable Text
labelStr = num2str(REMORA.ct.CC_params.outputName);
btnPos=[x(2) y(6) w h];
REMORA.ct.CC_verify.outputNameEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'HorizontalAlignment','left',...
    'Visible','on',...
    'Callback','ct_cc_control(''setOutputName'')');

%% SaveOutput options

showOutputParams = 'on';

%REMORA.ct.CC_params_help.saveOutput = 'Check box if you want to save output files';

labelStr = 'Save Output';
btnPos=[x(2) y(7)-ybuff w h];
REMORA.ct.CC_verify.saveOutput = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','checkbox',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'Value',REMORA.ct.CC_params.saveOutput,...
   'FontUnits','normalized', ...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.saveOutput),...
   'Visible',showOutputParams,...
   'Callback','ct_cc_control(''saveOutput'')');

%% Clustering Options
labelStr = 'Feature Selection';
btnPos=[x(1) y(8) w*2 h-ybuff];
REMORA.ct.CC_verify.cparamtext = uicontrol(REMORA.fig.ct.CC_settings, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',bgColor4,...
    'String',labelStr, ...
    'FontWeight','bold',...    
    'FontSize',10,...
    'FontUnits','points',...
    'Visible','on'); 


%% Spectral Feats
labelStr = 'Compare on spectra';
btnPos=[x(1) y(9) w*2 dy];
REMORA.ct.CC_verify.spectraCheck = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','checkbox',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'Value',REMORA.ct.CC_params.useSpectraTF,...
   'FontUnits','normalized',...
   'Visible','on',...
   'Callback','ct_cc_control(''setUseSpectraTF'')'); %'TooltipString',sprintf(REMORA.ct.CC_params_help.useSpectra),...

if REMORA.ct.CC_params.useSpectraTF
    showSpectralParams = 'on';
else
    showSpectralParams = 'off';
end    
labelStr = 'Min. Freq. (kHz)';
btnPos=[x(1) y(10)-ybuff w*.66 h];
REMORA.ct.CC_verify.startFreqTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'FontUnits','normalized', ...
   'Visible',showSpectralParams,...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.freqs));%   'BackgroundColor',bgColor3,...

% Min Start Freq Editable Text
labelStr=num2str(REMORA.ct.CC_params.startFreq);
btnPos=[x(1)+w*.66 y(10) w/3 h];
REMORA.ct.CC_verify.startFreqEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible',showSpectralParams,...
    'Callback','ct_cc_control(''setStartFreq'')');

labelStr = 'Max. Freq. (kHz)';
btnPos=[x(2) y(10)-ybuff w*.66 h];
REMORA.ct.CC_verify.endFreqTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'FontUnits','normalized', ...
   'Visible',showSpectralParams,...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.freqs));%   'BackgroundColor',bgColor3,...

labelStr=num2str(REMORA.ct.CC_params.endFreq);
btnPos=[x(2)+w*.66 y(10) w/3 h];
REMORA.ct.CC_verify.endFreqEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible',showSpectralParams,...
    'Callback','ct_cc_control(''setEndFreq'')');

labelStr = 'Linear space';
btnPos=[x(2)+w/8 y(11) w dy];
REMORA.ct.CC_verify.linearCheck = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','checkbox',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'Value',REMORA.ct.CC_params.linearTF,...
   'FontUnits','normalized', ...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.linearTF),...
   'Visible',showSpectralParams,...
   'Callback','ct_cc_control(''setLinearTF'')');

%  Diff Checkbox
labelStr = 'Compare 1st deriv.';
btnPos=[x(1)+w/8 y(11) w dy];
REMORA.ct.CC_verify.diffCheck = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','checkbox',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'Value',REMORA.ct.CC_params.specDiffTF,...
   'FontUnits','normalized', ...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.diff),...
   'Visible',showSpectralParams,...
   'Callback','ct_cc_control(''setDiff'')');

%% Temporal Feats
labelStr = 'Compare on temporal features';
btnPos=[x(1) y(13) w*2 dy];
REMORA.ct.CC_verify.timesCheck = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','checkbox',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'Value',REMORA.ct.CC_params.useTimesTF,...
   'FontUnits','normalized',...
   'Visible','on',...
   'Callback','ct_cc_control(''setUseTimesTF'')'); %'TooltipString',sprintf(REMORA.ct.CC_params_help.useSpectra),...

if REMORA.ct.CC_params.useTimesTF
    showTemporalParams = 'on';
else
    showTemporalParams = 'off';
end    

btnPos=[x(1) y(14) w*2 dy]; 
REMORA.ct.CC_verify.bg = uibuttongroup('Visible',showTemporalParams,...
                  'Position',btnPos,...
                  'BorderType','none');%'SelectionChangedFcn',{@ct_cc_control},...
% Create 2 radio buttons in the button group.
btnPos=[0.1,0 .4 1]; 
REMORA.ct.CC_verify.bg_r1 = uicontrol(REMORA.ct.CC_verify.bg,'Style','radiobutton',...
                  'Units','normalized',...
                  'String','ICI mode',...
                  'Position',btnPos,...
                  'HandleVisibility','on',...
                  'Value',REMORA.ct.CC_params.iciModeTF,...
                  'Callback','ct_cc_control(''setICIMode'')');

REMORA.ct.CC_params.iciDistTF = ~REMORA.ct.CC_params.iciModeTF;
    
btnPos=[0.6,0 .4 1]; 
REMORA.ct.CC_verify.bg_r2 = uicontrol(REMORA.ct.CC_verify.bg,'Style','radiobutton',...
                  'String','ICI distribution',...
                  'Units','normalized',...
                  'Position',btnPos,...
                  'Value',REMORA.ct.CC_params.iciDistTF,...
                  'HandleVisibility','on',...
                  'Callback','ct_cc_control(''setICIDist'')');
REMORA.ct.CC_verify.bg.Visible = showTemporalParams;

%% ICI Min Text
labelStr = 'Min ICI (sec)';
btnPos=[x(1) y(15)-ybuff w*.66 h];
REMORA.ct.CC_verify.ICIMinTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'FontUnits','normalized', ...
   'Visible',showTemporalParams);%   'BackgroundColor',bgColor3,...

% ICI Min Editable Text
labelStr=num2str(REMORA.ct.CC_params.minICI);
btnPos=[x(1)+w*.66 y(15) w/3 h];
REMORA.ct.CC_verify.ICIMinEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible',showTemporalParams,...
    'Callback','ct_cc_control(''setICIMin'')');

%% ICI Max Text
labelStr = 'Max ICI (sec)';
btnPos=[x(2) y(15)-ybuff w*.66 h];
REMORA.ct.CC_verify.ICIMaxTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'FontUnits','normalized', ...
   'Visible',showTemporalParams);%   'BackgroundColor',bgColor3,...

% ICI Max Editable Text
labelStr=num2str(REMORA.ct.CC_params.maxICI);
btnPos=[x(2)+w*.66 y(15) w/3 h];
REMORA.ct.CC_verify.ICIMaxEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible',showTemporalParams,...
    'Callback','ct_cc_control(''setICIMax'')');

labelStr = 'Correct for ICI saturation';
btnPos=[x(1)+w/8 y(16) w*2 dy];
REMORA.ct.CC_verify.correctForSatCheck = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','checkbox',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'Value',REMORA.ct.CC_params.correctForSaturation,...
   'FontUnits','normalized', ...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.correctForSaturation),...
   'Visible',showTemporalParams,...
   'Callback','ct_cc_control(''setCorrectForSatTF'')');


%% Output
if ~isfield(REMORA.ct.CC_params,'useEnvShape')
    REMORA.ct.CC_params.useEnvShape = 0;
end
labelStr = 'Compare on waveform';
btnPos=[x(1) y(17) w*2 dy];
REMORA.ct.CC_verify.envCheck = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','checkbox',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'Value',REMORA.ct.CC_params.useEnvShape,...
   'FontUnits','normalized',...
   'Visible','on',...
   'Callback','ct_cc_control(''setUseEnvShape'')'); %'TooltipString',sprintf(REMORA.ct.CC_params_help.useSpectra),...

% labelStr = 'Write diary file';
% btnPos=[x(3)+w/4 y(8) w*2 dy];
% REMORA.ct.CC_verify.diaryCheck = uicontrol(REMORA.fig.ct.CC_settings,...
%    'Style','checkbox',...
%    'Units','normalized',...
%    'Position',btnPos,...
%    'String',sprintf(labelStr,'Interpreter','tex'),...
%    'Value',REMORA.ct.CC_params.singleClusterOnly,...
%    'FontUnits','normalized', ...
%    'TooltipString',sprintf(REMORA.ct.CC_params_help.singleClusterOnly),...
%    'Visible','on',...
%    'Callback','ct_cc_control(''setSingleClustTF'')');

% labelStr = 'Save cluster file';
% btnPos=[x(3)+w/4 y(8) w*2 dy];
% REMORA.ct.CC_verify.diaryCheck = uicontrol(REMORA.fig.ct.CC_settings,...
%    'Style','checkbox',...
%    'Units','normalized',...
%    'Position',btnPos,...
%    'String',sprintf(labelStr,'Interpreter','tex'),...
%    'Value',REMORA.ct.CC_params.singleClusterOnly,...
%    'FontUnits','normalized', ...
%    'TooltipString',sprintf(REMORA.ct.CC_params_help.singleClusterOnly),...
%    'Visible','on',...
%    'Callback','ct_cc_control(''setSingleClustTF'')');
% 
% labelStr = 'Save combined cluster plots';
% btnPos=[x(3)+w/4 y(8) w*2 dy];
% REMORA.ct.CC_verify.linearCheck = uicontrol(REMORA.fig.ct.CC_settings,...
%    'Style','checkbox',...
%    'Units','normalized',...
%    'Position',btnPos,...
%    'String',sprintf(labelStr,'Interpreter','tex'),...
%    'Value',REMORA.ct.CC_params.linearTF,...
%    'FontUnits','normalized', ...
%    'TooltipString',sprintf(REMORA.ct.CC_params_help.linearTF),...
%    'Visible','on',...
%    'Callback','ct_cc_control(''setLinearTF'')');

% %% Plot Checkbox
% labelStr = 'Save individual cluster files and plots';
% btnPos=[x(3)+w/4 y(9) w*2 dy];
% REMORA.ct.CC_verify.plotCheck = uicontrol(REMORA.fig.ct.CC_settings,...
%    'Style','checkbox',...
%    'Units','normalized',...
%    'Position',btnPos,...
%    'String',sprintf(labelStr,'Interpreter','tex'),...
%    'Value',REMORA.ct.CC_params.plotFlag,...
%    'FontUnits','normalized', ...
%    'TooltipString',sprintf(REMORA.ct.CC_params_help.plotFlag),...
%    'Visible','on',...
%    'Callback','ct_cc_control(''setPlotFlag'')');


%% Clustering parameters header
labelStr = 'Thresholds & Constants';
btnPos=[x(3) y(8) w*2 h-ybuff];
REMORA.ct.CC_verify.performtext = uicontrol(REMORA.fig.ct.CC_settings, ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',bgColorRed,...
    'String',labelStr, ...
    'FontSize',10,...
    'FontUnits','points',...
    'FontWeight','bold',...
    'Visible','on'); 


%% CW Interations Text
labelStr = 'Max Clustering Iterations';
btnPos=[x(3)+w/8 y(9)-ybuff w dy];
REMORA.ct.CC_verify.maxCWitrTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.maxCWiterations),...
   'FontUnits','normalized', ...
   'HorizontalAlignment','left',...
   'Visible','on');%   'BackgroundColor',bgColor3,...

% CW Iterations Editable Text
labelStr=num2str(REMORA.ct.CC_params.maxCWIterations);
btnPos=[x(4)+w/3 y(9) w/3 h];
REMORA.ct.CC_verify.maxCWitrEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback','ct_cc_control(''setMaxCWiterations'')');

%% Max Network Size Text
labelStr = 'Max Network Size';
btnPos=[x(3)+w/8 y(10)-ybuff w dy];
REMORA.ct.CC_verify.maxNetworkSzTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.maxNetworkSz),...
   'FontUnits','normalized',...
   'HorizontalAlignment','left',...
   'Visible','on');%   'BackgroundColor',bgColor3,...

% Max Network Size Editable Text
labelStr=num2str(REMORA.ct.CC_params.maxClust);
btnPos=[x(4)+w/3 y(10) w/3 h];
REMORA.ct.CC_verify.maxNetworkSzEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback','ct_cc_control(''setMaxNetworkSz'')');

%% Prune Thresh Text
labelStr = 'Pruning Threshold [0-100]';
btnPos=[x(3)+w/8 y(11)-ybuff w dy];
REMORA.ct.CC_verify.pruneThrTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.pruneThr),...
   'FontUnits','normalized', ...
   'HorizontalAlignment', 'left',...
   'Visible','on');%   'BackgroundColor',bgColor3,...

% Prune Thresh Editable Text
labelStr=num2str(REMORA.ct.CC_params.pruneThr);
btnPos=[x(4)+w/3 y(11) w/3 h];
REMORA.ct.CC_verify.pruneThrEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback','ct_cc_control(''setPruneThr'')');


%% Min Bin Size Text
labelStr = 'Min. Bin Size';
btnPos=[x(3)+w/8 y(12)-ybuff w dy];
REMORA.ct.CC_verify.minClicksTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.minClicks),...
   'FontUnits','normalized',...
   'HorizontalAlignment','left',...
   'Visible','on');%   'BackgroundColor',bgColor3,...

% Min Bin Size Editable Text
labelStr=num2str(REMORA.ct.CC_params.minClicks);
btnPos=[x(4)+w/3 y(12) w/3 h];
REMORA.ct.CC_verify.minClicksEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback','ct_cc_control(''setMinClicks'')');

%% Min Cluster Size Text
labelStr = 'Min. Cluster Size';
btnPos=[x(3)+w/8 y(13)-ybuff w dy];
REMORA.ct.CC_verify.minClustTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.minClust),...
   'FontUnits','normalized',...
   'HorizontalAlignment','left',...
   'Visible','on');%   'BackgroundColor',bgColor3,...

% Min Cluster Size Editable Text
labelStr=num2str(REMORA.ct.CC_params.minClust);
btnPos=[x(4)+w/3 y(13) w/3 h];
REMORA.ct.CC_verify.minClustEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback','ct_cc_control(''setMinClust'')');

%% Number of Trials  Text
labelStr = 'Number of Trials';
btnPos=[x(3)+w/8 y(14)-ybuff w dy];
REMORA.ct.CC_verify.NTrialsTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.NTrials),...
   'FontUnits','normalized',...
   'HorizontalAlignment','left',...
   'Visible','on');%   'BackgroundColor',bgColor3,...

% Number of Trials Editable Text
labelStr=num2str(REMORA.ct.CC_params.N);
btnPos=[x(4)+w/3 y(14) w/3 h];
REMORA.ct.CC_verify.NTrialsEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback','ct_cc_control(''setNTrials'')');

%% Cluster Pruning Factor Text
labelStr = 'Cluster Pruning Factor [0-.99]';
btnPos=[x(3)+w/8 y(15)-ybuff w dy];
REMORA.ct.CC_verify.clusterPruneTxt = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','text',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.clusterPrune),...
   'FontUnits','normalized',...
   'HorizontalAlignment','left',...
   'Visible','on');%   'BackgroundColor',bgColor3,...

if ~isfield(REMORA.ct.CC_params,'clusterPrune')
    REMORA.ct.CC_params.clusterPrune = 0;
end
% Cluster Pruning Factor Editable Text
labelStr=num2str(REMORA.ct.CC_params.clusterPrune);
btnPos=[x(4)+w/3 y(15) w/3 h];
REMORA.ct.CC_verify.clusterPruneEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','edit',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'Visible','on',...
    'Callback','ct_cc_control(''setClusterPruningFactor'')');

labelStr = 'Use Only Single Cluster Bins';
btnPos=[x(3)+w/8 y(16) w*2 dy];
REMORA.ct.CC_verify.singleClustCheck = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','checkbox',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'Value',REMORA.ct.CC_params.singleClusterOnly,...
   'FontUnits','normalized', ...
   'TooltipString',sprintf(REMORA.ct.CC_params_help.singleClusterOnly),...
   'Visible','on',...
   'Callback','ct_cc_control(''setSingleClustTF'')');

labelStr = 'Remove subset of prior clusters';
rmPriorClustersStatus = 'off';
if isfield(REMORA.ct.CC,'rmSet') && ~isempty(REMORA.ct.CC.rmSet)
    % no prior clusters to remove have been identified
    rmPriorClustersStatus = 'on';
end
if ~isfield(REMORA.ct.CC_params,'rmPriorClusters')
    REMORA.ct.CC_params.rmPriorClusters = 0;
end
btnPos=[x(3)+w/8 y(17) w*2 dy];
REMORA.ct.CC_verify.rmClustCheck = uicontrol(REMORA.fig.ct.CC_settings,...
   'Style','checkbox',...
   'Units','normalized',...
   'Position',btnPos,...
   'String',sprintf(labelStr,'Interpreter','tex'),...
   'Value',REMORA.ct.CC_params.rmPriorClusters,...
   'FontUnits','normalized', ...
   'Visible','on',...
   'Enable',rmPriorClustersStatus,...
   'Callback','ct_cc_control(''rmPriorClustersTF'')');%'TooltipString',sprintf(REMORA.ct.CC_params_help.rmPriorClusters),...

if isfield(REMORA.ct.CC,'sbSet') && ~isempty(REMORA.ct.CC.sbSet)	
    % no prior clusters to remove have been identified	
    rmSimBinStatus = 'on';	
end	
if ~isfield(REMORA.ct.CC_params,'rmSimBins')	
    REMORA.ct.CC_params.rmSimBins = 0;	
end	

labelStr = 'Remove bins similar to unwanted clusters';	
rmSimBinStatus = 'off';	
btnPos=[x(3)+w/8 y(18) w*2 dy];	
REMORA.ct.CC_verify.rmSimBinCheck = uicontrol(REMORA.fig.ct.CC_settings,...	
    'Style','checkbox',...	
    'Units','normalized',...	
    'Position',btnPos,...	
    'String',sprintf(labelStr,'Interpreter','tex'),...	
    'Value',REMORA.ct.CC_params.rmSimBins,...	
    'FontUnits','normalized', ...	
    'Visible','on',...	
    'Enable',rmSimBinStatus,...	
    'TooltipString',sprintf(REMORA.ct.CC_params_help.rmvBins),...	
    'Callback','ct_cc_control(''rmSimBinTF'')');%'TooltipString',sprintf(REMORA.ct.CC_params_help.rmPriorClusters),...	

%% Allowable Distance Text	
if isfield(REMORA.ct.CC_params,'rmSimBins')&& REMORA.ct.CC_params.rmSimBins==1	
    showSBParams = 'on';	
else	
    showSBParams = 'off';	
end	

labelStr = 'Difference (normalized amplitude)';	
btnPos=[x(3)+w*.55 y(19)-ybuff w*1.2 h];	
REMORA.ct.CC_verify.SBdiffTxt = uicontrol(REMORA.fig.ct.CC_settings,...	
    'Style','text',...	
    'Units','normalized',...	
    'Position',btnPos,...	
    'String',sprintf(labelStr,'Interpreter','tex'),...	
    'FontUnits','normalized', ...	
    'Visible',showSBParams);%   'BackgroundColor',bgColor3,...	

% Editable Text	
if ~isfield(REMORA.ct.CC_params,'SBdiff')	
    REMORA.ct.CC_params.SBdiff = [];	
end	
labelStr=num2str(REMORA.ct.CC_params.SBdiff);	
btnPos=[x(3)+w*.2 y(19) w/3 h];	
REMORA.ct.CC_verify.SBdiffEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...	
    'Style','edit',...	
    'Units','normalized',...	
    'Position',btnPos,...	
    'BackgroundColor',bgColor,...	
    'String',labelStr,...	
    'FontUnits','normalized', ...	
    'Visible',showSBParams,...	
    'TooltipString',sprintf(REMORA.ct.CC_params_help.SBdiff),...	
    'Callback','ct_cc_control(''setSBdiff'')');	

%% Percent similarity Text	
labelStr = 'Percent Similarity (decimal)';	
btnPos=[x(3)+w*.55 y(20) w h];	
REMORA.ct.CC_verify.SBpercTxt = uicontrol(REMORA.fig.ct.CC_settings,...	
    'Style','text',...	
    'Units','normalized',...	
    'Position',btnPos,...	
    'String',sprintf(labelStr,'Interpreter','tex'),...	
    'FontUnits','normalized', ...	
    'Visible',showSBParams);%   'BackgroundColor',bgColor3,...	

% Editable Text	


if ~isfield(REMORA.ct.CC_params,'SBperc')	
    REMORA.ct.CC_params.SBperc = [];	
end	
labelStr=num2str(REMORA.ct.CC_params.SBperc);	
btnPos=[x(3)+w*.2 y(20) w/3 h];	
REMORA.ct.CC_verify.SBpercEdTxt = uicontrol(REMORA.fig.ct.CC_settings,...	
    'Style','edit',...	
    'Units','normalized',...	
    'Position',btnPos,...	
    'BackgroundColor',bgColor,...	
    'String',labelStr,...	
    'FontUnits','normalized', ...	
    'Visible',showSBParams,...	
    'TooltipString',sprintf(REMORA.ct.CC_params_help.SBperc),...	
    'Callback','ct_cc_control(''setSBperc'')');

%% Run button
labelStr = 'Run Composite Clustering';
btnPos=[x(2) y(21) w*2 h];

REMORA.ct.CC_verify.runTxt = uicontrol(REMORA.fig.ct.CC_settings,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',btnPos,...
    'BackgroundColor',bgColor3,...
    'String',labelStr,...
    'FontUnits','normalized', ...
    'FontSize',.5,...
    'Visible','on',...
    'FontWeight','bold',...
    'Callback','ct_cc_control(''runCompositeClusters'')');

