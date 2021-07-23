import tifffile as tiff

from PIL import Image
from PIL.TiffTags import TAGS

def raw_parameters(rawFilePath):
    '''Obtain raw image parameters: zSpacing, xResolution and yResolution from TIFF'''
    
    rawImg = tiff.TiffFile(rawFilePath);
    try:
        zSpacing = rawImg.imagej_metadata['spacing'];
    except Exception as e:
        zSpacing = 1;
        
    rawImg = Image.open(rawFilePath)
    
    if TAGS[282] == 'XResolution':
        xResolution = 1/rawImg.tag_v2[282];
        
    if TAGS[283] == 'YResolution':
        yResolution = 1/rawImg.tag_v2[283];
        
    return zSpacing, xResolution, yResolution