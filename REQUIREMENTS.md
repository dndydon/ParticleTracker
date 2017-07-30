#  Requirements

## Preliminary
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
