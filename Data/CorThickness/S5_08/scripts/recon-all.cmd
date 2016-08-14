
 mri_convert /media/sf_AIBL_Data/5/MPRAGE_ADNI_confirmed/2008-10-03_10_14_13.0/S78675/AIBL_5_MR_MPRAGE_ADNI_confirmed__br_raw_20100118121651368_1_S78675_I164081.nii /usr/local/freesurfer/subjects/S5_08/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor Wed May 25 04:12:18 EDT 2016

 cp /usr/local/freesurfer/subjects/S5_08/mri/orig/001.mgz /usr/local/freesurfer/subjects/S5_08/mri/rawavg.mgz 


 mri_convert /usr/local/freesurfer/subjects/S5_08/mri/rawavg.mgz /usr/local/freesurfer/subjects/S5_08/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /usr/local/freesurfer/subjects/S5_08/mri/transforms/talairach.xfm /usr/local/freesurfer/subjects/S5_08/mri/orig.mgz /usr/local/freesurfer/subjects/S5_08/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Wed May 25 04:13:33 EDT 2016

 mri_nu_correct.mni --n 1 --proto-iters 1000 --distance 50 --no-rescale --i orig.mgz --o orig_nu.mgz 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 


 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection Wed May 25 04:25:43 EDT 2016

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /usr/local/freesurfer/bin/extract_talairach_avi_QA.awk /usr/local/freesurfer/subjects/S5_08/mri/transforms/talairach_avi.log 


 tal_QC_AZS /usr/local/freesurfer/subjects/S5_08/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Wed May 25 04:25:44 EDT 2016

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 


 mri_add_xform_to_header -c /usr/local/freesurfer/subjects/S5_08/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Wed May 25 04:33:10 EDT 2016

 mri_normalize -g 1 nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping Wed May 25 04:46:05 EDT 2016

 mri_em_register -skull nu.mgz /usr/local/freesurfer/average/RB_all_withskull_2008-03-26.gca transforms/talairach_with_skull.lta 


 mri_watershed -T1 -brain_atlas /usr/local/freesurfer/average/RB_all_withskull_2008-03-26.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration Wed May 25 07:08:25 EDT 2016

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /usr/local/freesurfer/average/RB_all_2008-03-26.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Wed May 25 09:44:58 EDT 2016

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /usr/local/freesurfer/average/RB_all_2008-03-26.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Wed May 25 09:53:53 EDT 2016

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /usr/local/freesurfer/average/RB_all_2008-03-26.gca transforms/talairach.m3z 

#--------------------------------------
#@# CA Reg Inv Thu May 26 01:32:12 EDT 2016

 mri_ca_register -invert-and-save transforms/talairach.m3z 

#--------------------------------------
#@# Remove Neck Thu May 26 01:37:07 EDT 2016

 mri_remove_neck -radius 25 nu.mgz transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2008-03-26.gca nu_noneck.mgz 

#--------------------------------------
#@# SkullLTA Thu May 26 01:42:53 EDT 2016

 mri_em_register -skull -t transforms/talairach.lta nu_noneck.mgz /usr/local/freesurfer/average/RB_all_withskull_2008-03-26.gca transforms/talairach_with_skull_2.lta 

#--------------------------------------
#@# SubCort Seg Thu May 26 04:35:38 EDT 2016

 mri_ca_label -align norm.mgz transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2008-03-26.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /usr/local/freesurfer/subjects/S5_08/mri/transforms/cc_up.lta S5_08 

#--------------------------------------
#@# Merge ASeg Thu May 26 06:42:34 EDT 2016

 cp aseg.auto.mgz aseg.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Thu May 26 06:42:34 EDT 2016

 mri_normalize -aseg aseg.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Thu May 26 07:03:58 EDT 2016

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Thu May 26 07:04:13 EDT 2016

 mri_segment brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Thu May 26 07:16:56 EDT 2016

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 

