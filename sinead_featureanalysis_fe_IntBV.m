function fig = sinead_featureanalysis_fe_IntBV()
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
disp('Intracranial brain volumes (GM+WM+CSF) ...')

disp('please use SPM->Utils->Tissue Volumes ...')

spm_jobman('initcfg');
spm_jobman

disp('Intracranial brain volumes were computed and saved!')