## The importance of brain developmental trajectories

* http://www.sciencedirect.com/science/article/pii/S1878929314000310
* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4787204/

## Previous findings with T1, quantitive relaxometry, DTI, DKI, NODDI, rs-fMRI and trajectories – brain age prediction

* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4075590/
* http://www.ncbi.nlm.nih.gov/pubmed/25620906
* http://visielab.uantwerpen.be/sites/default/files/Kudzinava_2011_ISBI_ppt.pdf

### DKI

* http://ajnrdigest.org/diffusional-kurtosis-imaging-developing-brain/
* http://visielab.uantwerpen.be/sites/default/files/Kudzinava_2011_ISBI_ppt.pdf
* http://www.ajnr.org/content/35/4/808.long

## Impact of head motion on trajectories

* http://blogs.discovermagazine.com/neuroskeptic/2014/12/19/head-motion-structural-scans/#.VyD8qSaVvCI

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

> In any case, if motion estimates are available, a correlation analysis among motion and other predictors should always be performed and any co-linearity should be reported. High co-linearity between predictors makes it difficult to disentangle their effects and is symptomatic of insufficient information, which cannot be rectified by simple data manipulation. In this case, inclusion of a motion co-variate into the statistical model can shadow any real effects. This is problematic, as in many settings motion can be expected to be correlated with the variable of interest (disease severity, age, drug dose etc.).
> 
> Collecting several structural scans and manually selecting one without motion artifacts for the structural analysis seems to be a commonly used option even in the presence of a costly increase in scan time. This procedure can reduce the spurious motion effect, but does not completely eliminate it. Furthermore, it is difficult in many study groups to obtain even a single scan without visible motion artifacts. While a visual inspection of automatically generated results is always recommended, it is often up to the individual expert to decide whether to exclude or repeat a scan or not. Since even small and visually inconspicuous, yet consistent, motion artifacts might bias the results, we believe that reducing motion during the scan is currently the best option. Controlling for motion in the statistical analysis is a second alternative that ideally should go hand in hand with a correlation analysis between motion and the predictors of interest. [[source]](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4300248/)
