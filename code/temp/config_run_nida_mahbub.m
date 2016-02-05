function G=config_run_nida_mahbub(G)
G.STUDYNAME='memphis';
G.TIME.TIMEZONE=-5;
G.TIME.DAYLIGHTSAVING=1;
G.TIME.FORMAT='mm/dd/yyyy HH:MM:SS';

G.DIR.DATA=[G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP G.STUDYNAME];
% %{
G.PS_LIST= {

%subject and sessions are adjusted according to their actual study participation.
      {'p01'},(cellstr(strcat('s',num2str((1:6)','%02d'))))';
%  	{'p01'},(cellstr(strcat('s',num2str((8:13)','%02d'))))';
%  	{'p01'},(cellstr(strcat('s',num2str((15:21)','%02d'))))';
%  	{'p01'},(cellstr(strcat('s',num2str((23:29)','%02d'))))';
%      {'p02'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
%  	{'p02'},(cellstr(strcat('s',num2str((10:16)','%02d'))))';
%  	{'p02'},(cellstr(strcat('s',num2str((18:26)','%02d'))))';
%  	{'p02'},(cellstr(strcat('s',num2str((28:34)','%02d'))))';
% 	{'p03'},(cellstr(strcat('s',num2str((2:14)','%02d'))))';
%  	{'p03'},(cellstr(strcat('s',num2str((17:26)','%02d'))))';
%      {'p04'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
%  	{'p04'},(cellstr(strcat('s',num2str((10:16)','%02d'))))';
%  	{'p04'},(cellstr(strcat('s',num2str((18:23)','%02d'))))';
%  	{'p04'},(cellstr(strcat('s',num2str((25:31)','%02d'))))';
%      {'p05'},(cellstr(strcat('s',num2str((1:6)','%02d'))))';
%  	{'p05'},(cellstr(strcat('s',num2str((9:10)','%02d'))))';
%  	{'p05'},(cellstr(strcat('s',num2str((12:13)','%02d'))))';
%  	{'p05'},(cellstr(strcat('s',num2str((15:21)','%02d'))))';
%  	{'p05'},(cellstr(strcat('s',num2str((23:27)','%02d'))))';
%      {'p06'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
%  	{'p06'},(cellstr(strcat('s',num2str((10:16)','%02d'))))';
%  	{'p06'},(cellstr(strcat('s',num2str((18:24)','%02d'))))';
%  	{'p06'},(cellstr(strcat('s',num2str((27:33)','%02d'))))';
%      {'p07'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
%  	{'p07'},(cellstr(strcat('s',num2str((9:11)','%02d'))))';
%  	{'p07'},(cellstr(strcat('s',num2str((14:18)','%02d'))))';
%  	{'p07'},(cellstr(strcat('s',num2str((20:24)','%02d'))))';
%      {'p08'},(cellstr(strcat('s',num2str((2:11)','%02d'))))';
%  	{'p08'},(cellstr(strcat('s',num2str((13:26)','%02d'))))';
%      {'p09'},(cellstr(strcat('s',num2str((1:12)','%02d'))))';
%  	{'p09'},(cellstr(strcat('s',num2str((14:20)','%02d'))))';
%  	{'p09'},(cellstr(strcat('s',num2str((22:28)','%02d'))))';
%  	{'p10'},(cellstr(strcat('s',num2str((1:5)','%02d'))))';
%  	{'p10'},(cellstr(strcat('s',num2str((8:14)','%02d'))))';
%  	{'p10'},(cellstr(strcat('s',num2str((16:22)','%02d'))))';
%  	{'p10'},(cellstr(strcat('s',num2str((25:31)','%02d'))))';
%     {'p11'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
%     {'p11'},(cellstr(strcat('s',num2str((9:15)','%02d'))))';
%     {'p11'},(cellstr(strcat('s',num2str((17:23)','%02d'))))';
%     {'p12'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';  
%     {'p12'},(cellstr(strcat('s',num2str((9:15)','%02d'))))';
%     {'p12'},(cellstr(strcat('s',num2str((18:30)','%02d'))))';
%     {'p14'},(cellstr(strcat('s',num2str((2:20)','%02d'))))';
%     {'p14'},(cellstr(strcat('s',num2str((22:28)','%02d'))))';
%     {'p15'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
%     {'p15'},(cellstr(strcat('s',num2str((9:18)','%02d'))))';
%     {'p15'},(cellstr(strcat('s',num2str((21:26)','%02d'))))';
%      {'p16'},(cellstr(strcat('s',num2str((1:23)','%02d'))))';
%  	{'p16'},(cellstr(strcat('s',num2str((25:29)','%02d'))))';
%      {'p17'},(cellstr(strcat('s',num2str((1:5)','%02d'))))';
%  	{'p17'},(cellstr(strcat('s',num2str((8:9)','%02d'))))';
%  	{'p17'},(cellstr(strcat('s',num2str((11:15)','%02d'))))';
%  	{'p17'},(cellstr(strcat('s',num2str((17:24)','%02d'))))';
%      {'p18'},(cellstr(strcat('s',num2str((2:15)','%02d'))))';
%  	{'p18'},(cellstr(strcat('s',num2str((17:21)','%02d'))))';
%      {'p19'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';  
%  	{'p19'},(cellstr(strcat('s',num2str((9:19)','%02d'))))'; 
%   	{'p19'},(cellstr(strcat('s',num2str((20:26)','%02d'))))';  
%      {'p20'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
%      {'p20'},(cellstr(strcat('s',num2str((2:7)','%02d'))))';
%  	{'p20'},(cellstr(strcat('s',num2str((9:15)','%02d'))))';
%  	{'p20'},(cellstr(strcat('s',num2str((17:30)','%02d'))))';
%    {'p20'},(cellstr(strcat('s',num2str((21:26)','%02d'))))';
%      {'p21'},(cellstr(strcat('s',num2str((2:7)','%02d'))))';
%  	{'p21'},(cellstr(strcat('s',num2str((9:23)','%02d'))))';
%  	{'p21'},(cellstr(strcat('s',num2str((25:27)','%02d'))))';
%  	{'p21'},(cellstr(strcat('s',num2str((29:31)','%02d'))))';
%     {'p22'},(cellstr(strcat('s',num2str((1:6)','%02d'))))';
%     {'p23'},(cellstr(strcat('s',num2str((1:32)','%02d'))))';
%     {'p24'},(cellstr(strcat('s',num2str((1:15)','%02d'))))';
%     {'p24'},(cellstr(strcat('s',num2str((16:30)','%02d'))))';
%     {'p24'},(cellstr(strcat('s',num2str((31:43)','%02d'))))';
%     {'p25'},(cellstr(strcat('s',num2str((1:38)','%02d'))))';
%     {'p26'},(cellstr(strcat('s',num2str((1:34)','%02d'))))';
%     {'p27'},(cellstr(strcat('s',num2str((1:32)','%02d'))))';
%     {'p28'},(cellstr(strcat('s',num2str((1:37)','%02d'))))';
%     {'p29'},(cellstr(strcat('s',num2str((1:27)','%02d'))))';
%     {'p30'},(cellstr(strcat('s',num2str((1:32)','%02d'))))';
%     {'p31'},(cellstr(strcat('s',num2str((1:4)','%02d'))))';
%     {'p32'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
%     {'p33'},(cellstr(strcat('s',num2str((1:30)','%02d'))))';
%     {'p34'},(cellstr(strcat('s',num2str((1:34)','%02d'))))';
%     {'p35'},(cellstr(strcat('s',num2str((1:22)','%02d'))))';
%     {'p36'},(cellstr(strcat('s',num2str((1:37)','%02d'))))';
%     {'p37'},(cellstr(strcat('s',num2str((1:1)','%02d'))))';
%     {'p38'},(cellstr(strcat('s',num2str((1:32)','%02d'))))';
%     {'p39'},(cellstr(strcat('s',num2str((1:28)','%02d'))))';
%     {'p40'},(cellstr(strcat('s',num2str((1:22)','%02d'))))';
%     {'p41'},(cellstr(strcat('s',num2str((1:33)','%02d'))))';
%       {'p42'},(cellstr(strcat('s',num2str((1:9)','%02d'))))';
%      {'p42'},(cellstr(strcat('s',num2str((10:14)','%02d'))))';
   };

%{
G.PS_LIST= {
    {'p01'},{'s01','s02','s03','s06','s08','s10','s12','s16','s17','s18'};    
    {'p02'},{'s01','s05','s10','s11','s14','s15','s18','s20','s21','s23'};   
    {'p04'},{'s04','s06','s07','s10','s11','s12','s14','s18','s19','s21'};
    {'p05'},{'s01','s02','s09','s12','s16','s18','s19','s20','s26','s27'};
    {'p06'},{'s01','s03','s07','s10','s11','s12','s14','s19','s22','s24'}; 
    {'p08'},{'s02','s03','s09','s11','s13','s15','s16','s17','s18','s26'};
    {'p09'},{'s01','s03','s04','s07','s08','s10','s11','s15','s16','s18'};
    {'p10'},{'s01','s03','s05','s08','s09','s10','s11','s14','s16','s18'};
};
%}

% G.PS_LIST= {
%     {'p17'},{'s11'};
% %     {'p06'},{'s01'};
% };

%{
    {'p01'},{'s04','s06','s10','s12','s16','s21'};    {'p03'},{'s18'};    {'p04'},{'s04','s07'};
    {'p06'},{'s01','s03','s13','s16','s19','s20','s22','s31','s32'};
    {'p08'},{'s06','s07','s09','s18'}; {'p09'},{'s10','s12'};{'p12'},{'s02','s07','s10','s15','s20','s22','s24','s25','s27'};
    {'p14'},{'s10','s11','s13','s15','s16','s19','s24','s27'};
    {'p15'},{'s02','s05','s09','s10','s12','s13','s14','s16','s25','s26'};{'p18'},{'s04','s05','s12'};
    {'p19'},{'s01'};
%}    

%}
%{
G.PS_LIST= {
%all
    {'p01'},(cellstr(strcat('s',num2str((1:30)','%02d'))))';
    {'p02'},(cellstr(strcat('s',num2str((1:35)','%02d'))))';
	{'p03'},(cellstr(strcat('s',num2str((1:27)','%02d'))))';
    {'p04'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
	{'p04'},(cellstr(strcat('s',num2str((10:16)','%02d'))))';
	{'p04'},(cellstr(strcat('s',num2str((18:23)','%02d'))))';
	{'p04'},(cellstr(strcat('s',num2str((25:31)','%02d'))))';
    {'p05'},(cellstr(strcat('s',num2str((1:6)','%02d'))))';
	{'p05'},(cellstr(strcat('s',num2str((9:10)','%02d'))))';
	{'p05'},(cellstr(strcat('s',num2str((12:13)','%02d'))))';
	{'p05'},(cellstr(strcat('s',num2str((15:21)','%02d'))))';
	{'p05'},(cellstr(strcat('s',num2str((23:27)','%02d'))))';
    {'p06'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
	{'p06'},(cellstr(strcat('s',num2str((10:16)','%02d'))))';
	{'p06'},(cellstr(strcat('s',num2str((18:24)','%02d'))))';
	{'p06'},(cellstr(strcat('s',num2str((27:33)','%02d'))))';
    {'p07'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
	{'p07'},(cellstr(strcat('s',num2str((9:11)','%02d'))))';
	{'p07'},(cellstr(strcat('s',num2str((14:18)','%02d'))))';
	{'p07'},(cellstr(strcat('s',num2str((20:24)','%02d'))))';
    {'p08'},(cellstr(strcat('s',num2str((2:11)','%02d'))))';
	{'p08'},(cellstr(strcat('s',num2str((13:26)','%02d'))))';
    {'p09'},(cellstr(strcat('s',num2str((1:12)','%02d'))))';
	{'p09'},(cellstr(strcat('s',num2str((14:20)','%02d'))))';
	{'p09'},(cellstr(strcat('s',num2str((22:28)','%02d'))))';
	{'p10'},(cellstr(strcat('s',num2str((1:5)','%02d'))))';
	{'p10'},(cellstr(strcat('s',num2str((8:14)','%02d'))))';
	{'p10'},(cellstr(strcat('s',num2str((16:22)','%02d'))))';
	{'p10'},(cellstr(strcat('s',num2str((25:31)','%02d'))))';
   {'p11'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
   {'p11'},(cellstr(strcat('s',num2str((9:15)','%02d'))))';
   {'p11'},(cellstr(strcat('s',num2str((17:23)','%02d'))))';
   {'p12'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';  
   {'p12'},(cellstr(strcat('s',num2str((9:15)','%02d'))))';
   {'p12'},(cellstr(strcat('s',num2str((18:30)','%02d'))))';
   {'p14'},(cellstr(strcat('s',num2str((2:20)','%02d'))))';
   {'p14'},(cellstr(strcat('s',num2str((22:28)','%02d'))))';
   {'p15'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
   {'p15'},(cellstr(strcat('s',num2str((9:18)','%02d'))))';
   {'p15'},(cellstr(strcat('s',num2str((21:26)','%02d'))))';
    {'p16'},(cellstr(strcat('s',num2str((1:23)','%02d'))))';
	{'p16'},(cellstr(strcat('s',num2str((25:29)','%02d'))))';
    {'p17'},(cellstr(strcat('s',num2str((1:5)','%02d'))))';
	{'p17'},(cellstr(strcat('s',num2str((8:9)','%02d'))))';
	{'p17'},(cellstr(strcat('s',num2str((11:15)','%02d'))))';
	{'p17'},(cellstr(strcat('s',num2str((17:24)','%02d'))))';
    {'p18'},(cellstr(strcat('s',num2str((2:15)','%02d'))))';
	{'p18'},(cellstr(strcat('s',num2str((17:21)','%02d'))))';
    {'p19'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';  
	{'p19'},(cellstr(strcat('s',num2str((9:19)','%02d'))))'; 
 	{'p19'},(cellstr(strcat('s',num2str((20:26)','%02d'))))';  
    {'p20'},(cellstr(strcat('s',num2str((1:7)','%02d'))))';
	{'p20'},(cellstr(strcat('s',num2str((9:15)','%02d'))))';
	{'p20'},(cellstr(strcat('s',num2str((17:30)','%02d'))))';
    {'p21'},(cellstr(strcat('s',num2str((2:7)','%02d'))))';
	{'p21'},(cellstr(strcat('s',num2str((9:23)','%02d'))))';
	{'p21'},(cellstr(strcat('s',num2str((25:27)','%02d'))))';
	{'p21'},(cellstr(strcat('s',num2str((29:31)','%02d'))))';

   };
%}



    %% Formatted Raw
    G.RUN.FRMTRAW.SENSORLIST_TOS=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
        G.SENSOR.R_BAT_SKN_AMB_ID,G.SENSOR.R_BATID,G.SENSOR.R_SKINID,G.SENSOR.R_AMBID];
    G.RUN.FRMTRAW.SENSORLIST_DB=[G.SENSOR.P_ACLXID, G.SENSOR.P_ACLYID, G.SENSOR.P_ACLZID];
    G.RUN.FRMTRAW.SELFREPORTLIST=[G.SELFREPORT.DRNKID,G.SELFREPORT.SMKID,G.SELFREPORT.CRVID];
    G.RUN.FRMTRAW.SENSORLIST_GPS=[G.SENSOR.P_GPS_LATID, G.SENSOR.P_GPS_LONGID, G.SENSOR.P_GPS_ALTID, G.SENSOR.P_GPS_SPDID, G.SENSOR.P_GPS_BEAR, G.SENSOR.P_GPS_ACCURACYID];
    
    G.RUN.FRMTRAW.LOADDATA=0;
    G.RUN.FRMTRAW.TOS=1;
    G.RUN.FRMTRAW.PHONESENSOR=0;
    G.RUN.FRMTRAW.GPS=0;
    G.RUN.FRMTRAW.SELFREPORT=1;
    G.RUN.FRMTRAW.LABSTUDYMARK=1;
    G.RUN.FRMTRAW.LABSTUDYLOG=1;
    G.RUN.FRMTRAW.EMA=1;
    G.RUN.FRMTRAW.TOSFILETIME=1;
    
    %% Formatted Data
    G.RUN.FRMTDATA.SENSORLIST_CORRECTTIMESTAMP=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
        G.SENSOR.R_SKINID,G.SENSOR.R_AMBID,G.SENSOR.R_BATID];
    G.RUN.FRMTDATA.SENSORLIST_INTERPOLATE=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID];
%     G.RUN.FRMTDATA.SENSORLIST_QUALITY=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
    G.RUN.FRMTDATA.SENSORLIST_QUALITY=[G.SENSOR.R_RIPID];
%     G.RUN.FRMTDATA.SENSORLIST_QUALITY=[G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
    
    G.RUN.FRMTDATA.LOADDATA=0;
    G.RUN.FRMTDATA.EMA=1;
    G.RUN.FRMTDATA.CORRECTTIMESTAMP=1;
    G.RUN.FRMTDATA.INTERPOLATE=1;
    G.RUN.FRMTDATA.QUALITY=1;
    
    G.RUN.BASICFEATURE.LOADDATA=0;
    G.RUN.BASICFEATURE.PEAKVALLEY=1;
    G.RUN.BASICFEATURE.RR=1;
    
    G.RUN.WINDOW.LOADDATA=0;
    G.RUN.FEATURE.LOADDATA=0;
    G.RUN.MODEL=G.MODEL.STRESS60;
    
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
