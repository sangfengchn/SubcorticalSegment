'''
# @ Author: Feng Sang
# @ Create Time: 2022-04-02 12:53:13
# @ Modified by: Feng Sang
# @ Modified time: 2022-04-02 12:53:17
# @ Description:
'''
import os
from os.path import join as opj
import glob
import shutil
import logging

logging.basicConfig(
    level = logging.INFO,
    format = '%(asctime)s %(message)s',
    datefmt  = '%Y-%m-%d %H:%M:%S:'
)

if __name__ == '__main__':
    proj_dir = '/brain/babri_in/sangf/Data/D_desc-bnu_sca-old'
    der_dir = opj(proj_dir, 'Derivation', 'smriprep')
    dst_dir = opj(proj_dir, 'T1w')
    if not os.path.exists(opj(dst_dir)):
        os.makedirs(dst_dir)
    
    # select the file with sub-* as prefix and remove those files with .html as suffix.
    subjects = glob.glob(opj(der_dir, 'sub-*[!(.html)]'))
    subjects = sorted(subjects)
    for i in subjects:
        sub_id = os.path.split(i)[-1]
        logging.info(sub_id)
        
        t1_path = opj(i, 'anat', f'{sub_id}_desc-preproc_T1w.nii.gz')
        
        if not os.path.exists(t1_path):
            logging.error(f'{sub_id} is not existed.')
            continue
    
        sub_path = opj(dst_dir, sub_id, 'anat')
        if not os.path.exists(sub_path):
            os.makedirs(sub_path)
            
        shutil.copy(t1_path, opj(sub_path, f'{sub_id}_desc-preproc_T1w.nii.gz'))
    