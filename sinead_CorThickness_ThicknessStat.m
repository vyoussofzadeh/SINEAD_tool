function [CTV,rCTV] = sinead_CorThickness_ThicknessStat()
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
disp('Cortical thickness statistics...')
disp('---------------------------');

col = [0.5,0.5,0.5];

path = spm_select(Inf,'dir','Select folder');

% in2 = input ('Display all maps (yes = 1, No = 0)? ');
in2 = 1;
disp('---------------------------');

disp('SurfArea = 1');
disp('GrayVol  = 2');
disp('ThickAvg = 3');
disp('ThickStd = 4');
disp('MeanCurv = 5');
disp('GausCurv = 6');

% A 2D surface (like the cortical white or pial models) has two principal
% curvatures at each point - one in the direction of maximum curvature and
% one in the direction of minimum curvature - typically denoted k1 and k2.
% The mean curvature is the average of these H=(k1+k2)/2 and the Gaussian
% curvature is the product of them K=(k1 * k2).  So, MeanCurv is the integral
% of the absolute value of H and GausCurv is the integral of the absolute
% value of K. FoldInd and CurvInd are two indices proposed by David Van Essen
% in a paper from years ago ...

in3 = input ('Enter stats data? ');
disp('---------------------------');

disp('Desikan-Killiany = 1'); 
disp('Destrieux        = 2');
disp('DKT(Mindboggle)  = 3');
disp('Brodman          = 4');

in4 = input('Select atlas: ');

if in4 == 1
    atl = 'Desikan-Killiany';
elseif in4 == 2
    atl = 'Destrieux';
elseif in4 == 3
    atl = 'Mindboggle';
 elseif in4 == 4
    atl = 'Brodman';   
end

disp('---------------------------');

leg = [];
for s = 1:size(path,1)
    
    [CT_lh,CT_rh, label] = sinead_ctstat(path(s,:), in2, in3, in4, s);
    % Average of whole brain
    CT_all = CT_rh(:,end:-1:1) + CT_lh(:,end:-1:1);
    
    s_thickAve_all{s} = CT_all; 
    s_thickAve_rh{s} = CT_rh;
    s_thickAve_lh{s} = CT_lh;    
    
    mTh_all(s,:) = mean(CT_all,2);  stdTh_all(s,:) = std(CT_all');
    mTh_rh(s,:)  = mean(CT_rh,2);   stdTh_rh(s,:) = std(CT_rh');
    mTh_lh(s,:)  = mean(CT_lh,2);   stdTh_lh(s,:) = std(CT_lh');
    
    leg = [leg;['G', num2str(s)]]; 
end

%% Cortical tickness values
CTV.whole = mTh_all; 
CTV.lh = mTh_lh;
CTV.rh = mTh_rh;

fCTV.whole = CT_all;
fCTV.lh    = CT_lh;
fCTV.rh    = CT_rh;

%% whole brain
% figure
% h = barwitherr(stdTh_all', mTh_all');    % Plot with errorbars
% % errorbar(mTh',stdTh','rx')
% set(gca,'Xtick', 1:34,'XtickLabel',label);
% legend(leg)
% view([90 -90])
% box off
% set(gca,'color','none');
% title('Whole brain, average of CT for all subjects (with std)');
% set(gcf, 'Position', [800   100   800   700]);
% % set(h,'edgecolor','none');
% h(2).FaceColor = [0,1,1];
% h(1).FaceColor = [1,1,0];


fh=findall(0,'type','figure');
lfh = length(fh);

figure(lfh+1)
subplot 131
h1 = barh(mTh_all');    % Plot with errorbars
legend(leg)
% errorbar(mTh',stdTh','rx')
set(gca,'Ytick', 1:length(mTh_all),'YtickLabel',1:length(mTh_all));
box off
set(gca,'color','none');
title('Whole brain');
set(gcf, 'Position', [800   100   1200   1000]);
ylabel('ROI');
xlabel('mm');
h1(1).FaceColor = col;

% Grand mean of cortical thickness
GmTh = mean(mTh_all,2); GstdTh = std(mTh_all');
figure(lfh+2)
subplot 131
h = barwitherr(GstdTh', GmTh);    % Plot with errorbars
box off
set(gca,'color','none');
title('Whole brain, average'); % Average over all ROIs and all subjects
% set(gcf, 'Position', [800   100   400   500]);
ylabel('mm');
xlabel('group');
% h.FaceColor = [0,1,1];

%% RH
figure(lfh+1)
subplot 132
h1 = barh(mTh_rh');    % Plot with errorbars
legend(leg)
% errorbar(mTh',stdTh','rx')
set(gca,'Ytick', 1:length(mTh_all),'YtickLabel',1:length(mTh_all));
box off
set(gca,'color','none');
title('RH');
ylabel('ROI');
xlabel('mm');
h1(1).FaceColor = col;

% Grand mean of cortical thickness
GmTh = mean(mTh_rh,2); GstdTh = std(mTh_rh');
figure(lfh+2)
subplot 132
h = barwitherr(GstdTh', GmTh);    % Plot with errorbars
box off
set(gca,'color','none');
title('RH, average'); % Average over all ROIs and all subjects
% set(gcf, 'Position', [800   100   400   500]);
ylabel('mm');
xlabel('group');
% h.FaceColor = [0,1,1];

%% LH
figure(lfh+1)
subplot 133
h1 = barh(mTh_lh');    % Plot with errorbars
legend(leg)
% errorbar(mTh',stdTh','rx')
set(gca,'Ytick', 1:length(mTh_all),'YtickLabel',1:length(mTh_all));
box off
set(gca,'color','none');
title('LH');
ylabel('ROI');
xlabel('mm');
% set(gcf, 'Position', [800   100   800   700]);
% set(h1,'edgecolor','none');
% h1(1).FaceColor = [0,1,1];
h1(1).FaceColor = col;

% Grand mean of cortical thickness
GmTh = mean(mTh_lh,2); GstdTh = std(mTh_lh');
figure(lfh+2)
subplot 133
h = barwitherr(GstdTh', GmTh);    % Plot with errorbars
box off
set(gca,'color','none');
title('LH, average'); % Average over all ROIs and all subjects
set(gcf, 'Position', [800   300   800   300]);
ylabel('mm');
xlabel('group');
% h.FaceColor = [0,1,1];

B = num2cell(1:length(label))';
ROI = cell2table([B,label])

% Save data
if size(path,1)> 1
    k = strfind(path(1,:), '\');
    npath = path(1,1:k(end)-1);
else
    npath = path;
end
save([npath,'\',atl,'_CT.mat'],'CTV','fCTV','label'); 
display (['cortical thickness values were saved at, ',npath]);
display (['and with the name of, ',atl,'_CT.mat']);

