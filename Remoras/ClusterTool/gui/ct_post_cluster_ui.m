function ct_post_cluster_ui

global REMORA
% Shows some options for things you can do with clusters after you are
% done.
if ~isfield(REMORA.ct,'CC') || ~isfield(REMORA.ct.CC,'output')
    warning('No composite clusters loaded')
    ct_load_composite_clusters
end
REMORA.ct.CC.output.remakePlots = 0;
initAxes = 0;
default_pos = [.25,.35,.2,.4];
if isfield(REMORA.fig, 'ct')
    % check if the figure already exists. If so, don't move it.
    if isfield(REMORA.fig.ct, 'cc_postcluster') && isvalid(REMORA.fig.ct.cc_postcluster)
        defaultPos = get(REMORA.fig.ct.cc_postcluster,'Position');
    else
        initAxes = 1;
    end
else
    initAxes = 1;
end

if initAxes
    REMORA.fig.ct.cc_postcluster = figure;
    
    set(REMORA.fig.ct.cc_postcluster,...
        'Units','normalized','Position',default_pos,...
        'ToolBar', 'none',...
        'MenuBar','none',...
        'NumberTitle','off','Name',...
        'Composite Clustering Tool - v1.0: Post-Clustering',...
        'Visible','on');
end

figure(REMORA.fig.ct.cc_postcluster)
clf
currentH = REMORA.fig.ct.cc_postcluster;
t1 = uicontrol(currentH,'Style','text',...
    'String','Post-Clustering Actions',...
    'Units','normalized',...
    'Position',[0.1,.85,.8,.1],...
    'HandleVisibility','on',...
    'Visible','on',...
    'FontSize',11);

bg = uibuttongroup(currentH,'Visible','on',...
    'Position',[0.02 0.02 .96 .85],...
    'Units','normalized',...
    'SelectionChangeFcn',@bselection);

b1 = uicontrol(bg,'Style','pushbutton',...
    'String','Edit cluster labels',...
    'Units','normalized',...
    'Position',[0.1 .9 .8 .1],...
    'HandleVisibility','off',...
    'FontSize',10,...
    'Callback',@ct_cc_apply_labels_gui);

b2 = uicontrol(bg,'Style','pushbutton',...
    'String','Save plots',...
    'Units','normalized',...
    'Position',[0.1 .78 .8 .1],...
    'HandleVisibility','off',...
    'FontSize',10,...
    'Callback',@ct_cc_save_plots_gui);

b3 = uicontrol(bg,'Style','pushbutton',...
    'String','Save labeled bin times to CSV',...
    'Units','normalized',...
    'Position',[0.1 .66 .8 .1],...
    'HandleVisibility','off',...
    'FontSize',10,...
    'Callback',@ct_cc_savebouts_gui);

b4 = uicontrol(bg,'Style','pushbutton',...
    'String','Save labels for TPWS',...
    'Units','normalized',...
    'Position',[.1 .54 .8 .1],...
    'HandleVisibility','off',...
    'FontSize',10,...
    'Callback',@ct_cc_save_ID);

b5 = uicontrol(bg,'Style','pushbutton',...
    'String','Save individual cluster files for classifier training',...
    'Units','normalized',...
    'Position',[.1 .42 .8 .1],...
    'HandleVisibility','off',...
    'FontSize',10,...
    'Callback',@ct_cc_save_indiv_clust_gui);

b6 = uicontrol(bg,'Style','pushbutton',...
    'String','Remove types and re-cluster',...
    'Units','normalized',...
    'Position',[.1 .3 .8 .1],...
    'HandleVisibility','off',...
    'FontSize',10,...
    'Callback',@ct_cc_remove_clusters);

b7 = uicontrol(bg,'Style','pushbutton',...
    'String','Load a different partition',...
    'Units','normalized',...
    'Position',[.1 .18 .8 .1],...
    'HandleVisibility','off',...
    'FontSize',10,...
    'Callback',@ct_load_composite_clusters);

b8 = uicontrol(bg,'Style','pushbutton',...
    'String','Remove bins similar to unwanted types and recluster',...
    'Units','normalized',...
    'Position',[.1 .06 .8 .1],...
    'HandleVisibility','off',...
    'FontSize',10,...
    'Callback',@ct_cc_remove_simBins);

bg.Visible = 'on';


