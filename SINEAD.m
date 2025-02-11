function fig = SINEAD()
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
% email: v.youssofzadeh@ulster.ac.uk
% ___________________________________________________________________________
clc, close all

p = mfilename('fullpath'); 
% fileDirectory = fileparts(p);
cd(fileparts(p));
display('your current working path is,')
cd


r = 50;
F = 10; % fontsize

col = [0.9020 0.5072 0.1014];
h0 = figure(...
    'Color',[1 1 1], ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[50 250 390 280], ...
	'Tag','Main', ...
    'NumberTitle','off', ...
    'DoubleBuffer','on', ...
    'Visible','on', ...	
    'NumberTitle','off',...
    'MenuBar','none', ...
	'Name','ToolBox : SINEAD v.1', ...
    'ToolBar','none');
h1 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',col, ...
	'Position',[72 85+r 166 16], ...
	'String','MRI & PET preprocesssing', ...
	'CallBack','sinead_preprocess;');
h2 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',col, ...
	'Position',[72 60+r 166 16], ...
	'String','Machine learning', ...
	'CallBack','sinead_machinelearning;');
h3 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',col, ...
	'Position',[72 35+r 166 16], ...
	'String','Cortical thickness', ...
	'CallBack','sinead_CorThickness;');
h4 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',col, ...
	'Position',[72 10+r 166 16], ...
	'String','Feature analysis', ...
	'CallBack','sinead_featureanalysis');
h5 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',col, ...
	'Position',[72 r-15 166 16], ...
	'String','Close', ...
	'CallBack','sinead_closeall');
h6 = uicontrol('Parent',h0, ...
    'Fontsize', F, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'FontSize',11, ...
	'ListboxTop',0, ...
	'Position',[16 100+r 280 36], ...
	'String',['                      SINEAD                           ';
              '  (Software Integrating NEuroimaging And other Data)   '], ...
	'Style','text', ...
	'Tag','StaticText5');
if nargout > 0, fig = h0; end