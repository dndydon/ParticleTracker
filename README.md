# ParticleTracker
**Image stack analyzer written in Swift and MLKit**

[![Language Swift 4.0](https://img.shields.io/badge/Language-Swift%204.0-orange.svg?style=flat)](https://swift.org)
[![Xcode 9](https://img.shields.io/badge/XCode-9%20beta%20-orange.svg?style=flat)](https://developer.apple.com/xcode/)
[![Platforms OS X](https://img.shields.io/badge/Platforms-OS%20X-lightgray.svg?style=flat)](http://www.apple.com)
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/dndydon/ParticleTracker/blob/master/LICENSE.txt)

> This is non-functional WIP.

## Index
- [Features](#features)
- [Usage](#usage)
- [Installation](#installation)
- [License](#license)

## Features
- **Read TIFF** data
- **Machine Learning** analysis of particles and tracks in stacks of images.
- **Write TIFF or PNG** annotated images.
- Developed with [unit tests](https://github.com/dndydon/ParticleTracker/blob/master/ParticleTests/ParticleTests.swift)
- Covered with inline docs

## Usage

### Read/Write TIFF data
TIFF is a standard file type that will be read into Data objects and processed with open-source libraries. I can only guess that we will need to normalize the data to be accurate in quantitative analysis, because noise and dynamic range on images is often problematic. Experience tells us the we may want to pre-process the images a bit before we detect and ID particles.

### Machine Learning Tech
We will use Apple's MLKit for machine learning on OSX. After pre-processing images, we will train a ML model to recognize particles and reject artifact spots and smudges. This should be a good problem for machine learning. We will take the particle locations and classify them according to the output of the model, and feed this information into a tracker algorithm. Particle tracks are represented as 3D trees, so we can visualize how each image slice in the stack relates to every other image, with particles moving in the time series, possibly branching. A persistent data storage model (a database) will be developed to store the particle tracks for analytical purposes and visualization (in the future). Summary statistics will be output in the first versions. Annotated image files will be output in the second version. Subsequent versions could be 3D graphical interactive software, once we get a better idea of the goals of the users/owners.

Apple's MLKit and Swift language is chosen for this work for a few reasons. MLKit is promising as a future standard for machine learning, and Swift is promising as a cross-platform language. Both are built for speed and efficiency, as well as developer friendliness.

Training data sets will need to be created, curated, and used for development. Generating training data is a refinement process. Machine Learning models are products of a refinement process. Since these training data sets will be large, Amazon S3 storage will be used to "check-in" and "check-out" versions of these data. I expect the models that are produced will be small in size and easily version controlled in this GitHub repository.

### Read XML config data
Reading XML is not a high priority at first, but the XML files that come with the images contain data that would be helpful in the analysis or the presentation of results. Some good information is in the text files.

### Common Use Scenario
Microscopic image data is collected with a specific image format and stored in folder hierarchies with a specific naming system. We are going to need to read in and analyze "stacks" of images that will contain particle spots on a noisy background. We need to detect and recognize spots as particles which we need to "track" as they move across the images in the stack.  ParticleTracker will use image analysis algorithms to process images in series to compute 3D tracking of particles as they move over time. Particles will have identities and we will compute distance vectors for each of them for each image in the stack. I will need more information on exactly what the users of the system need, and what we can expect of the system.

### Command Line Interface
The command line interface is a development strategy that will assist testing and development of the process of analysis, without getting bogged down in UI development in the prototyping stage. The command line interface may also be a useful way to use the software in a pipeline production process. In other words, I like to split the processing from the UI client, and the first version will be just the image processing and particle tracking engine, not the client app.

At first we need to read in and list out summary information for a given hierarchy by subject, observations, images, configurations, and metadata. Run the following command in Terminal:
```
particletracker -list -subject <subject folder path>
```
where **subject folder path** is the name of your subject, e.g S376.

To actually process the data we will need a few different options. The main usage command will look like this:
```
particletracker -track -subject <subject folder path>
```
or to limit it to one observation folder:
```
particletracker -track -subject <subject folder path> -observation <folder name>
```
where the **observation folder name** is given to limit the results to just one observation stack.

For limiting ParticleTracker to specific images the usage command will look like this:
```
particletracker -track -subject <subject folder path> -observation <folder name> -images <pattern>
```
where **pattern** is something like: 1,2,4,5,6 (skip 3), or 1-10,11-20.

Why this complexity? I expect we will need control over which images we accept and which we reject at the outset, although the ML algorithm may handle image rejection for us, automatically. We do need a way to specify image quality control/rejection.

Like all good command line tools, invoking the command without arguments will display usage help, and also report version, etc. The options will also be abbreviated.

### Results and Output
The output will look like this: (all of this is preliminary)
```
Subject:        S376
Observation:    IUEspGFP_S376a-001
6 Input Images:
IUEspGFP_S376a-001_Cycle00001_CurrentSettings_Ch2_000001.tif
IUEspGFP_S376a-001_Cycle00001_CurrentSettings_Ch2_000002.tif
IUEspGFP_S376a-001_Cycle00001_CurrentSettings_Ch2_000003.tif
IUEspGFP_S376a-001_Cycle00001_CurrentSettings_Ch2_000004.tif
IUEspGFP_S376a-001_Cycle00001_CurrentSettings_Ch2_000005.tif
IUEspGFP_S385a-001_Cycle00001_CurrentSettings_Ch2_000006.tif
0 Output Images:
Metadata summary:
(summary statistics of results labeled with data from XML files)

Observation:     IUEspGFP_S376a-002
6 Input Images:
IUEspGFP_S376a-002_Cycle00001_CurrentSettings_Ch2_000001.tif
IUEspGFP_S376a-002_Cycle00001_CurrentSettings_Ch2_000002.tif
IUEspGFP_S376a-002_Cycle00001_CurrentSettings_Ch2_000003.tif
IUEspGFP_S376a-002_Cycle00001_CurrentSettings_Ch2_000004.tif
IUEspGFP_S376a-002_Cycle00001_CurrentSettings_Ch2_000005.tif
IUEspGFP_S376a-002_Cycle00001_CurrentSettings_Ch2_000006.tif
0 Output Images:
Metadata summary:
(summary statistics of results labeled with data from XML files)

etc...
```

Each type of data quality error will need to be defined and examples of which will need to be curated in the training sets.

So the output of ParticleTracker will need to record statistics on characteristic measurements that relate to these errors. For example each observation needs to have a quality score. Each image needs a quality score. We need to be able to sort our best and worst data into ranges that include categories of errors. We need this to be able to have good metrics to develop confidence in the performance of the system in the face of problems with input files as well as the robustness of the software to handle variation in the data.

I am familiar with a similar problem where we developed a scorecard file that was written to the "run" or observation directory. The scorecard file goes with the data and represents the current results and version of the software for easy display in a client program that reads the scorecard and displays relevant parts of the analysis. The scorecard can be used in automated pipelines as well as QA managers and even remote clients that collaborate on the science.

## Installation

- [Swift Package Manager](https://swift.org/package-manager/):

GitHub is a great way to distribute code and share projects, but installing and building on different machines can be a difficult problem. Swift Packages are designed to solve these issues.

Eventually, not at first. Platform requirements are not yet known. We could potentially distribute code to be built and run on Linux, Mac, or someday Windows machines. And iOS, if appropriate.

## License
ParticleTracker is pre-released here under the MIT license. See [LICENSE](LICENSE.txt) for details. 

