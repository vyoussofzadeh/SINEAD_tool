function [l_meanthick,r_meanthick] = cadsum_ctview(path)
% ___________________________________________________________________________
% Machine learning for Alzheimer's disease (MLAD)
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
disp('Plotting cortical tickness ...')

datatype = '*lh.aparc.stats';
files_tick_lh = cadsum_findfiles (path,datatype);


sufpath_rh = [path,'\surf\rh.orig'];
Surf = fs_read_surf(sufpath_rh);

ticknesspath_rh = [path,'\surf\rh.w-g.pct.mgh'];
r_tickness = fs_read_Y(ticknesspath_rh);
r_meanthick = mean(r_tickness);
figure,
subplot 121
plot(r_tickness); title('R tickness')

ticknesspath_lh = [path,'\surf\lh.w-g.pct.mgh'];
l_tickness = fs_read_Y(ticknesspath_lh);
l_meanthick = mean(l_tickness);
subplot 122
plot(l_tickness); title('L tickness');

surf_pial_path_lh = [path,'\surf\lh.pial'];
surf_pial_path_rh = [path,'\surf\rh.pial'];

s = SurfStatReadSurf( {surf_pial_path_lh, surf_pial_path_rh} );

tickness_pial_path_lh = [path,'\surf\lh.thickness'];
tickness_pial_path_rh = [path,'\surf\rh.thickness'];

disp('');
disp('-----------------');
disp('1-Both hemisphres');
disp('2-Left hemisphre');
disp('3-Right hemisphre');
disp('                 ');
in = input('Select hemisphre 1,2 or 3? ');

if in==1
    t = SurfStatReadData( {tickness_pial_path_lh, tickness_pial_path_rh} );
    
    SurfStatView( t, s, 'Whole brain cort thick (mm)' );
    % SurfStatView( t, s, 'Cort Thick (mm), FreeSurfer data','black' );
    SurfStatColormap( 'jet' );
    SurfStatColLim( [0 5] );
    
    SurfStatResels(s);
    
elseif in==2
    
    % Left side
    s_L = SurfStatReadSurf(surf_pial_path_lh);
    t_L = SurfStatReadData(tickness_pial_path_lh);
    
    figure
    SurfStatView( t_L, s_L, 'Left hemisphere cort thick (mm), Subj_L');
    % SurfStatView( t_L, s_L, 'Left hemisphere cort thick (mm), Subj_L', 'black' );
    SurfStatColormap( 'jet' );
    SurfStatColLim( [0 5] );
    
elseif in==3
    
    % Right side
    s_R = SurfStatReadSurf(surf_pial_path_rh);
    t_R = SurfStatReadData(tickness_pial_path_rh);
    figure
    SurfStatView( t_R, s_R, 'Right hemisphere cort thick (mm), Subj_R');
    % SurfStatView( t_R, s_R, 'Right hemisphere cort thick (mm), Subj_R', 'black' );
    SurfStatColormap( 'jet' );
    SurfStatColLim( [0 5] );
end
end