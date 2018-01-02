# ParticleTracker
**Image stack analyzer written in Swift and MLKit**

[![Language Swift 4.0](https://img.shields.io/badge/Language-Swift%204.0-orange.svg?style=flat)](https://swift.org)
[![Xcode 9.2](https://img.shields.io/badge/XCode-9.2%20-orange.svg?style=flat)](https://developer.apple.com/xcode/)
[![Platforms OS X](https://img.shields.io/badge/Platforms-OS%20X-lightgray.svg?style=flat)](http://www.apple.com)
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/dndydon/ParticleTracker/blob/master/LICENSE.txt)

> This is non-functional WIP.

## Index
- [Features](#features)
- [Design](#design )
- [Data Quality Metrics](#data-quality-metrics)
- [Scorecards](#scorecards )
- [Roadmap](#roadmap)
- [Installation](#installation)
- [License](#license)

## Features
- **Read TIFF** data
- **Machine Learning** analysis of particles and tracks in stacks of images.
- **Annotate and Write TIFF or PNG** annotated images.
- Developed with [unit tests](https://github.com/dndydon/ParticleTracker/blob/master/ParticleTests/ParticleTests.swift)

### Common Use Scenario
Stacks of images are often used to study the dynamics (time or depth) of a Scene. Telescopes, microscopes, and security cameras are example systems that need to analyze and annotate images in stacks.

#### ParticleTracker is a macOS command-line and GUI application:
- choose a directory of source images, also known as a stack
- display read-only preview of images showing filenames and other meta-data (including previously stored scorecards)
- view & modify selection of images that will define image stack "runs". The selected images will be analyzed as a stack, also known as a run. A run is given a name and registered into the system. If the run is successfully named and registered, a scorecard is prepared and written into a sub-directory named for the run. The scorecard is created as an empty record primed with the names and URLs of the multi-images chosen above. All writes to a scorecard are logged in the scorecard.
- process a run includes running one or more analysis algorithms on the image stack, writing the results into the run scorecard created above. Runs are designed (initially, at least) for testing the particle testing algorithms and storing analysis results suitable for downstream display and processing.
- display, meta-analysis, and downstream processing of run data results will read and update run data scorecards. Think of run scorecards as a computed "metadata layer" over the images themselves. Input image data integrity is preserved at all times.
- named analytical runs, generally described below, will be configurable by command-line or template files named by the application.

Image data is collected with standard image formats and stored in folder hierarchies with a naming system defined by the instrument upstream of this software. We need to read in and analyze "stacks" of images that will contain "particle spots" or "geometrical objects" on a noisy background. We need to detect and recognize spots as particles, or vertices of objects, which we need to "track" as they move across the images in the stack.

ParticleTracker will use various image analysis algorithms to process images in series to compute 3D tracking of particles as they move over time. Particles will have identities and we will compute distance vectors for each of them for each image in the stack.

## Design

### Read/Write TIFF data
TIFF is a standard file type that will be read into Data objects and processed with open-source libraries. I can only guess that we will need to normalize the data to be accurate in quantitative analysis, because noise and dynamic range on images is often problematic. Experience tells us the we may want to pre-process the images a bit before we detect and ID particles. Other image file formats will be added as needs arise.

### Machine Learning Tech
We will use Apple's MLKit for machine learning on OS X.
After pre-processing images, we will create and train a ML model to recognize particles and reject artifact spots and smudges.

Particle tracking is a good problem for machine learning.
ML models will be used to recognize the connectedness of spots or particles that are topologically linked in the order of the noisy images.

Apple's MLKit and Swift language is chosen for this work for a few reasons. 1) MLKit is promising for deploying machine learning at scale, and 2) Swift is promising as an easy and versatile language with high quality open-source support. 3) Both are built for speed and efficiency, as well as developer friendliness.

Training data sets will need to be created, curated, and shared for development, possibly on AWS. Curating training data is a refinement process. Machine Learning models are products of this refinement process. I expect the models that are produced will be small in size and easily version controlled in this GitHub repository.

#### Kahn’s algorithm for Topological Sorting
Old technology may work, too! There is a well-known (non-ML) algorithm that we could use to compute connected graphs of time-series data -- for the desired results.

**Topological sorting for Directed Acyclic Graph** (DAG) with a linear **minimum distance** ordering of vertices such that for every directed edge uv, vertex u comes before v in the ordering. Topological Sorting is simple, inexpensive, and with our image stacks that are normalized with quality scored particle maps, probably easy to do. Which is great, because if we want to train ML networks to do this for us, we will need "truth" data in large quantity.

We will compute the particle sizes and locations and classify each particle according to QA types (input filtering) then feed each spot map into our topological sorting algorithm (for generating truth data), or our ML particle tracker algorithm for comparison. Particle tracks are represented as 3D DAGs, so we can visualize how each particle in the stack relates to each other in a minimum distance sorted graph. Branching is likely in our particle graphs.

A persistent data storage model is needed to store all the particle tracks (DAGs) for analytical calcuations and rapid 3D visualization (in the future). Summary statistics will be output in the first versions. Annotated image files will be output in the second version. Future versions could have interactive 3D graphics of the particle graphs, assuming this fits the goals of the users of the system.

### Read XML config data
Reading the config and instrument XML data files is not a high priority at first, but the XML files contain data that would be helpful in the analysis or the presentation of results. See notes in the text files.

### Command Line Interface
A command line interface is a development strategy that will assist testing and development of the process of analysis, without getting bogged down in UI development in the prototyping stage. The command line interface may also be a useful way to deploy the software in a pipeline production process. In other words, I like to design dual apps -- split the processing away from the UI client.

The first version will be just command-line image processing and generating the output scorecards in run folders. Then we will implement the particle tracking analysis code. The GUI client app will form around the command-line "engine." This allows good test-driven-development and separation of concerns.

### First Draft API

Requirement: Read, and list out, summary information for a given Subject folder hierarchy: where Subjects have one or more Observations, with one or more ImageStacks, with one or more Runs.

Subject folder hierarchy:  Subject ->> Observation ->> ImageStack ->> Run : Scorecard

Remember: Observations have **ImageStacks, which are subsets of images within the Observation**. This allows subsets of images to be analyzed within a much larger Observation set. Think of Observations as movies. ImageStacks are clips of that movie, sometimes just the beginning frame, middle frame, and end frame of a much longer movie.

An ImageStack is a .json file stored within an Observation folder. It contains the array of image filenames defined to be in the ImageStack. The ImageStack file is stored in the Observation folder and its location is referenced in the API as the **stack file path**. The default ImageStack or missing <stack file path> refers to all the images in an Observation.

Run the following commands in Terminal:
```
> particletracker [-list, -process, -version, -help] [-bySubject | -byObservation [<subject folder path>] | -byImageStack [<observation folder path>] | -byRun [<stack file path>]]
```
for example,
```
> particletracker -list -byObservation [<subject folder path>]
> # lists out the Observations for the Subject path (or local path, if missing the path argument)

> particletracker -list -byImageStack [<observation folder path>]
> # lists out the ImageStacks for the Observation path (or local path, if missing the path argument)

> particletracker -list -byRun [<stack file path>]
> # lists out the Runs for the ImageStack (or local path, if missing the path argument)

```
Requirement: where **[subject, observation, stack, run] folder path** is the path to a folder containing files from a given level, e.g. Subject, e.g S376.

To actually process the data we will need a few different options. The main usage command will look like this:
```
particletracker -process -byRun <stack file path>
```
This will "run" and generate a new set of run folders for/in the given Observation directory. The folders will be named with a 'stack file path + timeStamp'.
Common use and testing of the system will require easy comparability among runs across an Observation-ImageStack.

or to iterate over multiple levels of the hierarchy, e.g. by Observation:
```
particletracker -process -bySubject -byObservation <subject folder path>
```
where the **observation folder path** is given to limit the analysis and report to just one observation stack.

For limiting ParticleTracker to specific images the usage command will look like this:
```
particletracker -process -subject <subject folder path> -observation <folder name> -images <pattern>
```
where **pattern** is something like: 1,2,4,5,6 (skip 3), or 1-10,11-20.

Why this complexity? I expect we will need control over which images we accept and which we reject at the outset, although the ML algorithm may handle image rejection for us, automatically. We do need a way to specify image quality control/rejection.

Like all good command line tools, invoking the command without arguments will display usage help, and also report version, etc. Each option will also be abbreviated.

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
Metadata summary: Scorecard 453

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

## Data Quality Metrics
The output of ParticleTracker will need to record statistics on characteristic measurements that relate to several types of data quality errors. For example each observation needs to have a quality score. Each image needs a quality score. We need to be able to sort our best and worst data into ranges that include categories of errors. We need this to be able to have good metrics to develop confidence in the performance of the system in the face of problems with input files as well as the robustness of the software to handle variation in the data.

Each type of data quality error will need to be defined and examples of which will need to be curated in the training sets.

This storage of qualty data statistics will be useful in developing/tuning Machine Learning Models.

## Scorecards
I am familiar with a similar problem where we developed a scorecard file that was written to the "run" or observation directory. The scorecard file goes with the data and represents the current results and version of the software for easy display in a client program that reads the scorecard and displays relevant parts of the analysis. The scorecard can be used in automated pipelines as well as QA managers and even remote clients that collaborate on the science.

Scorecard files as output of analysis will eventually be used for automated workflows.

## Roadmap
The goal of the first demo command line interface will be to summarize the contents of the file folder hierarchy, report on some summary file statistics, and write ImageStack.json files in Observation folders.

The goal of the second version will be to process images.

Scorecards will come later when we have image processing stubbed in and something to write into Scorecards.

## Installation

Currently, just clone the repo and open the Xcode project. Future dependencies will use:
- [Swift Package Manager](https://swift.org/package-manager/):

Platform requirements are not yet confirmed. We could potentially distribute code to be built and run on Linux, Mac, or someday Windows machines. And iOS, if appropriate.

## License
ParticleTracker is pre-released here under the MIT license. See [LICENSE](LICENSE.txt) for details.

