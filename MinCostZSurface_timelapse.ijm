//
//	20191108	AGH
//	Macro for running the plugin MinCostZSurface with a timelapse file
//	

//	Open timelapse
moviePath = File.openDialog("Select timelapse movie");											print("file = "+moviePath+"\n");
resultsdir = getDirectory("Choose directory where projections will be saved");

setBatchMode(true);

open(moviePath);
movieName = getTitle();	movieID = getImageID();													print(movieID+"\n"+movieName+"\n");
Stack.getDimensions(width, height, channels, slices, frames);
dir = getDirectory("image");																	print("dir = "+dir+"\n");

run("Duplicate...", "title=inverted duplicate");
invID = getImageID();	invName = getTitle();													print(invID+"\n"+invName+"\n");

selectImage(invID);	run("Invert", "stack");

for (i = 1; i <= frames; i++) {																		print("t "+i+"\n");
	selectImage(movieID);	run("Duplicate...", "title=imgt"+i+" duplicate frames="+i+"");
							tID = getImageID();	tName = getTitle();								print(tID+"\n"+tName+"\n");
	selectImage(invID);	run("Duplicate...", "title=invt"+i+" duplicate frames="+i+"");
							invtID = getImageID();	invtName = getTitle();						print(invtID+"\n"+invtName+"\n");
//	run("Min cost Z Surface", "input="+tName+" cost="+invtName+" rescale_x,y=0.25 rescale_z=0.50 max_delta_z=2 display_volume(s) volume=10 two_surfaces max_distance=10 min_distance=3");	//best for start frame
//	run("Min cost Z Surface", "input="+tName+" cost="+invtName+" rescale_x,y=0.25 rescale_z=0.50 max_delta_z=1 display_volume(s) volume=3 two_surfaces max_distance=10 min_distance=3");	//compromise
	run("Min cost Z Surface", "input="+tName+" cost="+invtName+" rescale_x,y=0.25 rescale_z=0.50 max_delta_z=1 display_volume(s) volume=3 two_surfaces max_distance=15 min_distance=3");	//best for end frame but still good for start

	allTitles = getList("image.titles");
	for (j = 0; j < lengthOf(allTitles); j++) {
		if (allTitles[j] == movieName || allTitles[j] == invName) {
																								print("\n"+allTitles[j]+"_"+j+" open\n");
		} else if (allTitles[j] == "excerpt" && j == 8) {
			selectWindow(allTitles[j]);
//			saveAs("Tiff", resultsdir+"t"+i+"_"+allTitles[j]+"_"+j+".tif");
			run("Duplicate...", "duplicate range=3");	projectionID = getImageID();	projectionName = getTitle();
			selectImage(projectionID);
			saveAs("Tiff", resultsdir+"t"+i+"_"+projectionName+"_"+j+".tif");					print("\n"+projectionName+"_"+j+" saved\n");
			close();
			selectWindow(allTitles[j]);	close();												print("\n"+allTitles[j]+"_"+j+" closed\n");
		} else {
			selectWindow(allTitles[j]);	close();												print("\n"+allTitles[j]+"_"+j+" closed\n");
		}
	}
}
