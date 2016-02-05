%% Data Processing Framework
% Overview: starting point of the framework.
clear all
%% Basic Configureation files
%
G=config();
G=config_run_NIDAc(G);

PS_LIST=G.PS_LIST;

pno=size(PS_LIST);
for p=1:pno
    pid=char(PS_LIST{p,1});    
    slist=PS_LIST{p,2};
%    main_rawinfo(G,pid,'raw');
    for s=slist
        sid=char(s);
%        main_formattedraw(G,pid,sid,'raw','formattedraw');
%        load_NIDAc_pda_labreport(G,pid,sid,'studyinfo', 'formattedraw');
        
%        main_formatteddata(G,pid,sid,'formattedraw','formatteddata');
        %        figure;plot_frmtdata(G,pid,sid,'formatteddata',[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID]);
        
%   		main_basicfeature(G,pid,sid,'formatteddata','basicfeature');
%        main_window(G,pid, sid,'basicfeature','window',G.MODEL.ACT10SLIDE);
%        main_feature(G,pid, sid,'window','feature',G.MODEL.ACT10SLIDE);
        plot_rr_activity_mark(G,pid,sid,G.MODEL.ACT10SLIDE);

%          [md,PR]=find_baseline(G,pid,sid,'basicfeature');
%          disp(['pid=' pid ' sid=' sid ' md=' num2str(md) ' PR=' num2str(PR)]);
%          M(str2num(pid(2:end)),str2num(sid(2:end)),:)=md;
%          P(str2num(pid(2:end)),str2num(sid(2:end)),:)=PR;
%         
%         continue;
%         figure;plot_basicfeature(G,pid,sid,'basicfeature',[G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID]);
%           plot_pdamark(G,pid,sid,'formattedraw');
         
%          continue;
%{         
        disp([pid ' ' sid]);
        ValidRipDuration=getGoodDataDuration(G,pid,sid);
        saveSelfReport2CSV(G,pid,sid,2);
        saveSelfReport2CSV(G,pid,sid,3);

        %         hold on;plot_pdamark(G,pid,sid,'formattedraw');
%         getMissingRateFromFormattedData(G,pid,sid)

%}

%        saveEMA2file_NIDA_format_v3(G,pid,sid,'formatteddata');
%        disp([pid ' ' sid ' :done']);
%         main_window(G,pid,sid,'basicfeature','window',G.MODEL.DRUG60);
        
    end;
end