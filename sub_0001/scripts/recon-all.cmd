

#---------------------------------
# New invocation of recon-all Fri Jun  7 09:46:37 CEST 2024 

 mri_convert /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub-0001/anat/sub-01_T1w.nii /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor Fri Jun  7 09:46:41 CEST 2024

 cp /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/orig/001.mgz /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/rawavg.mgz 


 mri_info /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/rawavg.mgz 


 mri_convert /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/rawavg.mgz /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/transforms/talairach.xfm /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/orig.mgz /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/orig.mgz 


 mri_info /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Fri Jun  7 09:46:53 CEST 2024

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --ants-n4 --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

lta_convert --src orig.mgz --trg /home/hp/Documents/AUDITORY_MEG/freesurfer/average/mni305.cor.mgz --inxfm transforms/talairach.xfm --outlta transforms/talairach.xfm.lta --subject fsaverage --ltavox2vox
#--------------------------------------------
#@# Talairach Failure Detection Fri Jun  7 09:49:44 CEST 2024

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /home/hp/Documents/AUDITORY_MEG/freesurfer/bin/extract_talairach_avi_QA.awk /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/transforms/talairach_avi.log 


 tal_QC_AZS /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Fri Jun  7 09:49:44 CEST 2024

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 --ants-n4 


 mri_add_xform_to_header -c /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Fri Jun  7 09:52:27 CEST 2024

 mri_normalize -g 1 -seed 1234 -mprage nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping Fri Jun  7 09:53:43 CEST 2024

 mri_em_register -skull nu.mgz /home/hp/Documents/AUDITORY_MEG/freesurfer/average/RB_all_withskull_2020_01_02.gca transforms/talairach_with_skull.lta 


 mri_watershed -T1 -brain_atlas /home/hp/Documents/AUDITORY_MEG/freesurfer/average/RB_all_withskull_2020_01_02.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration Fri Jun  7 10:01:22 CEST 2024

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /home/hp/Documents/AUDITORY_MEG/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Fri Jun  7 10:06:40 CEST 2024

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /home/hp/Documents/AUDITORY_MEG/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Fri Jun  7 10:07:26 CEST 2024

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /home/hp/Documents/AUDITORY_MEG/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Fri Jun  7 11:43:50 CEST 2024

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /home/hp/Documents/AUDITORY_MEG/freesurfer/average/RB_all_2020-01-02.gca aseg.auto_noCCseg.mgz 

#--------------------------------------
#@# CC Seg Fri Jun  7 12:23:17 CEST 2024

 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/transforms/cc_up.lta sub_0001 

#--------------------------------------
#@# Merge ASeg Fri Jun  7 12:23:41 CEST 2024

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Fri Jun  7 12:23:41 CEST 2024

 mri_normalize -seed 1234 -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Fri Jun  7 12:25:36 CEST 2024

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Fri Jun  7 12:25:37 CEST 2024

 AntsDenoiseImageFs -i brain.mgz -o antsdn.brain.mgz 


 mri_segment -wsizemm 13 -mprage antsdn.brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Fri Jun  7 12:27:31 CEST 2024

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.presurf.mgz -ctab /home/hp/Documents/AUDITORY_MEG/freesurfer/SubCorticalMassLUT.txt wm.mgz filled.mgz 

 cp filled.mgz filled.auto.mgz
#--------------------------------------------
#@# Tessellate lh Fri Jun  7 12:28:24 CEST 2024

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh Fri Jun  7 12:28:28 CEST 2024

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Fri Jun  7 12:28:32 CEST 2024

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh Fri Jun  7 12:28:35 CEST 2024

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Fri Jun  7 12:28:37 CEST 2024

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh Fri Jun  7 12:28:56 CEST 2024

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Fri Jun  7 12:29:14 CEST 2024

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh Fri Jun  7 12:31:17 CEST 2024

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#@# Fix Topology lh Fri Jun  7 12:33:24 CEST 2024

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 sub_0001 lh 

#@# Fix Topology rh Fri Jun  7 12:35:52 CEST 2024

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 sub_0001 rh 


 mris_euler_number ../surf/lh.orig.premesh 


 mris_euler_number ../surf/rh.orig.premesh 


 mris_remesh --remesh --iters 3 --input /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.orig.premesh --output /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.orig 


 mris_remesh --remesh --iters 3 --input /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.orig.premesh --output /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm -f ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm -f ../surf/rh.inflated 

