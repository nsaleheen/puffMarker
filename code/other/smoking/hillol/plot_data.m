G=config();
G=config_run_SmokingLab(G);

sensorList=[ ...
    G.SENSOR.R_RIPID, ...
    G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
    G.SENSOR.WR9_ACLXID G.SENSOR.WR9_ACLYID G.SENSOR.WR9_ACLZID G.SENSOR.WR9_GYRXID G.SENSOR.WR9_GYRYID G.SENSOR.WR9_GYRZID G.SENSOR.WL9_NULLID ...
    G.SENSOR.WL9_ACLXID G.SENSOR.WL9_ACLYID G.SENSOR.WL9_ACLZID G.SENSOR.WL9_GYRXID G.SENSOR.WL9_GYRYID G.SENSOR.WL9_GYRZID G.SENSOR.WR9_NULLID ...
    ];
%dataPath = 'C:\dev\project\smoking\classifier\classifier_data\Hillol\2014-07-01';
%dataPath = 'C:\Users\hsarker\Desktop\DelMe\tmp\d';
%dataPath = 'C:\dev\project\smoking\classifier\classifier_data\Amin\2014-07-01';
%dataPath = 'C:\dev\project\smoking\classifier\classifier_data\Amin\2014-07-03';
dataPath = 'C:\DataProcessingFramework_COC_M\data\smoking_lab\p01\raw\2014-07-28';
D.sensor=read_tosfiles2(G,dataPath, sensorList);
fprintf('\n');

D.label=read_datalabel2(G, dataPath);
%slist = [G.SENSOR.R_RIPID G.SENSOR.WR9_ACLYID G.SENSOR.WL9_ACLYID];
slist = [G.SENSOR.R_RIPID G.SENSOR.WR9_ACLYID];

figure;
iplot5_smoking(G, D, slist);
return;


rawX = D.sensor{G.SENSOR.WR9_ACLXID}.sample;
rawY = D.sensor{G.SENSOR.WR9_ACLYID}.sample;
rawZ = D.sensor{G.SENSOR.WR9_ACLZID}.sample;

%rawY = rawY(45346:45797);


[xL xG] = getLinearGravity(rawX);
[yL yG] = getLinearGravity(rawY);
[zL zG] = getLinearGravity(rawZ);

j=1;
for i=1:length(D.label)
    if strcmp(D.label(i).label, 'Smoking')==1
        smokingLabels(j) = D.label(i);
        j=j+1;
    end
end

smokingIndex = 2;
ttFrom = smokingLabels(smokingIndex).starttimeM;
ttTo = smokingLabels(smokingIndex).endtimeM;
%ttFrom = 735781.6091054282;
%ttTo = 735781.6093389930;
increment = 1/(24*60*60*100);

timestampsM = ttFrom:increment:ttTo;


x = interp1(D.sensor{G.SENSOR.WR9_ACLXID}.matlabtime, xG, timestampsM); %rawX xG
y = interp1(D.sensor{G.SENSOR.WR9_ACLYID}.matlabtime, yG, timestampsM); %rawY yG
z = interp1(D.sensor{G.SENSOR.WR9_ACLZID}.matlabtime, zG, timestampsM); %rawZ zG


xGmps = getGravity(xG,  -995, 1044); %X: -995, +1044
yGmps = getGravity(yG, -1044, 1019); %Y: -1044, +1019
zGmps = getGravity(zG, -1138, 952);  %Z: -1138, +952

yTheta = acosd(yGmps/9.8);
figure;
%plot(yGmps, 'r');
plot(D.sensor{G.SENSOR.WR9_ACLYID}.timestamp, yTheta, 'r');
hold on;
plot(D.sensor{G.SENSOR.WR9_ACLYID}.timestamp, yGmps, 'g');

%return;
%{
figure;
plot(rawY, 'r');
hold on;
plot(yG, 'b');
hold on;
plot(yL, 'g');
hold on;
return;
%}



figure;
comet3(x, y, z);

%plot3(x,y,z);

%{
color=1:length(x);
surface([x;x],[y;y],[z;z],[color ;color],'facecol','no','edgecol','interp');
%}

%{
%comet3(x, y, z);
%xlabel('x'); ylabel('y'); zlabel('z');
%}

%{
gx = interp1(D.sensor{G.SENSOR.WR9_GYRXID}.matlabtime, D.sensor{G.SENSOR.WR9_GYRXID}.sample, timestampsM);
gy = interp1(D.sensor{G.SENSOR.WR9_GYRYID}.matlabtime, D.sensor{G.SENSOR.WR9_GYRYID}.sample, timestampsM);
gz = interp1(D.sensor{G.SENSOR.WR9_GYRZID}.matlabtime, D.sensor{G.SENSOR.WR9_GYRZID}.sample, timestampsM);
comet3(gx, gy, gz);
%}