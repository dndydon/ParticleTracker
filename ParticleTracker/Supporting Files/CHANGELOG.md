# Changelog for ParticleTracker

## Version 0.0.1 - 7/29/2017

- Added a few example data files from Osh email 7/28/2017
- IUEspGFP_S385a-001.xml,
- IUEspGFP_S385a-001_Cycle00001_CurrentSettings_Ch2_000001.tif
- IUEspGFP_S385a-001_Cycle00001_CurrentSettings_Ch2_000002.tif
- ... and several other images for a test data stack
- IUEspGFP_S385a-001_Cycle00001_CurrentSettings_Ch2_000006.tif
- IUEspGFP_S385a-001Config.cfg

- These data will be used to develop IO, parsing, and image analysis

- Minor additions to establish a working, publishable template:
- Added LICENSE file
- Added CHANGELOG file (this file)
- Added preliminary Package.swift file

- Defined a few requirememts:
  + Command Line Interface, for now
  + Test driven
  + TIFF decoding and encoding needed to read input and write annotated images as output
  + Will need to identify spots local to each image, persisting the ID and map location
  + Will need to compare images with mapped spots to detect spots with lowest distance vectors
  + The lowest distance vectors expected to be zero.
  + The brightest spots with the lowest distance vectors will establish image offset values (we should not assume the images are aligned in the raw data.)
  + Will need to normalize the background and gain of images and also determine the variance between images in case outlier images may need to thrown out.
  + Spot detection will need to be stable within thresholds set by user, XML config files, or auto-detected thresholds computed on the fly.
  + I will use Core Data in SQLite mode to store spot IDs and all metadata so the app can remember and display results as needed in CLI or GUI interfaces. Data Inspector UI will be needed to visualize the results.
  + Will develop cross-platform products (Swift on Linux and Mac, maybe even iOS someday)
  + Use a simple XML parsing framework (AEXML) to establish separate XML module, offloading the XML stuff as much as possible
  + XML may not be needed for first POC, but I see a future requirement for it coming

## Version 0.0.1 - 7/28/2017

- Initial version
- Set up ConsoleIO class and stub code for command line interface Xcode
- Defined a CLI target
- Set up the Test system with ParticleTest

