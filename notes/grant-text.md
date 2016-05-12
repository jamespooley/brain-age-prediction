## Introduction

### The Importance of Neurodevelopmental Trajectories

A recent trend **[don't know if this is really a *recent* trend--add some bibliometrics?]** in developmental and clinical neuroscience is the move away from cross-sectional towards longitudinal studies of brain development in clinical and non-clinical populations. There are many reasons for this focus on "neurodevelopmental trajectories." This partly results from a reconceptualization of mental illness as the resulting from abnormal brain development. Insell (2014) motivates this shift from a focus on overt behavioral symptoms to neurodevelopmental trajectories underlying these symptoms. Viewed in this light, one strategy for diagnosing conditions such as attention-deficit/hyperactivity disorder (ADHD), autism spectrum disorder, and schizophrenia is to identify their characteristic non-normative patterns of brain development, rather than focusing on overt behavioral symptoms. The hope is that by identifying non-normative neurodevelopmental trajectories, drug- or behavior-based interventions can be targeted toward putting an individual back on the road towards the normative trajectory of brain development. As Geidd and Rapaport (2010, p. 730) note in the context of ADHD , "clinical improvement is often mirrored by a convergence of developmental trajectories toward typical development and ... persistence of ADHD is accompanied by a progressive divergence away from typical development."

Rather than assessing the absolute size of brain structures in isolation, the hope is that neurodevelopmental trajectories will lead the way toward psychiatric analogs of the "growth charts" used by pediatricians to identify aberrant patterns of body growth.

The conceptualization of many ofthe most common and debilitating psychiatric conditions as disorders of brain development, or neurodevelopmental disorders.

Conditions are often defined *behaviorally*

Insell (2014) motivates this shift from a focus on overt behavioral symptoms to the trajectories of brain development (or "neurodevelopmental trajectories") that underly these symptoms.

Behvioral symptoms typically occur relatively late in the course of a disorder.

"Neural changes, biomarkers, can be detected as much as a decade prior to the first symptoms of many neurodegenerative disorders" (Insell, 2014, p. 1727)

A recent trend in developmental neuroscience is a shift away from cross-sectional examinations of isolated brain structures towards longitudinal studies of trajectories of neurodevelopment in single individuals. Such developmental trajectories provide a gross anatomical complement to tractography studies, which map the "mis-wiring" of the brain. Rather than examining the absolute size or thickness of brain structures in isolation, it is increasingly acknowledged that the dynamic *pattern* of growth and development of these structures holds more information and clinical potential.

Clinicians and researchers now view many of the most common and and debilitating psychiatric conditions as neurodevelopmental disorders. Viewed in this light, one strategy for diagnosing conditions such as attention-deficit/hyperactivity disorder (ADHD), autism spectrum disorder, and schizophrenia is to identify their characteristic non-normative patterns of brain development, rather than focusing on overt behavioral symptoms. The hope is that by identifying non-normative neurodevelopmental trajectories, drug- or behavior-based interventions can be targeted toward putting an individual back on the road towards the normative trajectory of brain development. As Geidd and Rapaport (2010, p. 730) note in the context of ADHD , "clinical improvement is often mirrored by a convergence of developmental trajectories toward typical development and ... persistence of ADHD is accompanied by a progressive divergence away from typical development."

The hope is that research on neurodevelopmental trajectories will lead the way toward mental "growth charts," psychiatric analogs of the common chart used by pediatricians to identify aberrant patterns of body growth (Insell, 2014b).

Although neurodevelopment can be studied using indices derived from a variety of techinques (e.g., rs-fMRI), the predominant modality is structural MRI (sMRI).

"Early developmental trajectories are inherently unpredictable, influenced by complex psychosocial factors, so the accuracy of a biological or cognitive predictor may be inherently less in childhood" (Insell, 2014, p. 1728)

### Estimating Neurodevelopmental Trajectories

The starting point for the estimation of neurodevelopmental trajectories is the acquisition of high-resolution T1-weighted anatomical scans.

* Skull stripping
* Registration
* FSL/ANTS extraction magic


### Previous Findings in the Context of ADHD

ADHD, the most common childhood psychiatric disorder (REFERENCE), is characterized by both behavioral (e.g., hyperactivity) and cognitive (e.g., attentional difficulties) symptoms. It is commonly accepted that, relative to healthy controls, individuals with ADHD show delays in their neurodevelopmental trajectories. For example, developmental delays of up to XX years in the thickness of the frontal lobes has been found in ADHD (Geidd & Rapoport, 2010).

ROIs


## Effect of Head Motion on Morphometric and Volumetric Estimates

TODO: Add modified figures/analyses from Pardoe et al. paper?

Although neurodevelopmental trajectories constructed from sMRI data offer immense promise for elucidating the neuropathologies underlying psychiatric disorders such as ADHD, autism, and schizophrenia, researchers and clinicians interested in harnessing this potential face a number of significant challenges. Chief among these, especially when considering application to clinical populations of children and adolescents, is the issue of head motion. It is well known that such bulk motion results in degraded data. Even in images judged as free of motion artifact, motion messes things up (REFERENCE).
 
Despite the promise of these findings relating ADHD to aberrant neurodevelopmental trajectories, they remain provisional in light of the now well established confounding influence of head motion on morphometric and volumetric estimates derived from sMRI data. In a recent paper, Pardoe at al. (in press) investigated the effect of subject motion on the morphometric and volumetric estimates. Using three open access datasets involving children, adolescents, and adults with ADHD (ADHD-200; REFERENCE), autism (ABIDE; Di Martino et al., YEAR), and schizophrenia (COBRE; REFERENCE), they examined the effects of motion on cortical thickness estimates and gray matter estimates.

With the importance of sMRI for clinical understanding and a shift from qualitative T1-weighted images to quantitative T1 maps (e.g., Deoni), … 

Using the EPI images resulting from fMRI scans (whether task- or resting state-based), researchers can obtain a proxy for subject motion during the structural scan (see Alexander-Bloch et al., 2016; Pardoe et al., in press).  This approach has been successfully used by researchers 

There now exists a large literature examining the effects of motion in the rs-fMRI literature. However, given the nature of sMRI acquisition, motion correction for sMRI is still an open issue.

Pardoe at al. (in press) used the parameters obtained from rigid-body registration of rs-fMRI scans to approximate the amount of motion in the subject's sMRI scan. Given the ease of collection and subsequent ubiquity of rs-fMRI data, such an approach is widely used in the literature (REFERENCE). However, it is at best a noisy proxy for the true amount of subject "micro-movement" during an sMRI scan. As discussed by Pardoe et al. (in press): "anyone who is familiar with running an MRI scan knows that this assumed relationship will not always be true at the individual level. Sometimes an individual will move during the structural MRI and not during the rsfMRI acquisition, and vice versa. Furthermore, rsfMRI may not always be available." 

In addition to these concerns, the goodness of rs-fMRI data as a proxy for motion during the structural scan was assessed in relation to qualitative ratings of the structural scans, and micro-motion during the structural scan results in degradation of the sMRI image that raters often miss (REFERENCE). 

Thus, there remains a pressing need for accurate, automated methods of motion correction for sMRI. The next section reviews a number of proposals for motion-correcting sMRI data. 


## Approaches to Motion Correction in MRI

Given the acquisitional costs of MRI data, clinicians and researchers working with head motion-prone populations have developed a variety of techniques to facilitate the collection of usuable data. Although we cannot hope to be exhaustive, below we provide a brief review of approaches we feel hold the most promise for application to the population of children and adolescents with ADHD. For more comprehensive overviews, we interested reader is directed to recent reviews by Zaitsev et al. (2016) and Maclaren et al. (2012).

### Restraint, Sedation, and Behavioral Training

One set of approaches to fixing the problem of subject head motion may be broadly termed "motion control." Perhaps the bluntest such approach to dealing with the problem of head motion during MRI scans is to physically restrain a subject's head. However, in addition to requiring a compliant subject, restraints are typically uncomfortable and not entirely effective.

Another, less blunt, approach is behavioral training, where the subject is trained to keep still. Both approaches are less than ideal.

Sedation is another option. However, patient safety and cost become and issue using this technique.

### Prospective Motion Correction

Prospective motion correction (PMC) techniques update the parameters of the MRI acquisition sequence in real time as the data are being acquired, obviating the need for the RMC techniques discussed below. Althougha variety of PMC approaches have been proposed (for a review, see Maclaren et al., 2012), PMC techniques mainly fall into one of two categories: those that use internal navigators and those that use external cameras to track and record subject motion.


#### Internal Navigators

MR navigator techniques use the existing MR scanner technology (cf. optical cameras mounted on the scanner) to collect data on subject movement.

Navigator techniques also increase scan time, which can make them less than ideal in clinical applications.


#### External Trackers

In contrast to internal navigator-based PMC systems, PMC systems can also make use of externally mounted optical cameras to track a subject's head motion and update the parameters of data acquisition on the fly. To illustrate this approach, consider the KinetiCor (Kineticor, HI, USA) system. KinetiCor utilizes an 

"optical camera mounted on the inside of the scanner bore to track the motion of a passive Moiré phase marker at 80 Hz frame rate (Maclaren et al., 2012). The Moiré phase marker allows the three translational and three rotational degrees of freedom to be measured with precision on the order of tens of microns for the translations and hundredths of degrees for the rotations. Figure 1 shows a subject in a 32-channel head coil with the marker attached via a mold to the upper teeth. The information containing the position and orientation of the marker is sent to the scanner host computer, where the data are used to dynamically update the imaging FOV such that it follows the movement of the marker (Herbst et al., 2014; Herbst et al., 2012; Speck et al., 2006; Zaitsev et al., 2006)" (Friston?, online) 

Using a properly calibrated PMC system, the subject's head never leaves the scanner's field of view, thus obviating the need for the the post-acquisition re-alignments and artifact corrections discussed in the next section on retrospective motion correction (RMC).

### Retrospective Motion Correction

In contrast to PMC techniques, RMC techniques involve the application of algorithms that correct for motion artifacts *after* the data have been acquired. Such techniques are widely used by and familiar to most clinicians and researchers utilizing functional MRI (fMRI). Given the nature of sMRI image acquisition, however, RMC approaches are unwieldy to apply in this domain. In addition, RMC techniques tend to be computationally expensive, potentially limiting their clinical applicability.

#### Reconstruction Approaches

Very preliminary and experimental approach to motion correction uses a computationally intensive trial-and-error "auto-focusing" strategy (Aksoy et al., 2012) to reconstruct the image.

#### Adding Covariates at the Group Level 

One final approach to dealing with subject motion is to control for the effects of motion by adding group-level motion covariates in GLM analyses.


## Proposed Research


## References

* Insell, T. R. (2014a). Mental disorders in childhood: Shifting the focus from behavioral symptoms to neurodevelopmental trajectories. *Journal of the American Medical Association.*
* Insell, T. R. (2014b). A Growth chart for the mind. http://www.nimh.nih.gov/about/director/2014/a-growth-chart-for-the-mind.shtml
* Callaghan, M. F. et al. (2015). [An evaluation of prospective motion correction (PMC) for high resolution quantitative MRI.](http://journal.frontiersin.org/article/10.3389/fnins.2015.00097/full) *Frontiers in Neuroscience.*
* [Prospective motion correction of high-resolution magnetic resonance imaging data in children.](http://lcn.salk.edu/publications/Revelant%20Publications/Brown%20-%20Prospective%20motion%20correction%202010.pdf) *NeuroImage.*
* Pardoe et al. (in press). [Motion and morphometry in clincial and nonclinical populations.](http://www.sciencedirect.com/science/article/pii/S1053811916301197) *NeuroImage.*
* Di Martino et al. (2014). [Unraveling the miswired connectome: A developmental perspective.](http://www.sciencedirect.com/science/article/pii/S0896627314007806) *Neuron.*
* Maclaren, J. et al. (2013). [Prospective motion correction in brain imaging: A review.](http://onlinelibrary.wiley.com/doi/10.1002/mrm.24314/full) *Magnetic Resonance in Medicine.*
* Maclaren, J. et al. (2015). [Motion artifacts in MRI: A complex problem with many partial solutions.](http://onlinelibrary.wiley.com/doi/10.1002/jmri.24850/abstract) *Journal of Magnetic Resonance Imaging*
* Reuter, M. et al. (2015). [Head motion during MRI acquisition reduces gray matter volume and thickness estimates.](http://www.sciencedirect.com/science/article/pii/S1053811914009975) *NeuroImage.*
* The ADHD-200 Consortium (2012). [The ADHD-200 Consortium: A model to advance the translational potential of neuroimaging in clinical neuroscience.](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3433679/) *Frontiers in Systems Neuroscience.*
* Geidd, J. N., & Rapoport, J. L. (2010). [Structural MRI of pediatric brain development: What have we learned and where are we going? *Neuron.](http://www.sciencedirect.com/science/article/pii/S0896627310006835)*
* Alexander-Bloch, A., et al. (2016). [Subtle in-scanner motion biases automated measurement of brain anatomy from in vivo MRI.](http://www.sciencedirect.com/science/article/pii/S0896627310006835) *Human Brain Mapping.*
* Aksoy, M. et al. (2012). [Hybrid prospective and retrospective head motion correction to mitigate cross-calibration errors.](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3213297/) *Magnetic Resonance in Medicine.*
* Chen, H. et al. (2015). [Quantile rank maps: A new tool for understanding individual brain development.](http://www.sciencedirect.com/science/article/pii/S1053811915000130) *NeuroImage.*
* Woods-Frohlich, L., Martin, T., & Malisza, K. L. (2016). [Training Children to Reduce Motion and Increase Success of MRI Scanning.](http://www.eurekaselect.com/72014/article) *Current Medical Imaging Reviews.*
* Shaw, P. et al. (2007). Attention-deficit/hyperactivity disorder is characterized by a delay in cortical maturation. *Proceedings of the National Academy of Sciences.*
