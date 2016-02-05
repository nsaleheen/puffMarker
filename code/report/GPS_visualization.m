G=config();
G=config_run_memphis(G);

pid=22;
sid=1;
load(['c:\dataProcessingFrameworkV2\data\memphis\formatteddata\p' num2str(pid) '_' strcat('s',num2str(sid','%02d')) '_frmtdata.mat']);
start=1;
endd=length(D.sensor{14}.sample);

speed=D.sensor{17}.sample(start:endd);
% length(D.sensor{14}.sample)
% length(D.sensor{15}.sample)
% length(D.sensor{16}.sample)
% length(D.sensor{17}.sample)
nonVehicleInd=find(speed<2.53);

%sample every 60th samples to get it one sample over a minute
nonVehicleIndPerMinute=nonVehicleInd(1:60:end);

%gps=[double(D.sensor{14}.sample(nonVehicleInd)),double(D.sensor{15}.sample(nonVehicleInd)), D.sensor{16}.timestamp(nonVehicleInd)];
gps=[double(D.sensor{14}.sample(nonVehicleIndPerMinute)),double(D.sensor{15}.sample(nonVehicleIndPerMinute)), D.sensor{16}.timestamp(nonVehicleIndPerMinute)];


fpKml = fopen(['c:\DataProcessingFrameworkV2\data\memphis\clurstering\GPS_p' num2str(pid) '_' strcat('s',num2str(sid','%02d')) '.kml'],'w');
skeletonPath = 'functions/kml/skleton_kml.txt';
skeletonKml = getFileContent(skeletonPath);
skeletonKmlParts = regexp(skeletonKml,'#PUT_CONTENT_HERE#', 'split');
skeletonKmlHeader = char(skeletonKmlParts(1));
skeletonKmlFooter = char(skeletonKmlParts(2));

fprintf(fpKml, '%s', skeletonKmlHeader);
for i=1:size(gps,1)
%     if class(i)==-1
%         continue;
%     end
    label = int2str(i);
    kmlGeneratePoint(fpKml, G, label, ...
        gps(i,1), gps(i,2), 0, speed(nonVehicleInd(i)), 0, gps(i,3), gps(i,3));
end
fprintf(fpKml, '%s', skeletonKmlFooter);


disp([num2str(pid) '_' num2str(sid) '_done']);