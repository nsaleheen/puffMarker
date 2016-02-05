%% Data Processing Framework
% Overview: starting point of the framework.
clear all
%% Basic Configureation files
%
G=config();
G=config_run_nida(G);

PS_LIST=G.PS_LIST;
M.W=600;M.SLOW=2100;M.FAST=240;M.SIGNAL=220;
L.W=600;L.SLOW=4800;L.FAST=30;L.SIGNAL=20;
R.W=600;R.SLOW=1200;R.FAST=90;R.SIGNAL=80;
% GOOD 
%PS_LIST={ {'p01'},{'s10','s16','s21'};{'p03'},{'s18'};{'p06'},{'s01','s03'};{'p09'},{'s10'};{'p12'},{'s27'};{'p14'},{'s16'};{'p15'},{'s10','s13'};};
% MEDIUM: 
%PS_LIST={ {'p01'},{'s04'};{'p06'},{'s13','s16','s32'};{'p12'},{'s10'};{'p14'},{'s10'};{'p15'},{'s02','s16'};{'p18'},{'s05'};{'p21'},{'s12'};};
% BAD: 
%PS_LIST={ {'p01'},{'s12'};{'p06'},{'s19'};{'p08'},{'s06'};{'p12'},{'s15','s22','s24'};{'p14'},{'s11','s24'};{'p15'},{'s05','s25'};{'p18'},{'s12'};{'p19'},{'s18'};};

% FINAL COCAINE: (15)
%PS_LIST={ {'p01'},{'s04','s10','s16','s21'};{'p03'},{'s18'};{'p06'},{'s01','s03','s32'};{'p09'},{'s10'};{'p12'},{'s10','s27'};{'p14'},{'s16'};{'p15'},{'s02','s10','s13'};};
% FINAL NONCOCAINE: 
PS_LIST={ {'p01'},{'s02','s03','s17','s19','s23'};{'p03'},{'s02','s03','s04','s08','s11'};
    {'p06'},{'s07','s11','s12','s14','s30'};{'p09'},{'s01','s03','s07','s08'};
    {'p12'},{'s01','s03','s11','s12','s23'};{'p14'},{'s02','s03','s04','s05','s06','s22'};{'p15'},{'s01'};};

count=0;
pno=size(PS_LIST,1);
%fid=fopen('temp.txt','w');
for p=1:pno
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
%        main_formatteddata(G,pid,sid,'formattedraw','formatteddata');
%        main_basicfeature(G,pid,sid,'formatteddata','basicfeature');
%        main_window(G,pid, sid,'basicfeature','window',G.MODEL.ACT10SLIDE);
%        main_feature(G,pid, sid,'window','feature',G.MODEL.ACT10SLIDE);
%        return;
%        continue;
%        calculate_avg_macd(G,pid,sid,'preprocess',G.MODEL.ACT10SLIDE,600,60,M,L,R);
        mark_window(G,pid,sid);
 %       screen_window(G,pid,sid);
%        
%pid='p12';sid='s10';
        plot_activation_recovery(G,pid,sid,600,600,2);
        continue;
        indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
        load([indir G.DIR.SEP infile]);
        m=5;
        v2=P.rr.window.v2(m);
        p2=P.rr.window.p2(m);
        sample=P.rr.avg.t600(v2:p2);
        time=P.rr.avg.matlabtime(v2:p2);
        hold on;plot_signal(time,sample,'k-',2);
        load('N.mat');
        now=length(C);
        N{now+1}.sample=sample;
        N{now+1}.time=time;
        N{now+1}.pid=pid;N{now+1}.sid=sid;
        save('N.mat','N');
        
        continue;
%        plot_macd_start_end(G,pid,sid,'preprocess',600,1);
        
%        G.AVG=1;G.MED=2;G.P95=3;
%        figure;plot_basicfeature(G,pid,sid,'basicfeature',[G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID]);
%        plot_pdamark(G,pid,sid,'formattedraw');
%        plot_ecg_rr(G,pid,sid);
%        preprocess_rr(G,pid,sid,'basicfeature','preprocess');
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