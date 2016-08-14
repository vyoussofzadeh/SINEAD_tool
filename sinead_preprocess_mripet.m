function fig = sinead_preprocess_mripet()
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
disp('MRI/PET preprocessing ...')

spm_jobman('initcfg');
spm('CreateIntWin','on');
spm_jobman