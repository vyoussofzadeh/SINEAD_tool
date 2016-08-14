# SINEAD_tool
Software Integrating NEuroimaging And other Data (SINEAD) is a MATLAB graphical user interface (GUI) tool for automated computational analysis of brain imaging data. 
SINEAD integrates various commonly used brain imaging and machine learning software. 
The GUI is sufficiently easy for researchers and clinicians to pick up and use. 
As a case study, we use the software for Alzheimer’s disease (AD) classification and prediction with combined positron emission tomography (PET) and magnetic resonance imaging (MRI) data and a set of machine learning algorithms.

Currently, the software prototype integrates, the standard separate software tools, 
SPM (www.fil.ion.ucl.ac.uk/spm/) for preprocessing of imaging data,
, PRoNTO (www.mlnl.cs.ucl.ac.uk/pronto) for machine learning and combined analysis of imaging data,
,	Surfstat (http://www.math.mcgill.ca/keith/surfstat/), and freesurfer (http://freesurfer.net/) for cortical thickness analysis, 
and MATLAB statistical toolbox (http://uk.mathworks.com/products/statistics). 
The generality of the software framework allows integration and joint processing of imaging with non-imaging data such as genotypes, psychological tests, and lifestyle, which may provide additional information to disease signature and risk. 