#--------------------------------------------
#@# Tessellate lh Thu May 26 07:21:44 EDT 2016

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Thu May 26 07:22:22 EDT 2016

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Thu May 26 07:22:37 EDT 2016

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Thu May 26 07:24:48 EDT 2016

 mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology lh Thu May 26 07:43:43 EDT 2016

 cp ../surf/lh.orig.nofix ../surf/lh.orig 


 cp ../surf/lh.inflated.nofix ../surf/lh.inflated 


 mris_fix_topology -mgz -sphere qsphere.nofix -ga -seed 1234 S5_08 lh 


 mris_euler_number ../surf/lh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm ../surf/lh.inflated 

#--------------------------------------------
#@# Make White Surf lh Thu May 26 09:54:34 EDT 2016

 mris_make_surfaces -noaparc -whiteonly -mgz -T1 brain.finalsurfs S5_08 lh 

#--------------------------------------------
#@# Smooth2 lh Thu May 26 10:24:28 EDT 2016

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white ../surf/lh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Thu May 26 10:24:45 EDT 2016

 mris_inflate ../surf/lh.smoothwm ../surf/lh.inflated 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 ../surf/lh.inflated 


#-----------------------------------------
#@# Curvature Stats lh Thu May 26 10:36:22 EDT 2016

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm S5_08 lh curv sulc 

#--------------------------------------------
#@# Sphere lh Thu May 26 10:36:46 EDT 2016

 mris_sphere -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Surf Reg lh Thu May 26 14:18:24 EDT 2016

 mris_register -curv ../surf/lh.sphere /usr/local/freesurfer/average/lh.average.curvature.filled.buckner40.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Thu May 26 16:03:08 EDT 2016

 mris_jacobian ../surf/lh.white ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Thu May 26 16:03:16 EDT 2016

 mrisp_paint -a 5 /usr/local/freesurfer/average/lh.average.curvature.filled.buckner40.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Thu May 26 16:03:25 EDT 2016

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 S5_08 lh ../surf/lh.sphere.reg /usr/local/freesurfer/average/lh.curvature.buckner40.filled.desikan_killiany.2010-03-25.gcs ../label/lh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf lh Thu May 26 16:06:40 EDT 2016

 mris_make_surfaces -white NOWRITE -mgz -T1 brain.finalsurfs S5_08 lh 

#--------------------------------------------
#@# Surf Volume lh Thu May 26 16:58:08 EDT 2016

 mris_calc -o lh.area.mid lh.area add lh.area.pial 


 mris_calc -o lh.area.mid lh.area.mid div 2 


 mris_calc -o lh.volume lh.area.mid mul lh.thickness 

#-----------------------------------------
#@# WM/GM Contrast lh Thu May 26 16:58:09 EDT 2016

 pctsurfcon --s S5_08 --lh-only 

#-----------------------------------------
#@# Parcellation Stats lh Thu May 26 16:58:39 EDT 2016

 mris_anatomical_stats -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab S5_08 lh white 

#-----------------------------------------
#@# Cortical Parc 2 lh Thu May 26 16:59:49 EDT 2016

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 S5_08 lh ../surf/lh.sphere.reg /usr/local/freesurfer/average/lh.destrieux.simple.2009-07-29.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh Thu May 26 17:03:58 EDT 2016

 mris_anatomical_stats -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab S5_08 lh white 

#-----------------------------------------
#@# Cortical Parc 3 lh Thu May 26 17:05:18 EDT 2016

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 S5_08 lh ../surf/lh.sphere.reg /usr/local/freesurfer/average/lh.DKTatlas40.gcs ../label/lh.aparc.DKTatlas40.annot 

#-----------------------------------------
#@# Parcellation Stats 3 lh Thu May 26 17:08:47 EDT 2016

 mris_anatomical_stats -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas40.stats -b -a ../label/lh.aparc.DKTatlas40.annot -c ../label/aparc.annot.DKTatlas40.ctab S5_08 lh white 

