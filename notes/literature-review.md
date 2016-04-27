## The importance of brain developmental trajectories

![Examples of Neurodevelopmental Trajectories](trajectories.jpg)

* [Unraveling the Miswired Connectome: A Developmental Perspective](http://www.cell.com/neuron/references/S0896-6273%2814%2900780-6)
* http://www.sciencedirect.com/science/article/pii/S1878929314000310
* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4787204/
* http://www.ncbi.nlm.nih.gov/pubmed/8698883

## Previous findings with T1, quantitive relaxometry, DTI, DKI, NODDI, rs-fMRI and trajectories – brain age prediction

### Quantitative Relaxometry Mapping

* [Quantitative MRI for studying neonatal brain development](https://www.researchgate.net/profile/Revital_Nossin-Manor/publication/250924259_Quantitative_MRI_for_studying_neonatal_brain_development/links/0deec51f4c548b3d87000000.pdf)
* [T2 Relaxometry of Normal Pediatric Brain Development](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2767196/)
* http://www.ncbi.nlm.nih.gov/pubmed/8698883)
* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4075590/
* http://www.ncbi.nlm.nih.gov/pubmed/25620906
* http://visielab.uantwerpen.be/sites/default/files/Kudzinava_2011_ISBI_ppt.pdf

### DTI

* [Growth trajectory of the early developing brain derived from 
longitudinal MRI/DTI data](http://depts.washington.edu/bicg/documents/MICCAI-2009-IADB-Gerig.pdf)

> Diffusion MRI is very sensitive to motion, due to phase shifts induced microscopically by diffusion-driven water molecular displacements, and macroscopically by head motion, cardiac pulsation and breathing. This sensitivity increases with the intensity and duration of gradient pulses, which are characterized by the b-value, the scalar that defines the amount of diffusion weighting in the experiment (Le Bihan et al., 2001). It can be reduced by synchronizing the acquisition with the source of motion, monitoring using “navigator echoes,” using specific protocols, applying real-time prospective motion and outlier detection methods; however, all of these may raise other problems such as increased acquisition times (Ordidge et al., 1994; Pipe, 1999; Kennedy and Zhong, 2004; Zwiers, 2010; Zhou et al., 2011b; Kober et al., 2012; Ling et al., 2012). Even though it is also possible, and even advisable, to correct subject motion using preprocessing techniques (see in preprocessing steps below), the best approach is still to use comfortable padding to adjust the participant's head, and to inform the subject in advance about the noise and the vibration of the bed. This vibration was recently reported as the cause of another artifact, known as vibration artifact. During the acquisition, strong gradients are applied causing low-frequency mechanical resonances of the MR system that lead to small brain tissue movements. When these movements occur in the direction of the diffusion-encoding gradient, phase offsets will occur inducing signal dropouts in DWI images. This kind of artifacts can be reduced increasing TR (with the drawback of reducing SNR) or using full k-space coverage combined with parallel imaging (e.g., GRAPPA) (Gallichan et al., 2010). It can also be compensated using methods such as phase-encoding reversal (COVIPER) (Mohammadi et al., 2012), implemented in Artifact Correction in Diffusion MRI (ACID) toolbox. [[source]](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3594764/)

### DKI

* http://ajnrdigest.org/diffusional-kurtosis-imaging-developing-brain/
* http://visielab.uantwerpen.be/sites/default/files/Kudzinava_2011_ISBI_ppt.pdf
* http://www.ajnr.org/content/35/4/808.long

### BrainAGE

![BrainAGE Framework](brainage.png)

* http://www.neuro.uni-jena.de/pdf-files/Franke-NI12.pdf
* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4403966/
* http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0067346

## Impact of head motion on trajectories

* http://blogs.discovermagazine.com/neuroskeptic/2014/12/19/head-motion-structural-scans/#.VyD8qSaVvCI
* http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3563110/

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
