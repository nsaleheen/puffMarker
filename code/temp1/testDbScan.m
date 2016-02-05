G=config();
G=config_run_memphis(G);

load('C:\DataProcessingFramework\data\memphis\formatteddata\p16_s09_frmtdata.mat');
start=1;
endd=length(D.sensor{14}.sample);

speed=D.sensor{17}.sample(start:endd);
% length(D.sensor{14}.sample)
% length(D.sensor{15}.sample)
% length(D.sensor{16}.sample)
% length(D.sensor{17}.sample)
nonVehicleInd=find(speed<5);

gps=[double(D.sensor{14}.sample(nonVehicleInd)),double(D.sensor{15}.sample(nonVehicleInd)), D.sensor{16}.timestamp(nonVehicleInd)];
[class,type]=DBSCAN(gps,100,250);

fpKml = fopen('c:\DataProcessingFramework\data\memphis\clurstering\dbcluster9.kml','w');
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
        gps(i,1), gps(i,2), 0, speed(nonVehicleInd(i)), 0, gps(i,3), gps(i,3));
end
fprintf(fpKml, '%s', skeletonKmlFooter);