#--------------------------------------------
#@# AutoDetGWStats lh Fri Jun  7 12:40:15 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.lh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/lh.orig.premesh
#--------------------------------------------
#@# AutoDetGWStats rh Fri Jun  7 12:40:19 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.rh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/rh.orig.premesh
#--------------------------------------------
#@# WhitePreAparc lh Fri Jun  7 12:40:23 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --wm wm.mgz --threads 1 --invol brain.finalsurfs.mgz --lh --i ../surf/lh.orig --o ../surf/lh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# WhitePreAparc rh Fri Jun  7 12:43:54 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --wm wm.mgz --threads 1 --invol brain.finalsurfs.mgz --rh --i ../surf/rh.orig --o ../surf/rh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# CortexLabel lh Fri Jun  7 12:47:26 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 0 ../label/lh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg lh Fri Jun  7 12:47:39 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 1 ../label/lh.cortex+hipamyg.label
#--------------------------------------------
#@# CortexLabel rh Fri Jun  7 12:47:52 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 0 ../label/rh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg rh Fri Jun  7 12:48:06 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 1 ../label/rh.cortex+hipamyg.label
#--------------------------------------------
#@# Smooth2 lh Fri Jun  7 12:48:19 CEST 2024

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh Fri Jun  7 12:48:22 CEST 2024

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Fri Jun  7 12:48:25 CEST 2024

 mris_inflate ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh Fri Jun  7 12:48:47 CEST 2024

 mris_inflate ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh Fri Jun  7 12:49:09 CEST 2024

 mris_curvature -w -seed 1234 lh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh Fri Jun  7 12:49:49 CEST 2024

 mris_curvature -w -seed 1234 rh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 

#--------------------------------------------
#@# Sphere lh Fri Jun  7 12:50:30 CEST 2024

 mris_sphere -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh Fri Jun  7 12:58:54 CEST 2024

 mris_sphere -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh Fri Jun  7 13:07:52 CEST 2024

 mris_register -curv ../surf/lh.sphere /home/hp/Documents/AUDITORY_MEG/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 


 ln -sf lh.sphere.reg lh.fsaverage.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh Fri Jun  7 13:15:06 CEST 2024

 mris_register -curv ../surf/rh.sphere /home/hp/Documents/AUDITORY_MEG/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 


 ln -sf rh.sphere.reg rh.fsaverage.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Fri Jun  7 13:22:35 CEST 2024

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh Fri Jun  7 13:22:36 CEST 2024

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Fri Jun  7 13:22:37 CEST 2024

 mrisp_paint -a 5 /home/hp/Documents/AUDITORY_MEG/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh Fri Jun  7 13:22:38 CEST 2024

 mrisp_paint -a 5 /home/hp/Documents/AUDITORY_MEG/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Fri Jun  7 13:22:39 CEST 2024

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub_0001 lh ../surf/lh.sphere.reg /home/hp/Documents/AUDITORY_MEG/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh Fri Jun  7 13:22:49 CEST 2024

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub_0001 rh ../surf/rh.sphere.reg /home/hp/Documents/AUDITORY_MEG/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# WhiteSurfs lh Fri Jun  7 13:22:58 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 1 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white.preaparc --o ../surf/lh.white --white --nsmooth 0 --rip-label ../label/lh.cortex.label --rip-bg --rip-surf ../surf/lh.white.preaparc --aparc ../label/lh.aparc.annot
#--------------------------------------------
#@# WhiteSurfs rh Fri Jun  7 13:26:09 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 1 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white.preaparc --o ../surf/rh.white --white --nsmooth 0 --rip-label ../label/rh.cortex.label --rip-bg --rip-surf ../surf/rh.white.preaparc --aparc ../label/rh.aparc.annot
#--------------------------------------------
#@# T1PialSurf lh Fri Jun  7 13:29:20 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 1 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white --o ../surf/lh.pial.T1 --pial --nsmooth 0 --rip-label ../label/lh.cortex+hipamyg.label --pin-medial-wall ../label/lh.cortex.label --aparc ../label/lh.aparc.annot --repulse-surf ../surf/lh.white --white-surf ../surf/lh.white
#--------------------------------------------
#@# T1PialSurf rh Fri Jun  7 13:33:03 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 1 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white --o ../surf/rh.pial.T1 --pial --nsmooth 0 --rip-label ../label/rh.cortex+hipamyg.label --pin-medial-wall ../label/rh.cortex.label --aparc ../label/rh.aparc.annot --repulse-surf ../surf/rh.white --white-surf ../surf/rh.white
#@# white curv lh Fri Jun  7 13:36:49 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
#@# white area lh Fri Jun  7 13:36:51 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
#@# pial curv lh Fri Jun  7 13:36:52 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
#@# pial area lh Fri Jun  7 13:36:54 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
#@# thickness lh Fri Jun  7 13:36:55 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# area and vertex vol lh Fri Jun  7 13:37:23 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# white curv rh Fri Jun  7 13:37:25 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
#@# white area rh Fri Jun  7 13:37:27 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
#@# pial curv rh Fri Jun  7 13:37:28 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
#@# pial area rh Fri Jun  7 13:37:29 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
#@# thickness rh Fri Jun  7 13:37:30 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
#@# area and vertex vol rh Fri Jun  7 13:37:59 CEST 2024
cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness

