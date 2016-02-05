G=config();
G=config_run_memphis(G);

load('c:\dataProcessingFramework\data\memphis\formatteddata\p15_s01_frmtdata.mat');
start=1;
endd=20000;
gps=[double(D.sensor{14}.sample(start:endd)),double(D.sensor{15}.sample(start:endd)), D.sensor{15}.timestamp(start:endd)];
speed=D.sensor{17}.sample(start:endd);

[class,type]=dbscan(gps,100,250);

fpKml = fopen('c:\DataProcessingFramework\data\memphis\clurstering\dbcluster.kml','w');
skeletonPath = 'functions/kml/skleton_kml.txt';
skeletonKml = getFileContent(skeletonPath);
skeletonKmlParts = regexp(skeletonKml,'#PUT_CONTENT_HERE#', 'split');
skeletonKmlHeader = char(skeletonKmlParts(1));
skeletonKmlFooter = char(skeletonKmlParts(2));

fprintf(fpKml, '%s', skeletonKmlHeader);
for i=1:length(class)
    if class(i)==-1
        continue;
    end
    label = int2str(class(i));
    kmlGeneratePoint(fpKml, G, label, ...
        gps(i,1), gps(i,2), 0, speed(i), 0, gps(i,3), gps(i,3));
end
fprintf(fpKml, '%s', skeletonKmlFooter);