#--------------------------------------------
#@# Tessellate rh Thu May 26 17:10:01 EDT 2016

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 rh Thu May 26 17:10:33 EDT 2016

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 rh Thu May 26 17:10:49 EDT 2016

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere rh Thu May 26 17:12:43 EDT 2016

 mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology rh Thu May 26 17:30:13 EDT 2016

 cp ../surf/rh.orig.nofix ../surf/rh.orig 


 cp ../surf/rh.inflated.nofix ../surf/rh.inflated 


 mris_fix_topology -mgz -sphere qsphere.nofix -ga -seed 1234 S5_08 rh 


 mris_euler_number ../surf/rh.orig 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm ../surf/rh.inflated 

#--------------------------------------------
#@# Make White Surf rh Thu May 26 19:45:10 EDT 2016

 mris_make_surfaces -noaparc -whiteonly -mgz -T1 brain.finalsurfs S5_08 rh 

#--------------------------------------------
#@# Smooth2 rh Thu May 26 20:09:11 EDT 2016

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 rh Thu May 26 20:09:28 EDT 2016

 mris_inflate ../surf/rh.smoothwm ../surf/rh.inflated 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 ../surf/rh.inflated 


#-----------------------------------------
#@# Curvature Stats rh Thu May 26 20:18:49 EDT 2016

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm S5_08 rh curv sulc 

#--------------------------------------------
#@# Sphere rh Thu May 26 20:19:03 EDT 2016

 mris_sphere -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg rh Thu May 26 23:35:18 EDT 2016

 mris_register -curv ../surf/rh.sphere /usr/local/freesurfer/average/rh.average.curvature.filled.buckner40.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white rh Fri May 27 01:12:04 EDT 2016

 mris_jacobian ../surf/rh.white ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv rh Fri May 27 01:12:11 EDT 2016

 mrisp_paint -a 5 /usr/local/freesurfer/average/rh.average.curvature.filled.buckner40.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc rh Fri May 27 01:12:17 EDT 2016

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 S5_08 rh ../surf/rh.sphere.reg /usr/local/freesurfer/average/rh.curvature.buckner40.filled.desikan_killiany.2010-03-25.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf rh Fri May 27 01:15:10 EDT 2016

 mris_make_surfaces -white NOWRITE -mgz -T1 brain.finalsurfs S5_08 rh 

#--------------------------------------------
#@# Surf Volume rh Fri May 27 02:02:07 EDT 2016

 mris_calc -o rh.area.mid rh.area add rh.area.pial 


 mris_calc -o rh.area.mid rh.area.mid div 2 


 mris_calc -o rh.volume rh.area.mid mul rh.thickness 

#-----------------------------------------
#@# WM/GM Contrast rh Fri May 27 02:02:08 EDT 2016

 pctsurfcon --s S5_08 --rh-only 

#-----------------------------------------
#@# Parcellation Stats rh Fri May 27 02:02:39 EDT 2016

 mris_anatomical_stats -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab S5_08 rh white 

#-----------------------------------------
#@# Cortical Parc 2 rh Fri May 27 02:03:34 EDT 2016

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 S5_08 rh ../surf/rh.sphere.reg /usr/local/freesurfer/average/rh.destrieux.simple.2009-07-29.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 rh Fri May 27 02:07:22 EDT 2016

 mris_anatomical_stats -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab S5_08 rh white 

#-----------------------------------------
#@# Cortical Parc 3 rh Fri May 27 02:08:23 EDT 2016

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.mgz -seed 1234 S5_08 rh ../surf/rh.sphere.reg /usr/local/freesurfer/average/rh.DKTatlas40.gcs ../label/rh.aparc.DKTatlas40.annot 

#-----------------------------------------
#@# Parcellation Stats 3 rh Fri May 27 02:11:16 EDT 2016

 mris_anatomical_stats -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas40.stats -b -a ../label/rh.aparc.DKTatlas40.annot -c ../label/aparc.annot.DKTatlas40.ctab S5_08 rh white 

#--------------------------------------------
#@# Cortical ribbon mask Fri May 27 02:12:10 EDT 2016

 mris_volmask --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon S5_08 

#--------------------------------------------
#@# ASeg Stats Fri May 27 03:11:59 EDT 2016

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /usr/local/freesurfer/ASegStatsLUT.txt --subject S5_08 

