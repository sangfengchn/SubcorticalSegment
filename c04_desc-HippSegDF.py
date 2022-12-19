'''
 # @ Author: Feng Sang
 # @ Create Time: 2022-04-02 10:53:42
 # @ Modified by: Feng Sang
 # @ Modified time: 2022-04-02 10:54:00
 # @ Description: The hippocampal subfields segmentation by Deep Falsh.
'''

import os
# ERRORe
# Unable to open file (file locking disabled on this file system (use HDF5_USE_FILE_LOCKING environment variable to override)
os.environ["HDF5_USE_FILE_LOCKING"] = 'FALSE'

import time
from os.path import join as opj
import glob
import re
import ants
from antspynet.utilities import deep_flash
import logging
logging.basicConfig(
    level = logging.INFO,
    format = '%(asctime)s %(message)s',
    datefmt  = '%Y-%m-%d %H:%M:%S: '
)

if __name__ == '__main__':
    proj_dir = '/home/sangfeng/Desktop/HipSub'
    # der_dir = opj(proj_dir, 'Derivation', 'smriprep')
    der_dir = opj(proj_dir, 'T1w')
    # keras_dir = '/brain/babri_in/sangf/Envs/ANTsXNet'
    
    # select the file with sub-* as prefix and remove those files with .html as suffix.
    subjects = glob.glob(opj(der_dir, 'sub-*[!(.html)]'))
    subjects = sorted(subjects, reverse = True)
    # subjects = subjects[2000:2500]
    # time_start=time.time()
    for i in subjects:
        sub_id = os.path.split(i)[-1]
        logging.info(sub_id)
        
        t1_path = opj(i, 'anat', f'{sub_id}_desc-preproc_T1w.nii.gz')
        
        if not os.path.exists(t1_path):
            logging.error(f'{sub_id} is not existed.')
            continue
        
        if os.path.exists(opj(i, 'anat', f'{sub_id}_desc-hippsub.nii.gz')):
            continue
        
        t1 = ants.image_read(t1_path)
        flash = deep_flash(t1=t1, do_preprocessing=True, antsxnet_cache_directory=None)
        ants.image_write(flash['segmentation_image'], opj(i, 'anat', f'{sub_id}_desc-hippsub.nii.gz'))
        
        # break
    
    # time_end=time.time()
    # logging.info(f'Time cost: {time_end - time_start} s')
    logging.info('Congratulation! Jobs has been finished.')
