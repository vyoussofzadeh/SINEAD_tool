function sinead_aveintersity(files)
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

%% check arguments
if nargin == 0
    files = spm_select(Inf,'image','Select image (PET) files');
end
%% main loop
for i=1:size(files,1)
    f1 = files(i,:);
    HeaderInfo = spm_vol(f1);
    img = spm_read_vols(HeaderInfo);
    img(isnan(img)) = 0; % use ~isfinite instead of isnan to replace +/-inf with zero
    ai(i,:) = mean(mean(mean(img)));
end
save AI ai files