%% Data Processing Framework
% Overview: starting point of the framework.
clear all
%% Basic Configureation files
%
G=config();
G=config_run_nida(G);

PS_LIST=G.PS_LIST;
pno=size(PS_LIST);
fid=fopen('nida_all.txt','at');
all=ls('C:\DataProcessingFramework\data\nida\formattedraw');
for i=3:size(all,1)
    pid=all(i,1:3);
    sid=all(i,5:7);

        load(['C:\DataProcessingFramework\data\nida\formattedraw\' pid '_' sid '_frmtraw.mat']);
        if isfield(R,'pdamark')==0, mark=0;else mark=length(R.pdamark);end
        fprintf(fid,'%s,%s,%s,%d\n',pid,sid,datestr(R.start_matlabtime,'dd/mm/yyyy'),mark);
        disp('abc');
end
fclose(fid);