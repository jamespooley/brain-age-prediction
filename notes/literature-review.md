## The importance of brain developmental trajectories

* http://www.sciencedirect.com/science/article/pii/S1878929314000310
* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4787204/

## Previous findings with T1, quantitive relaxometry, DTI, DKI, NODDI, rs-fMRI and trajectories – brain age prediction

* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4075590/
* http://www.ncbi.nlm.nih.gov/pubmed/25620906
* http://visielab.uantwerpen.be/sites/default/files/Kudzinava_2011_ISBI_ppt.pdf
* 
### DKI

* http://ajnrdigest.org/diffusional-kurtosis-imaging-developing-brain/
* http://visielab.uantwerpen.be/sites/default/files/Kudzinava_2011_ISBI_ppt.pdf
* http://www.ajnr.org/content/35/4/808.long

## Impact of head motion on trajectories

## Motion correction strategies

* http://mriquestions.com/reducing-motion-artifacts.html
* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3320676/

Two general methods: 
* **Retrospective:** Use information about the subject’s motion to estimate what k-space data would have been measured if the subject had not moved during scanning. 
* **Prospective:** Use motion-tracking data acquired during the scan to follow the subject with the gradient axes of the sequence, measuring the desired k-space data directly. 

### Prospective correction – measure during scan and adjust scanning parameters

* http://ifa.hawaii.edu/~baranec/tt/Prospective_Motion_Correction_in_Brain_Imaging.pdf
* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3320676/
* http://journal.frontiersin.org/article/10.3389/fnins.2015.00097/full

### Retrospective – impossible sMRI

* https://brainder.org/2012/05/17/retrospective-motion-correction-for-structural-mri/
* http://hannes.nickisch.org/papers/articles/loktyushin13mrimocorr.pdf
* http://cbs.fas.harvard.edu/science/core-facilities/neuroimaging/information-investigators/MRphysicsfaq#moco_struct

### Some techniques that try to minimize head motion artifacts during reconstruction

> Additionally, it is possible to combine [prospective and retrospective] methods so that retrospective processing corrects residual errors in the prospective system. A retrospective system can access all of the k-space data while performing reconstruction; a prospective system must necessarily rely only on previous measurements to estimate the current position of the patient. However, a prospective system avoids the need to estimate missing k-space data, allowing for direct reconstruction while avoiding possible sources of estimation error in the k-space data. [source](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3320676/)

* https://deepblue.lib.umich.edu/bitstream/handle/2027.42/62439/kpandey_1.pdf?sequence=1

### Group level – include as covariate
