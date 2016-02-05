%% Data Processing Framework
% Overview: starting point of the framework.
clear all
%% Basic Configureation files
%
G=config();
G=config_run_nida(G);

PS_LIST=G.PS_LIST;

%report_selfreport_all(G,'formattedraw','report',PS_LIST,G.SELFREPORT.SMKID);
%report_formattedraw_short(G,'formattedraw','report',PS_LIST);
%report_urine('C:\DataProcessingFramework\data\nida\studyinfo\urineprofile.csv');
%return;
%return;
%temp_update_frmtdata_acl(G,'formatteddata');
%return;
%load_nida_pda_selfreport(G,'formatteddata');
%return;
%temp_update_frmtdata_pdamark(G,'formattedraw','formatteddata');
%return;
M.W=600;M.SLOW=2100;M.FAST=240;M.SIGNAL=220;
L.W=600;L.SLOW=4800;L.FAST=30;L.SIGNAL=20;
R.W=600;R.SLOW=1200;R.FAST=90;R.SIGNAL=80;
report_urine('C:\DataProcessingFramework\data\nida\studyinfo\urineprofile_jan27.csv');
report_pda_nida('C:\DataProcessingFramework\data\nida\studyinfo\nida_pda_selfreport_jan27.csv');
fileID = fopen('nida_all_session.csv','w');
load('urine.mat');
load('nida_pda.mat');
all=ls('C:\DataProcessingFramework\data\nida\basicfeature');
for i=3:size(all,1)
    pid=all(i,1:3);
    sid=all(i,5:7);
    disp(all(i,:));
    load(['C:\DataProcessingFramework\data\nida\basicfeature\' all(i,:)]);
    pda_count=0;
    for p=1:length(pda)
        if strcmp(pda(p).pid,pid)==1 && B.METADATA.SESSION_STARTMATLABTIME==pda(p).date_matlabtime
            pda_count=pda_count+1;
        end
    end
    ppid=str2num(pid(2:end));
    cocaine=0;
    for u=1:length(urine)
        if urine(u).pid==ppid && B.METADATA.SESSION_STARTMATLABTIME==urine(u).date
            cocaine=urine(u).cocaine;
        end
    end
    if ~isempty(B.sensor{2}.sample)
        fprintf(fileID,'%s,%s,%s,%f,%d,%d\n',pid,sid,B.METADATA.SESSION_STARTTIME,length(B.sensor{2}.sample)/(64*60*60),pda_count,cocaine);
    else
        fprintf(fileID,'%s,%s,%s,%f,%d,%d\n',pid,sid,B.METADATA.SESSION_STARTTIME,0,pda_count,cocaine);
    end
    urine_pda(i-2).pid=pid;
    urine_pda(i-2).sid=sid;
    urine_pda(i-2).date=B.METADATA.SESSION_STARTTIME;
    urine_pda(i-2).ecg=length(B.sensor{2}.sample);
    urine_pda(i-2).aclx=length(B.sensor{4}.sample);
    urine_pda(i-2).rip=length(B.sensor{1}.sample);    
    urine_pda(i-2).pda=pda_count;
    urine_pda(i-2).urine=cocaine;
end
fclose(fileID);
save('urine_pda.mat','urine_pda');
