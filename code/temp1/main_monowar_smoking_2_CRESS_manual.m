% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;

pid='p12';
sid='s04';
%load('cress.mat');
%ss=ss+1;
iplot4_monowar_pv_puff(G,pid,sid, 'basicfeature', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_GYRZID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_GYRZID], 1);
pause;
for i=1:length(cursor_info)
    fprintf('%f\n',cursor_info(i).Position(1));
end
%cress.mark{str2num(pid(2:end))}{str2num(sid(2:end))}=cursor_info;
%cress.pos=pos;
%save('cress.mat','cress');
fprintf(') =>  done\n');
