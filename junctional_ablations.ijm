// Macro for processing junctional ablations

// open a raw.czi file, convert to tiff and save in a new folder
// comment out if already have tiff, gennerally do in batches with the raw files from each organoid

//dir = getDirectory("image");
//tifdir = getDirectory("Choose directory where Tiff will be saved");
//Dialog.create("File Name");
//	Dialog.addString("File Name", ".tif");
//Dialog.show();
//label = Dialog.getString();
//saveAs("Tiff", tifdir+label);

// draw a freehand polygon region around the junction

dir = getDirectory("image");
title = getTitle();
print(dir)
print(title)

run("Crop");
run("Duplicate...", "duplicate");
run("Make Substack...", "  slices=5,6,7,8,9,10,12,14,16,18,20,25,30,35,40,45,50,55,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200");
selectWindow("Substack (5,6,7,8,9, ... 200)");
run("Gaussian Blur...", "sigma=2 stack");
run("MTrackJ");
run("Threshold..."); // this might need a bit of adjusting, want to see tricellular junction throughout time series
setAutoThreshold("Default dark");
call("ij.plugin.frame.ThresholdAdjuster.setMode", "Over/Under");
selectWindow("Substack (5,6,7,8,9, ... 200)"); // make substack of 22 timepoints (might want to increase this just after ablation)
saveAs("Tiff", dir+"analysis_"+title);

changes!
