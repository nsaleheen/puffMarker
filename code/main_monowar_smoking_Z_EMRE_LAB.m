% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%find_smoking_episodes(G);
list={
    {'p01','s02',1:3},{'p01','s03',1:4},...
    {'p02','s03',1:3},{'p02','s04',1},{'p02','s05',1},{'p02','s06',1},...
   {'p03','s01',1:3}
%    {'p03','s01',1}
};
for l=1:length(list)
    pid=list{l}{1};sid=list{l}{2};
    cut_lab_data(G,pid,sid,'episode');
    
%    find_mark_peakvalley(G,pid,sid,'preprocess');
%    for episode=list{l}{3}
%        iplot4_monowar_pv_puff_bar_filter_updown_mark(G,pid,sid,episode,'preprocess',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],700);    
%    end
end


% find_mark_peakvalley(G,pid,sid,'preprocess');
% iplot4_monowar_pv_puff_bar_filter_updown_mark(G,pid,sid,episode,'preprocess',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],700);
% pause;
% for i=1:length(cursor_info)
%     fprintf('%f\n',cursor_info(i).Position(1));
% end
%cress.mark{str2num(pid(2:end))}{str2num(sid(2:end))}=cursor_info;
%cress.pos=pos;
%save('cress.mat','cress');
fprintf(') =>  done\n');
