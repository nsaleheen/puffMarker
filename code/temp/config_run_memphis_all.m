function G=config_run_memphis(G)
G.STUDYNAME='memphis';
G.TIME.TIMEZONE=-6;
G.TIME.DAYLIGHTSAVING=1;
G.TIME.FORMAT='mm/dd/yyyy HH:MM:SS';

G.DIR.DATA=[G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP G.STUDYNAME];

G.PS_LIST= {
    {'p12'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
    {'p13'},(cellstr(strcat('s',num2str((2:9)','%02d'))))';
    {'p14'},(cellstr(strcat('s',num2str((4:10)','%02d'))))';
%     {'p14'},(cellstr(strcat('s',num2str((7:10)','%02d'))))';
    {'p15'},(cellstr(strcat('s',num2str((1:9)','%02d'))))';
    {'p16'},(cellstr(strcat('s',num2str((2:9)','%02d'))))';
    {'p17'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
    {'p18'},(cellstr(strcat('s',num2str((11:17)','%02d'))))';
    {'p19'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
    {'p20'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';    
    {'p21'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
    {'p22'},(cellstr(strcat('s',num2str((1:9)','%02d'))))';
    {'p24'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
    {'p25'},(cellstr(strcat('s',num2str((2:8)','%02d'))))';
    {'p26'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
    {'p27'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';    
    {'p28'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
    {'p29'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
    {'p30'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
    {'p31'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
    {'p32'},(cellstr(strcat('s',num2str((2:8)','%02d'))))';
    {'p33'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
    {'p34'},(cellstr(strcat('s',num2str((4:11)','%02d'))))';
    {'p35'},(cellstr(strcat('s',num2str((1:10)','%02d'))))';
   
    {'p36'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
    {'p37'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
%     {'p38'},(cellstr(strcat('s',num2str((1:3)','%02d'))))';
    {'p39'},(cellstr(strcat('s',num2str((2:8)','%02d'))))';
    {'p40'},(cellstr(strcat('s',num2str((2:8)','%02d'))))';
    {'p41'},(cellstr(strcat('s',num2str((3:9)','%02d'))))';
    {'p42'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
    {'p43'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
    {'p44'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
};
%% Formatted Raw
G.RUN.FRMTRAW.SENSORLIST_TOS=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
    G.SENSOR.A_ALCID,G.SENSOR.R_BAT_SKN_AMB_ID,G.SENSOR.R_BATID,G.SENSOR.R_SKINID,G.SENSOR.R_AMBID,G.SENSOR.A_GSRID,G.SENSOR.A_TEMPID];
G.RUN.FRMTRAW.SENSORLIST_DB=[G.SENSOR.P_ACLXID, G.SENSOR.P_ACLYID, G.SENSOR.P_ACLZID];
G.RUN.FRMTRAW.SELFREPORTLIST=[G.SELFREPORT.DRNKID,G.SELFREPORT.SMKID,G.SELFREPORT.CRVID];
G.RUN.FRMTRAW.SENSORLIST_GPS=[G.SENSOR.P_GPS_LATID, G.SENSOR.P_GPS_LONGID, G.SENSOR.P_GPS_ALTID, G.SENSOR.P_GPS_SPDID, G.SENSOR.P_GPS_BEAR, G.SENSOR.P_GPS_ACCURACYID];
                
G.RUN.FRMTRAW.LOADDATA=0;
G.RUN.FRMTRAW.TOS=1;
G.RUN.FRMTRAW.PHONESENSOR=1;
G.RUN.FRMTRAW.GPS=1;
G.RUN.FRMTRAW.SELFREPORT=1;
G.RUN.FRMTRAW.LABSTUDYMARK=1;
G.RUN.FRMTRAW.LABSTUDYLOG=1;
G.RUN.FRMTRAW.EMA=1;

%% Formatted Data
G.RUN.FRMTDATA.SENSORLIST_CORRECTTIMESTAMP=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
    G.SENSOR.A_ALCID,G.SENSOR.R_BAT_SKN_AMB_ID,G.SENSOR.R_SKINID,G.SENSOR.R_AMBID,G.SENSOR.R_BATID,G.SENSOR.A_GSRID,G.SENSOR.A_TEMPID];
G.RUN.FRMTDATA.SENSORLIST_INTERPOLATE=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
    G.SENSOR.A_ALCID,G.SENSOR.R_BAT_SKN_AMB_ID,G.SENSOR.A_GSRID,G.SENSOR.A_TEMPID];
% G.RUN.FRMTDATA.SENSORLIST_QUALITY=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID];
% G.RUN.FRMTDATA.SENSORLIST_QUALITY=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID];
G.RUN.FRMTDATA.SENSORLIST_QUALITY=[G.SENSOR.P_ACLXID, G.SENSOR.P_ACLYID, G.SENSOR.P_ACLZID];

G.RUN.FRMTDATA.LOADDATA=1;
G.RUN.FRMTDATA.EMA=0;
G.RUN.FRMTDATA.CORRECTTIMESTAMP=0;
G.RUN.FRMTDATA.INTERPOLATE=0;
G.RUN.FRMTDATA.QUALITY=1;

G.RUN.BASICFEATURE.LOADDATA=0;
G.RUN.BASICFEATURE.PEAKVALLEY=0;
G.RUN.BASICFEATURE.RR=1;

G.RUN.WINDOW.LOADDATA=0;
G.RUN.FEATURE.LOADDATA=1;
G.RUN.MODEL=G.MODEL.ACT10;

%accelerometer bias for the calibration
G.BIAS(G.SENSOR.R_ACLXID)=1865;
G.BIAS(G.SENSOR.R_ACLYID)=1875;
G.BIAS(G.SENSOR.R_ACLZID)=1958;
end
%{

RUN.FRMTDATA.LOADFRMTDATA=0;
RUN.FRMTDATA.EMA=1;
RUN.FRMTDATA.FORMATSENSOR=[SENSOR.R_RIPID,SENSOR.R_ECGID,SENSOR.R_GSRID,SENSOR.R_ACLXID, SENSOR.R_ACLYID, SENSOR.R_ACLZID, SENSOR.A_ALCID];
RUN.FRMTDATA.RIP=1;RUN.FRMTDATA.ECG=1;RUN.FRMTDATA.ACL=1;
RUN.FRMTDATA.NIDA_PDA_SELFREPORT=1;
RUN.FRMTDATA.JHU_PDA_LABREPORT=0;

RUN.BASICFEATURE.RAW_NORMALIZE=[SENSOR.R_ACLXID, SENSOR.R_ACLYID, SENSOR.R_ACLZID];
RUN.BASICFEATURE.LOADDATA=1;
RUN.BASICFEATURE.RIP=0;
RUN.BASICFEATURE.ECG=0;
RUN.BASICFEATURE.RIPECG=0;
RUN.BASICFEATURE.ACCEL=0;
%}
