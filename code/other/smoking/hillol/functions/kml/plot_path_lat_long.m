function plot_path_lat_long(lats, longs, labels, outputPath, kmlName)
skeletonPath = 'functions/kml/skleton_kml.txt';
skeletonKml = getFileContent(skeletonPath);
skeletonKmlParts = regexp(skeletonKml,'#PUT_CONTENT_HERE#', 'split');
skeletonKmlHeader = char(skeletonKmlParts(1));
skeletonKmlFooter = char(skeletonKmlParts(2));
fpKml = fopen(outputPath,'w');
fprintf(fpKml, '%s', skeletonKmlHeader);

kmlCreateFolder(fpKml, kmlName, 0);

kmlGeneratePathSimple(fpKml, lats, longs, labels);

kmlCloseFolder(fpKml);
fprintf(fpKml, '%s', skeletonKmlFooter);
fclose(fpKml);

end

