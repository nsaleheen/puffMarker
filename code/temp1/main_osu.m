%% Data Processing Framework
% Overview: starting point of the framework.
clear all
%% Basic Configureation files
%
G=config();
G=config_run_osu(G);

PS_LIST=G.PS_LIST;
%report_selfreport_all(G,'formattedraw','report',PS_LIST,G.SELFREPORT.SMKID);
%report_formattedraw_short(G,'formattedraw','report',PS_LIST);
%return;
homeData=[];
pno=size(PS_LIST);
for p=1:pno
	pid=char(PS_LIST{p,1});
	slist=PS_LIST{p,2};
	for s=slist
		sid=char(s);
%        figure;plot_frmtraw(G,pid,sid,'formattedraw',[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_AMBID]); 
%        plot_selfreport(G,pid,sid,'formattedraw',[1,2]);
%        plot_labstudymark(G,pid,sid,'formattedraw');
%        disp('abc');
%         main_rawinfo(G,pid,'raw');
        main_formattedraw(G,pid,sid,'raw','formattedraw');
%        main_formatteddata(G,pid,sid,'formattedraw','formatteddata');
%        figure;plot_frmtdata(G,pid,sid,'formatteddata',[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID]);        
%{
		 main_basicfeature(G,pid,sid,'formatteddata','basicfeature');
%        figure;plot_basicfeature(G,pid,sid,'basicfeature',[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID]);

        main_window(G,pid,sid,'basicfeature','window');
        main_feature(G,pid,sid,'window','feature');

        list_feature=[G.FEATURE.R_ECG.VRVL,G.FEATURE.R_ECG.LFHF,...
                G.FEATURE.R_ECG.HRP1,G.FEATURE.R_ECG.HRP2,...
                G.FEATURE.R_ECG.HRP3,G.FEATURE.R_ECG.RRMN,...
                G.FEATURE.R_ECG.RRMD,G.FEATURE.R_ECG.RRQD,...
                G.FEATURE.R_ECG.RR80,G.FEATURE.R_ECG.RR20,...
                G.FEATURE.R_ECG.RRCT];
        report_feature(G,pid,sid,'feature','report',G.FEATURE.R_ECGID,list_feature);
%        main_model(G,pid,sid,'feature','model');
%}
	end;
end
