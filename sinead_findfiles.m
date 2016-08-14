function [files_s] = sinead_findfiles (path, datatype)
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

[sub,~] = subdir(path);
D = [];
j = 1;
for i=1:length(sub),
    files{i} = dir( fullfile(sub{i},datatype) );
    if length(files{i})==1
        D(j) = i; 
        files_s{j} = [sub{i},'\',datatype(2:end)]; 
        j=j+1;
    end
end