% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking(G);
% pid='p12';
% sid='s04';
% n=3;
% cut_data(G,pid,sid,n);
% plot_episode(G,pid,sid,n,'smoking_episode',1:13);
% return;
PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        for n=1:20
            fprintf('%s %s %d\n',pid,sid,n);
            if cut_data(G,pid,sid,n)==0, break;end;
            plot_episode(G,pid,sid,n,'smoking_episode',[1,3,9]);
        end            
%        iplot4_monowar_pv_puff(G,pid,sid, 'basicfeature', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_GYRZID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_GYRZID], 1);
%        iplot4_monowar_pv_puff(G,pid,sid, 'basicfeature', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLXID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_ACLZID,G.SENSOR.WR9_GYRXID,G.SENSOR.WR9_GYRYID,G.SENSOR.WR9_GYRZID], 1);
        
%        format_cress(G,pid,sid,'formattedraw','formatteddata');
%        correct_cress_v4(G,pid,sid,'formatteddata','basicfeature',DRIFT(p)/60);
        
%        iplot4_monowar_pv(G,pid,sid, 'basicfeature', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID], 1, 0);
%        iplot4_monowar(G,pid,sid, 'formattedraw', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_GYRZID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_GYRZID], 1, (0)/(60*60*24));
%        iplot4_monowar_pv_puff(G,pid,sid, 'basicfeature', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_GYRZID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_GYRZID], 1);
%        iplot4_monowar_pv_puff_episode(G,pid,sid, 'basicfeature', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_GYRZID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_GYRZID], 1, 1);
%        report_smoking(G,pid,sid,'formatteddata');
        disp('abc');

    end
    disp('def');
end
fprintf(') =>  done\n');
