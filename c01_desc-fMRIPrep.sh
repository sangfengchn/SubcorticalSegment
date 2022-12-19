###
 # @Author: Feng Sang (sangfeng@mail.bnu.edu.cn)
 # @Date: 2022-03-06 09:06:13
 # @LastEditTime: 2022-03-06 16:28:10
 # @FilePath: /D_desc-UKB/Analysis/a01_desc-Preprocess/c02_desc-fMRIPrep.sh
### 
#! /usr/bin/bash

echo "Hello!\n"

QUE="34"

RAWDATA="Raw${QUE}"
DERROOT="Der${QUE}"
WKROOT="Tmp${QUE}"

SIMGPATH="Envs/fmriprep-20.1.3.img"
NUMPROC=6

SUBIDs="["
for SUB in `echo ${RAWDATA}/sub-*`
do
    SUBID=${SUB#*sub-}
    SUBIDs="${SUBIDs}'${SUBID}',"
done
SUBIDs="${SUBIDs}]"

# SUBIDs=${SUBIDs/,]/]}

echo ${SUBIDs}

singularity exec ${SIMGPATH} smriprep ${RAWDATA}/ ${DERROOT}/ participant \
    -w ${WKROOT}\
    --output-spaces MNI152NLin2009cAsym:res-1 fsaverage:den-164k \
    --write-graph \
    --verbose \
    --nprocs ${NUMPROC} \
    --omp-nthreads ${NUMPROC}

echo "Congraduation! Jobs have been finished."
