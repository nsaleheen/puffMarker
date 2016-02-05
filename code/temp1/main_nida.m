%% Data Processing Framework
% Overview: starting point of the framework.
clear all
%% Basic Configureation files
%
G=config();
G=config_run_nida(G);


ff=[100,10,16];
ss=[3,3,6];
tt=[2,2,6];
G.AVG=1;G.MED=2;G.P95=3;
pid='p03';sid='s18';
main_basicfeature(G,pid,sid,'formatteddata','basicfeature');
main_window(G,pid,sid,'basicfeature','window',G.MODEL.ACT10);
main_feature(G,pid,sid,'window','feature',G.MODEL.ACT10);

plot_whitehouse(G,pid,sid,ff,ss,tt);


PS_LIST=G.PS_LIST;

%report_selfreport_all(G,'formattedraw','report',PS_LIST,G.SELFREPORT.SMKID);
%report_formattedraw_short(G,'formattedraw','report',PS_LIST);
%report_nida(G,'formattedraw','studyinfo','report',PS_LIST);
%return;
%return;
%temp_update_frmtdata_acl(G,'formatteddata');
%return;
%load_nida_pda_selfreport(G,'formatteddata');
%return;
%temp_update_frmtdata_pdamark(G,'formattedraw','formatteddata');
%return;
PS_LIST= {
    {'p01'},{'s03','s04','s06','s10','s12','s16','s21'};
    {'p03'},{'s18'};
%     {'p06'},{'s01'};
};

pno=size(PS_LIST);
for p=1:pno
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        G.AVG=1;G.MED=2;G.P95=3;
%        figure;plot_basicfeature(G,pid,sid,'basicfeature',[G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID]);
%        plot_pdamark(G,pid,sid,'formattedraw');
%        plot_ecg_rr(G,pid,sid);
        preprocess_rr(G,pid,sid,'basicfeature','preprocess');
%        plot_yixin(G,pid,sid);
        continue;

%          plot_yixin(G,pid,sid,G.MODEL.DRUG10);
%          disp('ab');
%     continue;
        %        figure;plot_frmtraw(G,pid,sid,'formattedraw',[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_AMBID]);
        %        plot_selfreport(G,pid,sid,'formattedraw',[1,2]);
        %        plot_labstudymark(G,pid,sid,'formattedraw');
        %main_rawinfo(G,pid,'raw');
        %      	main_formattedraw(G,pid,sid,'raw','formattedraw');
%         main_formatteddata(G,pid,sid,'formattedraw','formatteddata');
        %        figure;plot_frmtdata(G,pid,sid,'formatteddata',[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID]);
        
%         		main_basicfeature(G,pid,sid,'formatteddata','basicfeature');
%          [md,PR]=find_baseline(G,pid,sid,'basicfeature');
%          disp(['pid=' pid ' sid=' sid ' md=' num2str(md) ' PR=' num2str(PR)]);
%          M(str2num(pid(2:end)),str2num(sid(2:end)),:)=md;
%          P(str2num(pid(2:end)),str2num(sid(2:end)),:)=PR;
%         
%         continue;
%         figure;plot_basicfeature(G,pid,sid,'basicfeature',[G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID]);
%           plot_pdamark(G,pid,sid,'formattedraw');
         
%          continue;
         
        disp([pid ' ' sid]);
        ValidRipDuration=getGoodDataDuration(G,pid,sid);
        saveSelfReport2CSV(G,pid,sid,2);
        saveSelfReport2CSV(G,pid,sid,3);

        %         hold on;plot_pdamark(G,pid,sid,'formattedraw');
%         getMissingRateFromFormattedData(G,pid,sid)



%        saveEMA2file_NIDA_format_v3(G,pid,sid,'formatteddata');
%        disp([pid ' ' sid ' :done']);
%         main_window(G,pid,sid,'basicfeature','window',G.MODEL.DRUG60);
        
%         main_feature(G,pid,sid,'window','feature',G.MODEL.DRUG60);
        %        disp(['pid=' pid ' sid=' sid]);
        %        main_curve(G,pid,sid,'formatteddata','basicfeature','window','feature','curve',G.MODEL.DRUG10);
        %pid='p06';sid='s01';plot_activity(G,pid,sid,G.MODEL.DRUG60);
        %plot_drug(G,pid,sid,G.MODEL.DRUG60);
        % continue;
%                rr=find_activity(G,pid,sid,G.MODEL.DRUG10,rr);
%                 save_feature2text_v3(G,pid,sid,'feature','report');
               saveEMA2file_NIDA_format_v3(G,pid,sid,'formatteddata');
        %        report_labsessions(G,pid,sid,'formatteddata');
        %       disp('abc');
        %{
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
% pno=size(M,1);
% sno=size(M,2);
% dno=size(M,3);
% i=0;
% figure;
% for p=1:pno
%     for d=1:dno        
%         i=i+1;
%         val=M(p,:,d);
%         val(val==-1)=[];
%         val(val==0)=[];
%         val(isnan(val))=[];
%         hold on; scatter(ones(length(val),1)*(p-1)*15+d,val,'.');
%         %        mn(i)=mean(val);
%         %        sd(i)=std(val);
%     end
% end
% disp('abc');