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
dataPath = 'C:\dev\project\smoking\classifier\classifier_data\Amin\2014-07-03';
D.sensor=read_tosfiles2(G,dataPath, sensorList);
fprintf('\n');

D.label=read_datalabel2(G, dataPath);
%slist = [G.SENSOR.R_RIPID G.SENSOR.WR9_ACLYID G.SENSOR.WL9_ACLYID];
slist = [G.SENSOR.WR9_ACLYID];

%iplot5_smoking(G, D, slist);
%return;


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
%ttFrom = smokingLabels(smokingIndex).starttimeM;
%ttTo = smokingLabels(smokingIndex).endtimeM;
%ttFrom = 735781.6091054282;
%ttTo = 735781.6093389930;
ttFrom = min(D.sensor{G.SENSOR.WR9_ACLYID}.matlabtime);
ttTo = max(D.sensor{G.SENSOR.WR9_ACLYID}.matlabtime);
increment = 1/(24*60*60*100);

timestampsM = ttFrom:increment:ttTo;


x = interp1(D.sensor{G.SENSOR.WR9_ACLXID}.matlabtime, xG, timestampsM); %rawX xG
y = interp1(D.sensor{G.SENSOR.WR9_ACLYID}.matlabtime, yG, timestampsM); %rawY yG
z = interp1(D.sensor{G.SENSOR.WR9_ACLZID}.matlabtime, zG, timestampsM); %rawZ zG



xGmps = getGravity(x,  -995, 1044); %X: -995, +1044
yGmps = getGravity(y, -1044, 1019); %Y: -1044, +1019
zGmps = getGravity(z, -1138, 952);  %Z: -1138, +952

yTheta = acosd(yGmps/9.8);


g = sqrt(xGmps.^2+yGmps.^2+zGmps.^2);

plot(timestampsM, yTheta, 'r');
hold on;
plot(timestampsM, yGmps, 'g');

hold on;
plot(timestampsM, g, 'b');