#-----------------------------------------
#@# AParc-to-ASeg Fri May 27 03:24:46 EDT 2016

 mri_aparc2aseg --s S5_08 --volmask 


 mri_aparc2aseg --s S5_08 --volmask --a2009s 

#-----------------------------------------
#@# WMParc Fri May 27 03:33:16 EDT 2016

 mri_aparc2aseg --s S5_08 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject S5_08 --surf-wm-vol --ctab /usr/local/freesurfer/WMParcStatsLUT.txt --etiv 

#--------------------------------------------
#@# BA Labels lh Fri May 27 04:04:16 EDT 2016

 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA1.label --trgsubject S5_08 --trglabel ./lh.BA1.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA2.label --trgsubject S5_08 --trglabel ./lh.BA2.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA3a.label --trgsubject S5_08 --trglabel ./lh.BA3a.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA3b.label --trgsubject S5_08 --trglabel ./lh.BA3b.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA4a.label --trgsubject S5_08 --trglabel ./lh.BA4a.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA4p.label --trgsubject S5_08 --trglabel ./lh.BA4p.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA6.label --trgsubject S5_08 --trglabel ./lh.BA6.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA44.label --trgsubject S5_08 --trglabel ./lh.BA44.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA45.label --trgsubject S5_08 --trglabel ./lh.BA45.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.V1.label --trgsubject S5_08 --trglabel ./lh.V1.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.V2.label --trgsubject S5_08 --trglabel ./lh.V2.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.MT.label --trgsubject S5_08 --trglabel ./lh.MT.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.perirhinal.label --trgsubject S5_08 --trglabel ./lh.perirhinal.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA1.thresh.label --trgsubject S5_08 --trglabel ./lh.BA1.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA2.thresh.label --trgsubject S5_08 --trglabel ./lh.BA2.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA3a.thresh.label --trgsubject S5_08 --trglabel ./lh.BA3a.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA3b.thresh.label --trgsubject S5_08 --trglabel ./lh.BA3b.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA4a.thresh.label --trgsubject S5_08 --trglabel ./lh.BA4a.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA4p.thresh.label --trgsubject S5_08 --trglabel ./lh.BA4p.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA6.thresh.label --trgsubject S5_08 --trglabel ./lh.BA6.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA44.thresh.label --trgsubject S5_08 --trglabel ./lh.BA44.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA45.thresh.label --trgsubject S5_08 --trglabel ./lh.BA45.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.V1.thresh.label --trgsubject S5_08 --trglabel ./lh.V1.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.V2.thresh.label --trgsubject S5_08 --trglabel ./lh.V2.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.MT.thresh.label --trgsubject S5_08 --trglabel ./lh.MT.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s S5_08 --hemi lh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l lh.BA1.label --l lh.BA2.label --l lh.BA3a.label --l lh.BA3b.label --l lh.BA4a.label --l lh.BA4p.label --l lh.BA6.label --l lh.BA44.label --l lh.BA45.label --l lh.V1.label --l lh.V2.label --l lh.MT.label --l lh.perirhinal.label --a BA --maxstatwinner --noverbose 


 mris_label2annot --s S5_08 --hemi lh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l lh.BA1.thresh.label --l lh.BA2.thresh.label --l lh.BA3a.thresh.label --l lh.BA3b.thresh.label --l lh.BA4a.thresh.label --l lh.BA4p.thresh.label --l lh.BA6.thresh.label --l lh.BA44.thresh.label --l lh.BA45.thresh.label --l lh.V1.thresh.label --l lh.V2.thresh.label --l lh.MT.thresh.label --a BA.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -mgz -f ../stats/lh.BA.stats -b -a ./lh.BA.annot -c ./BA.ctab S5_08 lh white 


 mris_anatomical_stats -mgz -f ../stats/lh.BA.thresh.stats -b -a ./lh.BA.thresh.annot -c ./BA.thresh.ctab S5_08 lh white 

