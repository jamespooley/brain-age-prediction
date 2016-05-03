#!/bin/bash

set -e
set -u
set -o pipefail

DATA_DIR=~/projects/brain-age-prediction/data/abide
DLOAD_BASE=s3://fcp-indi/data/Projects/ABIDE_Initiative/Outputs/freesurfer/5.1

# Download Preprocessed ABIDE Data from S3 Bucket

measures=(GrayVol ThickAvg)

# awk sorcery to get subject IDs from phenotypic information spreadsheet
subj_list=$(awk -F "\"*,\"*" 'FNR>1{print $7}' ${DATA_DIR}/Phenotypic_V1_0b_preprocessed1.csv)

# if [ ! -d $DATA_DIR/${subj_id}/ ]; then
#   mkdir -p $DATA_DIR/${subj_id}
# fi

for subj_id in ${subj_list[@]}; do
  for hemisphere in lh rh; do
    if [ $subj_id != no_filename ] && [ ! -d ${DATA_DIR}/{subj_id}  ]; then
       duck --download ${DLOAD_BASE}/${subj_id}/stats/${hemisphere}.aparc.a2009s.stats \
                       $DATA_DIR/${subj_id}/${hemisphere}.aparc.a2009s.stats
    fi
  done
done

# Organize Tables of FreeSurfer Output Statistics

for measure in ${measures[@]}; do
  for hemisphere in lh rh; do
    aparcstats2table --subjects $subj_list \
                     --hemi $hemisphere \
                     --meas $measure \
                     --parc aparc.a2009s \
                     --tablefile ${DATA_DIR}/${hemisphere}.a2009s.${measure}
  done
done
