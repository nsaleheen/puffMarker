function [ G ] = config_run_monowar_Memphis_Smoking_Lab( G )
G.STUDYNAME='Memphis_Smoking_Lab';
G.TIME.TIMEZONE=-6;
G.TIME.DAYLIGHTSAVING=1;
G.TIME.FORMAT='mm/dd/yyyy HH:MM:SS';

G.DIR.DATA=[G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP G.STUDYNAME];

G.PS_LIST= {
{'p01'},(cellstr(strcat('s',num2str((2:5)','%02d'))))';
{'p02'},(cellstr(strcat('s',num2str(([3:6,8])','%02d'))))';
{'p03'},(cellstr(strcat('s',num2str((1:3)','%02d'))))';
{'p04'},(cellstr(strcat('s',num2str((1:1)','%02d'))))';
{'p05'},(cellstr(strcat('s',num2str((1:1)','%02d'))))';
{'p06'},(cellstr(strcat('s',num2str((1:1)','%02d'))))';

};
%% Formatted Raw
%G.RUN.FRMTRAW.SENSORLIST_TOS=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,...
%    G.SENSOR.WL9_ACLYID,G.SENSOR.WR9_ACLYID];
G.RUN.FRMTRAW.SENSORLIST_TOS=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
        G.SENSOR.R_BAT_SKN_AMB_ID,G.SENSOR.R_BATID,G.SENSOR.R_SKINID,G.SENSOR.R_AMBID, ...
        G.SENSOR.WL9_ACLXID, G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_ACLZID, ...        
        G.SENSOR.WL9_GYRXID, G.SENSOR.WL9_GYRYID,G.SENSOR.WL9_GYRZID, ...
        G.SENSOR.WR9_ACLXID, G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_ACLZID, ...        
        G.SENSOR.WR9_GYRXID, G.SENSOR.WR9_GYRYID,G.SENSOR.WR9_GYRZID
        
        ];

G.RUN.FRMTRAW.SENSORLIST_DB=[G.SENSOR.P_ACLXID, G.SENSOR.P_ACLYID, G.SENSOR.P_ACLZID];
G.RUN.FRMTRAW.SELFREPORTLIST=[G.SELFREPORT.DRNKID,G.SELFREPORT.SMKID,G.SELFREPORT.CRVID];
G.RUN.FRMTRAW.SENSORLIST_GPS=[G.SENSOR.P_GPS_LATID, G.SENSOR.P_GPS_LONGID, G.SENSOR.P_GPS_ALTID, G.SENSOR.P_GPS_SPDID, G.SENSOR.P_GPS_BEAR, G.SENSOR.P_GPS_ACCURACYID];

G.RUN.FRMTRAW.LOADDATA=0;
G.RUN.FRMTRAW.TOS=1;
G.RUN.FRMTRAW.PHONESENSOR=0;
G.RUN.FRMTRAW.GPS=0;
G.RUN.FRMTRAW.SELFREPORT=0;
G.RUN.FRMTRAW.LABSTUDYMARK=0;
G.RUN.FRMTRAW.LABSTUDYLOG=0;
G.RUN.FRMTRAW.EMA=0;
G.RUN.FRMTRAW.CRESS=0;
G.RUN.FRMTRAW.TOSFILETIME=1;
G.RUN.FRMTRAW.DATALABEL=1;
%% Formatted Data
G.RUN.FRMTDATA.SENSORLIST_CORRECTTIMESTAMP=[G.SENSOR.R_RIPID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
        G.SENSOR.WL9_ACLXID, G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_ACLZID, ...        
        G.SENSOR.WL9_GYRXID, G.SENSOR.WL9_GYRYID,G.SENSOR.WL9_GYRZID, ...
        G.SENSOR.WR9_ACLXID, G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_ACLZID, ...        
        G.SENSOR.WR9_GYRXID, G.SENSOR.WR9_GYRYID,G.SENSOR.WR9_GYRZID
    
    ];
G.RUN.FRMTDATA.SENSORLIST_INTERPOLATE=[G.SENSOR.R_RIPID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
        G.SENSOR.WL9_ACLXID, G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_ACLZID, ...        
        G.SENSOR.WL9_GYRXID, G.SENSOR.WL9_GYRYID,G.SENSOR.WL9_GYRZID, ...
        G.SENSOR.WR9_ACLXID, G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_ACLZID, ...        
        G.SENSOR.WR9_GYRXID, G.SENSOR.WR9_GYRYID,G.SENSOR.WR9_GYRZID
    
    ];
G.RUN.FRMTDATA.SENSORLIST_QUALITY=[G.SENSOR.R_RIPID];

G.RUN.FRMTDATA.LOADDATA=0;
G.RUN.FRMTDATA.EMA=0;
G.RUN.FRMTDATA.CORRECTTIMESTAMP=1;
G.RUN.FRMTDATA.INTERPOLATE=1;
G.RUN.FRMTDATA.QUALITY=1;

G.RUN.BASICFEATURE.LOADDATA=0;
G.RUN.BASICFEATURE.PEAKVALLEY=1;
G.RUN.BASICFEATURE.RR=0;

G.RUN.WINDOW.LOADDATA=0;
G.RUN.FEATURE.LOADDATA=0;
G.RUN.MODEL=G.MODEL.STRESS60;

end
