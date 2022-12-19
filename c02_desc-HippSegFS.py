'''
 # @ Author: Feng Sang
 # @ Create Time: 2022-03-31 17:26:25
 # @ Modified by: Feng Sang
 # @ Modified time: 2022-03-31 17:28:38
 # @ Description: Hippocampus subfields segment by FreeSurfer.
'''

import os
from os.path import join as opj
import glob
from re import sub
import subprocess
import logging
logging.basicConfig(
    level = logging.INFO,
    format = '%(asctime)s %(message)s',
    datefmt  = '%Y-%m-%d %A %H:%M:%S: '
    )

def run(sub_dir, sub_id, simg_path):
    cli = (
        '#! /bin/bash\n\n'
        f'singularity exec -B {sub_dir}:/opt/freesurfer/subjects/ -e {simg_path} recon-all -s {sub_id} -hippocampal-subfields-T1\n\n'
        'echo "Congratulation! The job is finished!"\n\n'
    )

    try:
        p = subprocess.Popen(cli, encoding = 'utf-8', shell = True, stdout = subprocess.PIPE, stderr = subprocess.STDOUT)
        while True:
            line = p.stdout.readline()
            logging.info(line)
            if not line: 
                break
    except subprocess.CalledProcessError as err:
        logging.error('Error: ', err)


if __name__ == '__main__':
    # der_root = 'Derivation/freesurfer'
    der_root = '/home/sangfeng/Desktop/UKBiobank/Der34/freesurfer'
    simg_path = '/home/sangfeng/Desktop/UKBiobank/Envs/fmriprep-20.1.3.img'
    for i in glob.glob(opj(der_root, 'sub-*')):
        sub_id = os.path.split(i)[-1]
        logging.info(sub_id)
        
        # if the job has been finished.
        if os.path.exists(opj(i, 'mri', 'lh.hippoSfVolumes-T1.v10.txt')):
            continue
        
        run(der_root, sub_id, simg_path)
        