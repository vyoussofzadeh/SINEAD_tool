function fig = sinead_machinelearning()
% ___________________________________________________________________________
% SINEAD (Software Integrating NEuroimaging And other Data)
%
% Copyright 2016 ISRC-Ulster
% Reference 
% Youssofzadeh et al, Multi-kernel learning with Dartel enhances
% combined MRI-PET classification and prediction
% of Alzheimer�s disease: group and individual
% data analyses, submitted to Human Brain Mapping 
% 
% 
% v1.0 Vahab Youssofzadeh 05/06/2016
% ___________________________________________________________________________
disp('Machine learning (PRoNTo) ...')
r = 50;
F = 10;
h0 = figure('Color',[1 1 1], ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[850 250 390 280], ...
	'Tag','Main', ...
	'NumberTitle','off',...
	'Name','ToolBox : SINEAD v.1', ...
    'MenuBar','none', ...
	'ToolBar','none');
h1 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',[0.7020 0.5072 0.6014], ...
	'Position',[72 85+r 166 16], ...
	'String','Data selection', ...
	'CallBack','sinead_machinelearning_datasel;');
h2 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',[0.7020 0.5072 0.6014], ...
	'Position',[72 60+r 166 16], ...
	'String','Building linear kernels (feature extraction)', ...
	'CallBack','sinead_machinelearning_fe;');
h3 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',[0.7020 0.5072 0.6014], ...
	'Position',[72 35+r 166 16], ...
	'String','Model selection', ...
	'CallBack','sinead_machinelearning_Modelsel;');
h4 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',[0.7020 0.5072 0.6014], ...
	'Position',[72 10+r 166 16], ...
	'String','Disply results & stats', ...
	'CallBack','sinead_machinelearning_Results');
h5 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',[0.7020 0.5072 0.6014], ...
	'Position',[72 r-15 166 16], ...
	'String','Compute weights', ...
	'CallBack','sinead_machinelearning_CompWeights');
h6 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',[0.7020 0.5072 0.6014], ...
	'Position',[72 r-40 166 16], ...
	'String','Disply weights', ...
	'CallBack','sinead_machinelearning_DispWeights');
h7 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'FontSize',F, ...
	'ListboxTop',0, ...
	'Position',[16 100+r 280 36], ...
	'String','Machine learning (PRoNTo)', ...
	'Style','text', ...
	'Tag','StaticText5');
if nargout > 0, fig = h0; end