#-----------------------------------------
#@# Curvature Stats lh Fri Jun  7 13:38:01 CEST 2024

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub_0001 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Fri Jun  7 13:38:04 CEST 2024

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub_0001 rh curv sulc 

#--------------------------------------------
#@# Cortical ribbon mask Fri Jun  7 13:38:06 CEST 2024

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub_0001 

#-----------------------------------------
#@# Cortical Parc 2 lh Fri Jun  7 13:44:59 CEST 2024

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub_0001 lh ../surf/lh.sphere.reg /home/hp/Documents/AUDITORY_MEG/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh Fri Jun  7 13:45:12 CEST 2024

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub_0001 rh ../surf/rh.sphere.reg /home/hp/Documents/AUDITORY_MEG/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 3 lh Fri Jun  7 13:45:25 CEST 2024

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub_0001 lh ../surf/lh.sphere.reg /home/hp/Documents/AUDITORY_MEG/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh Fri Jun  7 13:45:35 CEST 2024

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub_0001 rh ../surf/rh.sphere.reg /home/hp/Documents/AUDITORY_MEG/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# WM/GM Contrast lh Fri Jun  7 13:45:45 CEST 2024

 pctsurfcon --s sub_0001 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh Fri Jun  7 13:45:49 CEST 2024

 pctsurfcon --s sub_0001 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities Fri Jun  7 13:45:52 CEST 2024

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# APas-to-ASeg Fri Jun  7 13:46:07 CEST 2024

 mri_surf2volseg --o aseg.mgz --i aseg.presurf.hypos.mgz --fix-presurf-with-ribbon /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/mri/ribbon.mgz --threads 1 --lh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/lh.cortex.label --lh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.white --lh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.pial --rh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/rh.cortex.label --rh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.white --rh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.pial 


 mri_brainvol_stats sub_0001 

#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Jun  7 13:46:20 CEST 2024

 mri_surf2volseg --o aparc+aseg.mgz --label-cortex --i aseg.mgz --threads 1 --lh-annot /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/lh.aparc.annot 1000 --lh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/lh.cortex.label --lh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.white --lh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.pial --rh-annot /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/rh.aparc.annot 2000 --rh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/rh.cortex.label --rh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.white --rh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.a2009s Fri Jun  7 13:49:36 CEST 2024

 mri_surf2volseg --o aparc.a2009s+aseg.mgz --label-cortex --i aseg.mgz --threads 1 --lh-annot /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/lh.aparc.a2009s.annot 11100 --lh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/lh.cortex.label --lh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.white --lh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.pial --rh-annot /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/rh.aparc.a2009s.annot 12100 --rh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/rh.cortex.label --rh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.white --rh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.DKTatlas Fri Jun  7 13:52:51 CEST 2024

 mri_surf2volseg --o aparc.DKTatlas+aseg.mgz --label-cortex --i aseg.mgz --threads 1 --lh-annot /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/lh.aparc.DKTatlas.annot 1000 --lh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/lh.cortex.label --lh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.white --lh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.pial --rh-annot /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/rh.aparc.DKTatlas.annot 2000 --rh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/rh.cortex.label --rh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.white --rh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.pial 

#-----------------------------------------
#@# WMParc Fri Jun  7 13:56:13 CEST 2024

 mri_surf2volseg --o wmparc.mgz --label-wm --i aparc+aseg.mgz --threads 1 --lh-annot /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/lh.aparc.annot 3000 --lh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/lh.cortex.label --lh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.white --lh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/lh.pial --rh-annot /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/rh.aparc.annot 4000 --rh-cortex-mask /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/label/rh.cortex.label --rh-white /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.white --rh-pial /home/hp/Documents/AUDITORY_MEG/CTFDATASET/sub_0001/surf/rh.pial 


 mri_segstats --seed 1234 --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub_0001 --surf-wm-vol --ctab /home/hp/Documents/AUDITORY_MEG/freesurfer/WMParcStatsLUT.txt --etiv 

