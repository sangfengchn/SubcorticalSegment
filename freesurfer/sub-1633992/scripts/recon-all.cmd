

#---------------------------------
# New invocation of recon-all Fri Mar 25 16:06:16 UTC 2022 

 mri_convert /home/sangfeng/Desktop/UKBiobank/Raw34/sub-1633992/anat/sub-1633992_T1w.nii.gz /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor Fri Mar 25 16:06:23 UTC 2022

 cp /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/orig/001.mgz /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/rawavg.mgz 


 mri_convert /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/rawavg.mgz /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/transforms/talairach.xfm /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/orig.mgz /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Fri Mar 25 16:06:30 UTC 2022

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection Fri Mar 25 16:07:19 UTC 2022

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /opt/freesurfer/bin/extract_talairach_avi_QA.awk /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/transforms/talairach_avi.log 


 tal_QC_AZS /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Fri Mar 25 16:07:19 UTC 2022

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 


 mri_add_xform_to_header -c /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Fri Mar 25 16:08:17 UTC 2022

 mri_normalize -g 1 -mprage nu.mgz T1.mgz 



#---------------------------------
# New invocation of recon-all Fri Mar 25 16:10:01 UTC 2022 
#-------------------------------------
#@# EM Registration Fri Mar 25 16:10:01 UTC 2022

 mri_em_register -rusage /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Fri Mar 25 16:12:03 UTC 2022

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Fri Mar 25 16:13:03 UTC 2022

 mri_ca_register -rusage /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Fri Mar 25 17:20:33 UTC 2022

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /home/sangfeng/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/mri/transforms/cc_up.lta sub-1633992 

#--------------------------------------
#@# Merge ASeg Fri Mar 25 17:50:33 UTC 2022

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Fri Mar 25 17:50:33 UTC 2022

 mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Fri Mar 25 17:52:15 UTC 2022

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Fri Mar 25 17:52:18 UTC 2022

 mri_segment -mprage brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Fri Mar 25 17:53:30 UTC 2022

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 



#---------------------------------
# New invocation of recon-all Sun Mar 27 21:18:43 UTC 2022 
#--------------------------------------------
#@# Cortical ribbon mask Sun Mar 27 21:18:43 UTC 2022

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-1633992 



#---------------------------------
# New invocation of recon-all Tue Mar 29 06:27:11 UTC 2022 
#-----------------------------------------
#@# Relabel Hypointensities Tue Mar 29 06:27:11 UTC 2022

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc Tue Mar 29 06:27:22 UTC 2022

 mri_aparc2aseg --s sub-1633992 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# AParc-to-ASeg a2009s Tue Mar 29 06:29:59 UTC 2022

 mri_aparc2aseg --s sub-1633992 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Tue Mar 29 06:32:36 UTC 2022

 mri_aparc2aseg --s sub-1633992 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# APas-to-ASeg Tue Mar 29 06:35:12 UTC 2022

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats Tue Mar 29 06:35:15 UTC 2022

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /opt/freesurfer/ASegStatsLUT.txt --subject sub-1633992 

#-----------------------------------------
#@# WMParc Tue Mar 29 06:35:46 UTC 2022

 mri_aparc2aseg --s sub-1633992 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-1633992 --surf-wm-vol --ctab /opt/freesurfer/WMParcStatsLUT.txt --etiv 



#---------------------------------
# New invocation of recon-all Thu Mar 31 05:31:35 UTC 2022 


#---------------------------------
# New invocation of recon-all Thu Mar 31 05:39:07 UTC 2022 
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) left Thu Mar 31 05:39:09 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /opt/freesurfer/subjects left 

See log file: /opt/freesurfer/subjects/sub-1633992/scripts/hippocampal-subfields-T1.log
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) right Thu Mar 31 05:39:11 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /opt/freesurfer/subjects right 

See log file: /opt/freesurfer/subjects/sub-1633992/scripts/hippocampal-subfields-T1.log


#---------------------------------
# New invocation of recon-all Thu Mar 31 05:40:39 UTC 2022 
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) left Thu Mar 31 05:40:40 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /opt/freesurfer/subjects left 

See log file: /opt/freesurfer/subjects/sub-1633992/scripts/hippocampal-subfields-T1.log
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) right Thu Mar 31 05:40:42 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /opt/freesurfer/subjects right 

See log file: /opt/freesurfer/subjects/sub-1633992/scripts/hippocampal-subfields-T1.log


#---------------------------------
# New invocation of recon-all Thu Mar 31 06:25:50 UTC 2022 
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) left Thu Mar 31 06:25:51 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /opt/freesurfer/subjects left 

See log file: /opt/freesurfer/subjects/sub-1633992/scripts/hippocampal-subfields-T1.log
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) right Thu Mar 31 06:25:53 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /opt/freesurfer/subjects right 

See log file: /opt/freesurfer/subjects/sub-1633992/scripts/hippocampal-subfields-T1.log


#---------------------------------
# New invocation of recon-all Thu Mar 31 06:27:55 UTC 2022 
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) left Thu Mar 31 06:27:56 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /opt/freesurfer/subjects left 

See log file: /opt/freesurfer/subjects/sub-1633992/scripts/hippocampal-subfields-T1.log
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) right Thu Mar 31 06:27:58 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /opt/freesurfer/subjects right 

See log file: /opt/freesurfer/subjects/sub-1633992/scripts/hippocampal-subfields-T1.log


#---------------------------------
# New invocation of recon-all Thu Mar 31 06:30:38 UTC 2022 
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) left Thu Mar 31 06:30:39 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /mnt/Desktop/UKBiobank/Der34/freesurfer left 

See log file: /mnt/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/scripts/hippocampal-subfields-T1.log
#--------------------------------------------
#@# Hippocampal Subfields processing (T1 only) right Thu Mar 31 06:41:55 UTC 2022

 /opt/freesurfer/bin/segmentSF_T1.sh /opt/freesurfer/MCRv80 /opt/freesurfer sub-1633992 /mnt/Desktop/UKBiobank/Der34/freesurfer right 

See log file: /mnt/Desktop/UKBiobank/Der34/freesurfer/sub-1633992/scripts/hippocampal-subfields-T1.log