#--------------------------------------------
#@# BA Labels rh Fri May 27 04:14:30 EDT 2016

 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA1.label --trgsubject S5_08 --trglabel ./rh.BA1.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA2.label --trgsubject S5_08 --trglabel ./rh.BA2.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA3a.label --trgsubject S5_08 --trglabel ./rh.BA3a.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA3b.label --trgsubject S5_08 --trglabel ./rh.BA3b.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA4a.label --trgsubject S5_08 --trglabel ./rh.BA4a.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA4p.label --trgsubject S5_08 --trglabel ./rh.BA4p.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA6.label --trgsubject S5_08 --trglabel ./rh.BA6.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA44.label --trgsubject S5_08 --trglabel ./rh.BA44.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA45.label --trgsubject S5_08 --trglabel ./rh.BA45.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.V1.label --trgsubject S5_08 --trglabel ./rh.V1.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.V2.label --trgsubject S5_08 --trglabel ./rh.V2.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.MT.label --trgsubject S5_08 --trglabel ./rh.MT.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.perirhinal.label --trgsubject S5_08 --trglabel ./rh.perirhinal.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA1.thresh.label --trgsubject S5_08 --trglabel ./rh.BA1.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA2.thresh.label --trgsubject S5_08 --trglabel ./rh.BA2.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA3a.thresh.label --trgsubject S5_08 --trglabel ./rh.BA3a.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA3b.thresh.label --trgsubject S5_08 --trglabel ./rh.BA3b.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA4a.thresh.label --trgsubject S5_08 --trglabel ./rh.BA4a.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA4p.thresh.label --trgsubject S5_08 --trglabel ./rh.BA4p.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA6.thresh.label --trgsubject S5_08 --trglabel ./rh.BA6.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA44.thresh.label --trgsubject S5_08 --trglabel ./rh.BA44.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA45.thresh.label --trgsubject S5_08 --trglabel ./rh.BA45.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.V1.thresh.label --trgsubject S5_08 --trglabel ./rh.V1.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.V2.thresh.label --trgsubject S5_08 --trglabel ./rh.V2.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.MT.thresh.label --trgsubject S5_08 --trglabel ./rh.MT.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s S5_08 --hemi rh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l rh.BA1.label --l rh.BA2.label --l rh.BA3a.label --l rh.BA3b.label --l rh.BA4a.label --l rh.BA4p.label --l rh.BA6.label --l rh.BA44.label --l rh.BA45.label --l rh.V1.label --l rh.V2.label --l rh.MT.label --l rh.perirhinal.label --a BA --maxstatwinner --noverbose 


 mris_label2annot --s S5_08 --hemi rh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l rh.BA1.thresh.label --l rh.BA2.thresh.label --l rh.BA3a.thresh.label --l rh.BA3b.thresh.label --l rh.BA4a.thresh.label --l rh.BA4p.thresh.label --l rh.BA6.thresh.label --l rh.BA44.thresh.label --l rh.BA45.thresh.label --l rh.V1.thresh.label --l rh.V2.thresh.label --l rh.MT.thresh.label --a BA.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -mgz -f ../stats/rh.BA.stats -b -a ./rh.BA.annot -c ./BA.ctab S5_08 rh white 


 mris_anatomical_stats -mgz -f ../stats/rh.BA.thresh.stats -b -a ./rh.BA.thresh.annot -c ./BA.thresh.ctab S5_08 rh white 

#--------------------------------------------
#@# Ex-vivo Entorhinal Cortex Label lh Fri May 27 04:24:46 EDT 2016

 mris_spherical_average -erode 1 -orig white -t 0.4 -o S5_08 label lh.entorhinal lh sphere.reg lh.EC_average lh.entorhinal_exvivo.label 


 mris_anatomical_stats -mgz -f ../stats/lh.entorhinal_exvivo.stats -b -l ./lh.entorhinal_exvivo.label S5_08 lh white 

#--------------------------------------------
#@# Ex-vivo Entorhinal Cortex Label rh Fri May 27 04:25:27 EDT 2016

 mris_spherical_average -erode 1 -orig white -t 0.4 -o S5_08 label rh.entorhinal rh sphere.reg rh.EC_average rh.entorhinal_exvivo.label 


 mris_anatomical_stats -mgz -f ../stats/rh.entorhinal_exvivo.stats -b -l ./rh.entorhinal_exvivo.label S5_08 rh white 

