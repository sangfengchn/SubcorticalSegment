import ants
from antspynet.utilities import deep_flash

t1 = ants.image_read('freesurfer/sub-1633992/mri/nu.mgz')
mask = deep_flash(t1, do_preprocessing = True)
ants.image_write(mask['segmentation_image'], 'freesurfer/sub-1633992/mri/hippsub_ants.mgz')