#-----------------------------------------
#@# Parcellation Stats lh Fri Jun  7 14:03:18 CEST 2024

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub_0001 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub_0001 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh Fri Jun  7 14:03:40 CEST 2024

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub_0001 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub_0001 rh pial 

#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Jun  7 14:04:00 CEST 2024

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub_0001 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Jun  7 14:04:12 CEST 2024

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub_0001 rh white 

#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Jun  7 14:04:24 CEST 2024

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub_0001 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Jun  7 14:04:35 CEST 2024

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub_0001 rh white 

#--------------------------------------------
#@# ASeg Stats Fri Jun  7 14:04:46 CEST 2024

 mri_segstats --seed 1234 --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /home/hp/Documents/AUDITORY_MEG/freesurfer/ASegStatsLUT.txt --subject sub_0001 

INFO: fsaverage subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to fsaverage subject...

 cd /home/hp/Documents/AUDITORY_MEG/CTFDATASET; ln -s /home/hp/Documents/AUDITORY_MEG/freesurfer/subjects/fsaverage; cd - 

#--------------------------------------------
#@# BA_exvivo Labels lh Fri Jun  7 14:08:10 CEST 2024

 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub_0001 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub_0001 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub_0001 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub_0001 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub_0001 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub_0001 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub_0001 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub_0001 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub_0001 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.V1_exvivo.label --trgsubject sub_0001 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.V2_exvivo.label --trgsubject sub_0001 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.MT_exvivo.label --trgsubject sub_0001 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub_0001 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub_0001 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.FG1.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./lh.FG1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.FG2.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./lh.FG2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.FG3.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./lh.FG3.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.FG4.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./lh.FG4.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.hOc1.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./lh.hOc1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.hOc2.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./lh.hOc2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.hOc3v.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./lh.hOc3v.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.hOc4v.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./lh.hOc4v.mpm.vpnl.label --hemi lh --regmethod surface 


 mris_label2annot --s sub_0001 --ctab /home/hp/Documents/AUDITORY_MEG/freesurfer/average/colortable_vpnl.txt --hemi lh --a mpm.vpnl --maxstatwinner --noverbose --l lh.FG1.mpm.vpnl.label --l lh.FG2.mpm.vpnl.label --l lh.FG3.mpm.vpnl.label --l lh.FG4.mpm.vpnl.label --l lh.hOc1.mpm.vpnl.label --l lh.hOc2.mpm.vpnl.label --l lh.hOc3v.mpm.vpnl.label --l lh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s sub_0001 --hemi lh --ctab /home/hp/Documents/AUDITORY_MEG/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.perirhinal_exvivo.label --l lh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub_0001 --hemi lh --ctab /home/hp/Documents/AUDITORY_MEG/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub_0001 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub_0001 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh Fri Jun  7 14:11:24 CEST 2024

 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub_0001 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub_0001 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub_0001 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub_0001 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub_0001 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub_0001 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub_0001 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub_0001 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub_0001 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.V1_exvivo.label --trgsubject sub_0001 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.V2_exvivo.label --trgsubject sub_0001 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.MT_exvivo.label --trgsubject sub_0001 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub_0001 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub_0001 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.FG1.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./rh.FG1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.FG2.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./rh.FG2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.FG3.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./rh.FG3.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.FG4.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./rh.FG4.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.hOc1.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./rh.hOc1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.hOc2.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./rh.hOc2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.hOc3v.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./rh.hOc3v.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.hOc4v.mpm.vpnl.label --trgsubject sub_0001 --trglabel ./rh.hOc4v.mpm.vpnl.label --hemi rh --regmethod surface 


 mris_label2annot --s sub_0001 --ctab /home/hp/Documents/AUDITORY_MEG/freesurfer/average/colortable_vpnl.txt --hemi rh --a mpm.vpnl --maxstatwinner --noverbose --l rh.FG1.mpm.vpnl.label --l rh.FG2.mpm.vpnl.label --l rh.FG3.mpm.vpnl.label --l rh.FG4.mpm.vpnl.label --l rh.hOc1.mpm.vpnl.label --l rh.hOc2.mpm.vpnl.label --l rh.hOc3v.mpm.vpnl.label --l rh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/hp/Documents/AUDITORY_MEG/CTFDATASET/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub_0001 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s sub_0001 --hemi rh --ctab /home/hp/Documents/AUDITORY_MEG/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.perirhinal_exvivo.label --l rh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub_0001 --hemi rh --ctab /home/hp/Documents/AUDITORY_MEG/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub_0001 rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub_0001 rh white 

