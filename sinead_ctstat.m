function [thickAve_lh,thickAve_rh, label] = sinead_ctstat(path, in2, in3, in4, s)
% ___________________________________________________________________________
% SINEAD (Software Integrating NEuroimaging And other Data)
%
% Copyright 2016 ISRC-Ulster
% Reference
% Youssofzadeh et al, Multi-kernel learning with Dartel enhances
% combined MRI-PET classification and prediction
% of Alzheimer’s disease: group and individual
% data analyses, submitted to Human Brain Mapping
%
%
% v1.0 Vahab Youssofzadeh 05/06/2016
% ___________________________________________________________________________

%% Statistics
if in4 == 1
    datatype = '*lh.aparc.stats';
elseif in4 == 2
    datatype = '*lh.aparc.a2009s.stats';
elseif in4 == 3
    datatype = '*lh.aparc.DKTatlas40.stats';
elseif in4 == 4
    datatype = '*lh.BA.stats';
end

files_thick_lh = sinead_findfiles (path,datatype);
% lh
idx = {'StructName', 'NumVert', 'SurfArea', 'GrayVol', 'ThickAvg', ...
    'ThickStd', 'MeanCurv', 'GausCurv', 'FoldInd', 'CurvInd'};
k = 1;
for j=1:size(files_thick_lh,2)
    T_thick_lh = read_fs_files(files_thick_lh{j});
    for i=1:length(T_thick_lh),
        T_thick_lh_t(i,:) = cell2table(T_thick_lh{1,i},'VariableNames',idx);
    end
    T_thick_lh_t_all{k} = T_thick_lh_t; k = k+1;
end
% thickAve
thickAve_lh = [];
for i = 1:size(T_thick_lh_t_all,2)
    thickAve_lh = [thickAve_lh, str2double(table2array(T_thick_lh_t_all{1,i}(:,in3+2)))];
end
% label = table2array(T_thick_lh_t(:,1));

% rh
if in4 == 1
    datatype = '*rh.aparc.stats';
elseif in4 == 2
    datatype = '*rh.aparc.a2009s.stats';
elseif in4 == 3
    datatype = '*rh.aparc.DKTatlas40.stats';
elseif in4 == 4
    datatype = '*rh.BA.stats';
end

files_thick_rh = sinead_findfiles (path,datatype);

% load files_thick_rh
idx = {'StructName', 'NumVert', 'SurfArea', 'GrayVol', 'ThickAvg', ...
    'ThickStd', 'MeanCurv', 'GausCurv', 'FoldInd', 'CurvInd'};
k = 1;
for j=1:size(files_thick_rh,2)
    T_thick_rh = read_fs_files(files_thick_rh{j});
    for i=1:length(T_thick_rh),
        T_thick_rh_t(i,:) = cell2table(T_thick_rh{1,i},'VariableNames',idx);
    end
    T_thick_rh_t_all{k} = T_thick_rh_t; k = k+1;
end

% ThickAve
thickAve_rh = [];
for i = 1:size(T_thick_rh_t_all,2)
    thickAve_rh = [thickAve_rh, str2double(table2array(T_thick_rh_t_all{1,i}(:,in3+2)))];
end
label = table2array(T_thick_rh_t(:,1));

%% visualisation
if in2 ==1
    
    figure,
    % Whole brain (left + right hemispheres)
    %     figure,
    subplot 131
    h = barh(thickAve_rh(:,end:-1:1) + thickAve_lh(:,end:-1:1));
    set(gca,'Ytick', 1:length(label),'YtickLabel',1:length(label))
    box off
    set(gca,'color','none');
    set(h(1),'FaceColor',[0.5,0.67,0.65]);
    title ('Whole brain');
    set(gcf, 'Position', [800   100   1200   1000]);
    ylabel('ROI');
    xlabel('mm');
    
    % Right Hemisphere
    %     figure,
    subplot 132
    h = barh(thickAve_rh(:,end:-1:1));
    set(gca,'Ytick', 1:length(label),'YtickLabel',1:length(label))
    box off
    set(gca,'color','none');
    set(h(1),'FaceColor',[0.5,0.67,0.65]);
    title ('RH');
    %     set(gcf, 'Position', [800   100   800   700]);
    ylabel('ROI');
    xlabel('mm');
    
    % Left Hemisphere
    subplot 133
    h = barh(thickAve_lh(:,end:-1:1));
    set(gca,'Ytick', 1:length(label),'YtickLabel',1:length(label));
    box off
    set(gca,'color','none');
    set(h(1),'FaceColor',[0.5,0.67,0.65]);
    title ('LH');
    %     set(gcf, 'Position', [800   100   800   700]);
    ylabel('ROI');
    xlabel('mm');
    
end



