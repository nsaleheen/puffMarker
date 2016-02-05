close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
R.pid=[];R.sid=[];R.episode=[];R.puff=[];R.starttimestamp=[];R.endtimestamp=[];
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        %                pid='p03';sid='s03';
        
        INDIR='segment_rip';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
%        peak=peakfinder(P.sensor{1}.sample,[],[],1);        valley=peakfinder(P.sensor{1}.sample,[],[],-1);
%         a(2:2:2*length(peak))=peak;        a(1:2:2*length(valley)-1)=valley;peak=a;
%         P.sensor{1}.peakvalley_3.sample=P.sensor{1}.sample(peak);
%         P.sensor{1}.peakvalley_3.timestamp=P.sensor{1}.timestamp(peak);
%         P.sensor{1}.peakvalley_3.matlabtime=P.sensor{1}.timestamp(peak);
        x0=P.sensor{1}.sample_new;
        mn=prctile(P.sensor{1}.sample_new,5);
        mx=prctile(P.sensor{1}.sample_new,95);

        sel=(mx-mn)/3
        peak=peakfinder(P.sensor{1}.sample_new,sel,[],1);
        valley=peakfinder(P.sensor{1}.sample_new,sel,[],-1);
        a=[];
        a(2:2:2*length(peak))=peak;
        a(1:2:2*length(valley)-1)=valley;
        peak=a;
        length(peak)
        P.sensor{1}.peakvalley_new_3.sample=P.sensor{1}.sample_new(peak);
        P.sensor{1}.peakvalley_new_3.timestamp=P.sensor{1}.timestamp_new(peak);
        P.sensor{1}.peakvalley_new_3.matlabtime=P.sensor{1}.timestamp_new(peak);
        x=sort(P.sensor{1}.peakvalley_new_3.timestamp(4:2:end)-P.sensor{1}.peakvalley_new_3.timestamp(2:2:end-2));
        length(find(x<1000))
        
%         figure;hold on;
%         plot(P.sensor{1}.timestamp,P.sensor{1}.sample_new,'g-');
%         plot(P.sensor{1}.peakvalley_new_1.timestamp,P.sensor{1}.peakvalley_new_1.sample,'r.','MarkerSize',20);
%         plot(P.sensor{1}.peakvalley_new_3.timestamp,P.sensor{1}.peakvalley_new_3.sample,'bo','MarkerSize',8);
%         
%         continue;
%         
        for e=1:length(P.smoking_episode)
            if isempty(P.smoking_episode{e}.puff), continue;end;
            for p=1:length(P.smoking_episode{e}.puff.acl.starttimestamp)
                stime=P.smoking_episode{e}.puff.acl.starttimestamp(p)-30000;
                etime=P.smoking_episode{e}.puff.acl.endtimestamp(p)+30000;
                h=figure('units','normalized','outerposition',[0 0 1 1]);
                title([pid ' ' sid ' episode=' num2str(e) ' puff=' num2str(p) ' missing=' num2str(P.smoking_episode{e}.puff.acl.missing(p)) ' valid=' num2str(P.smoking_episode{e}.puff.acl.valid(p))]);hold on;
                offset=0;color={'-go','-bo','-ro','-go','-bo'};now=1;
                ids=1;
                [a,b]=binarysearch(P.sensor{ids}.timestamp,stime,etime);
                ind=a:b;
                %                        ind=find(P.sensor{ids}.timestamp>=stime & P.sensor{ids}.timestamp<=etime);
                %                    if isempty(ind), continue;end;
                plot(P.sensor{ids}.timestamp(ind)-stime,P.sensor{ids}.sample_new(ind)+offset,color{now},'markersize',4);
                xx=find(P.sensor{1}.peakvalley_new_1.timestamp>=stime & P.sensor{1}.peakvalley_new_1.timestamp<=etime);
                plot(P.sensor{1}.peakvalley_new_1.timestamp(xx)-stime,P.sensor{1}.peakvalley_new_1.sample(xx)+offset,'r.','markersize',20);
                
  %              xx=find(P.sensor{1}.peakvalley_new_2.timestamp>=stime & P.sensor{1}.peakvalley_new_2.timestamp<=etime);
  %              plot(P.sensor{1}.peakvalley_new_2.timestamp(xx)-stime,P.sensor{1}.peakvalley_new_2.sample(xx)+offset,'ro','markersize',8);
                xx=find(P.sensor{1}.peakvalley_new_3.timestamp>=stime & P.sensor{1}.peakvalley_new_3.timestamp<=etime);
                plot(P.sensor{1}.peakvalley_new_3.timestamp(xx)-stime,P.sensor{1}.peakvalley_new_3.sample(xx)+offset,'ko','markersize',8);
                
                peak_ind_all=peakfinder(P.sensor{1}.sample,[],1);
                
                offset=offset+2000;now=now+1;
                [a,b]=binarysearch(P.sensor{ids}.timestamp,stime,etime);
                ind=a:b;
                %                        ind=find(P.sensor{ids}.timestamp>=stime & P.sensor{ids}.timestamp<=etime);
                %                    if isempty(ind), continue;end;
                plot(P.sensor{ids}.timestamp(ind)-stime,P.sensor{ids}.sample(ind)+offset,color{now},'markersize',4);
                xx=find(P.sensor{1}.peakvalley_1.timestamp>=stime & P.sensor{1}.peakvalley_1.timestamp<=etime);
                plot(P.sensor{1}.peakvalley_1.timestamp(xx)-stime,P.sensor{1}.peakvalley_1.sample(xx)+offset,'r.','markersize',20);
                xx=find(P.sensor{1}.peakvalley_2.timestamp>=stime & P.sensor{1}.peakvalley_2.timestamp<=etime);
                plot(P.sensor{1}.peakvalley_2.timestamp(xx)-stime,P.sensor{1}.peakvalley_2.sample(xx)+offset,'ro','markersize',8);

%                 xx=find(P.sensor{1}.peakvalley_3.timestamp>=stime & P.sensor{1}.peakvalley_3.timestamp<=etime);
%                 plot(P.sensor{1}.peakvalley_3.timestamp(xx)-stime,P.sensor{1}.peakvalley_3.sample(xx)+offset,'ko','markersize',8);
                
                offset=offset+3000;now=now+1;
                
            end
            
            %                 x=xlim;
            %                 label=cellstr(strcat(num2str((0:10:(x(2)/1000))','%d')))';
            %                 set(gca,'XTickLabel',label);
            %                 str=sprintf('%d_%s_%s_%02d_%02d_%02d',valid,pid,sid,e,p,floor(missing*100));
            %                 filename=[G.DIR.DATA G.DIR.SEP 'plot_puff_rip' G.DIR.SEP str '.png'];
            %                 set(gcf,'PaperUnits','inches','PaperSize',[16,8],'PaperPosition',[0 0 16 8])
            %                 print('-dpng','-r100',filename);
            %                saveas(h,[filename '.fig']);
            close(h);
        end
    end
end
disp('abc');
