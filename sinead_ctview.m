function [l_meanthick,r_meanthick] = sinead_ctview(path)
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
disp('Plotting cortical tickness ...')

datatype = '*rh.w-g.pct.mgh';
ticknesspath_rh = sinead_findfiles (path,datatype);

datatype = '*lh.w-g.pct.mgh';
ticknesspath_lh = sinead_findfiles (path,datatype);

for j=1:size(ticknesspath_rh,2)
    
    r_tickness = fs_read_Y(ticknesspath_rh{j});
    r_meanthick = mean(r_tickness);
    figure,
    subplot 121
    plot(r_tickness); title('R tickness')
    l_tickness = fs_read_Y(ticknesspath_lh{j});
    l_meanthick = mean(l_tickness);
    subplot 122
    plot(l_tickness); title('L tickness');
    suplabel(['sample: ',num2str(j)]  ,'t');
end

datatype = '*rh.pial';
surf_pial_path_rh = sinead_findfiles (path,datatype);

datatype = '*lh.pial';
surf_pial_path_lh = sinead_findfiles (path,datatype);

datatype = '*rh.thickness';
tickness_pial_path_rh = sinead_findfiles (path,datatype);

datatype = '*lh.thickness';
tickness_pial_path_lh = sinead_findfiles (path,datatype);

disp('');
disp('-----------------');
disp('1-Both hemisphres');
disp('2-Left hemisphre');
disp('3-Right hemisphre');
disp('                 ');
in = input('Select hemisphre you want 1,2 or 3? ');

if in==1
    
    for j=1:size(surf_pial_path_rh,2)
        
        s{j} = SurfStatReadSurf( {surf_pial_path_lh{j}, surf_pial_path_rh{j}} );
        t{j} = SurfStatReadData( {tickness_pial_path_lh{j}, tickness_pial_path_rh{j}} );
        figure,
        SurfStatView( t{j}, s{j}, ['Whole brain cort thick (mm)',',S:',num2str(j)] );
        % SurfStatView( t, s, 'Cort Thick (mm), FreeSurfer data','black' );
        SurfStatColormap( 'jet' );
        SurfStatColLim( [0 5] );
    end
    %     SurfStatResels(s);
    
elseif in==2
    
    % Left side
    for j=1:size(surf_pial_path_rh,2)
        
        s{j} = SurfStatReadSurf(surf_pial_path_lh{j});
        t{j} = SurfStatReadData(tickness_pial_path_lh{j});
        figure,
        SurfStatView( t{j}, s{j}, ['Left hemisphere cort thick (mm)',',S:',num2str(j)] );
        % SurfStatView( t, s, 'Cort Thick (mm), FreeSurfer data','black' );
        SurfStatColormap( 'jet' );
        SurfStatColLim( [0 5] );
    end 
    
elseif in==3
    
    % Right side
    for j=1:size(surf_pial_path_rh,2)
        
        s{j} = SurfStatReadSurf(surf_pial_path_rh{j});
        t{j} = SurfStatReadData(tickness_pial_path_rh{j});
        figure,
        SurfStatView( t{j}, s{j}, ['Left hemisphere cort thick (mm)',',S:',num2str(j)] );
        % SurfStatView( t, s, 'Cort Thick (mm), FreeSurfer data','black' );
        SurfStatColormap( 'jet' );
        SurfStatColLim( [0 5] );
    end
end
end