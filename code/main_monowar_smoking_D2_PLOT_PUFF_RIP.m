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
        INDIR='segment_rip';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        
        for e=1:length(P.smoking_episode)
            if isempty(P.smoking_episode{e}.puff), continue;end;
            %            if isempty(find(P.smoking_episode{e}.puff.acl.valid==0,1)), continue;end;
            for p=1:length(P.smoking_episode{e}.puff.acl.starttimestamp)
                if P.smoking_episode{e}.puff.gyr.valid(p)~=0, continue;end;
                R.pid(end+1)=str2num(pid(2:end));R.sid(end+1)=str2num(sid(2:end));R.episode(end+1)=e;R.puff(end+1)=p;
                R.starttimestamp(end+1)=P.smoking_episode{e}.puff.acl.starttimestamp(p);
                R.endtimestamp(end+1)=P.smoking_episode{e}.puff.acl.endtimestamp(p);
                id=P.smoking_episode{e}.puff.acl.id;
                stime=P.smoking_episode{e}.puff.acl.starttimestamp(p)-30000;
                etime=P.smoking_episode{e}.puff.acl.endtimestamp(p)+30000;
                if id==1, IDS=[G.SENSOR.R_RIPID,G.SENSOR.WL9_ACLYID]; else IDS=[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID];end;
                if isfield(P.smoking_episode{e}.puff.gyr,'valid_rip')==0, valid=0;
                else, valid=P.smoking_episode{e}.puff.gyr.valid_rip(p);
                end
                if valid~=0, continue;end;
                missing=P.smoking_episode{e}.puff.acl.missing(p);
                h=figure('units','normalized','outerposition',[0 0 1 1]);
                title([pid ' ' sid ' episode=' num2str(e) ' puff=' num2str(p) ' missing=' num2str(P.smoking_episode{e}.puff.acl.missing(p)) ' valid=' num2str(P.smoking_episode{e}.puff.acl.valid(p))]);hold on;
                offset=0;color={'-go','-bo','-ro','-go','-bo'};now=1;
                for ids=IDS
                    if ids==1,
                        [a,b]=binarysearch(P.sensor{ids}.timestamp,stime,etime);
                        ind=a:b;
                        %                        ind=find(P.sensor{ids}.timestamp>=stime & P.sensor{ids}.timestamp<=etime);
                        %                    if isempty(ind), continue;end;
                        plot(P.sensor{ids}.timestamp(ind)-stime,P.sensor{ids}.sample_new(ind)+offset,color{now},'markersize',4);
                        plot(xlim,[offset,offset],'k-');
                        plot(xlim,[offset,offset]+100,'k:');
                        plot(xlim,[offset,offset]-100,'k:');
                        
                        %                        xx=find(P.sensor{1}.peakvalley_new_3.timestamp>=stime & P.sensor{1}.peakvalley_new_3.timestamp<=etime);
                        %                        plot(P.sensor{1}.peakvalley_new_3.timestamp(xx)-stime,P.sensor{1}.peakvalley_new_3.sample(xx)+offset,'r.','markersize',20);
                        xx=find(P.sensor{1}.peakvalley_new_3.timestamp>=stime & P.sensor{1}.peakvalley_new_3.timestamp<=etime);
                        plot(P.sensor{1}.peakvalley_new_3.timestamp(xx)-stime,P.sensor{1}.peakvalley_new_3.sample(xx)+offset,'ro','markersize',8);
                        
                        peak_ind=P.smoking_episode{e}.puff.gyr.peak_ind(p);
                        if peak_ind>0,
                            plot(P.sensor{ids}.peakvalley_new_3.timestamp(peak_ind-3)-stime,P.sensor{ids}.peakvalley_new_3.sample(peak_ind-3)+offset,'cs','MarkerFaceColor','c');
                            plot(P.sensor{ids}.peakvalley_new_3.timestamp(peak_ind-2)-stime,P.sensor{ids}.peakvalley_new_3.sample(peak_ind-2)+offset,'cs','MarkerFaceColor','c');
                            plot(P.sensor{ids}.peakvalley_new_3.timestamp(peak_ind-1)-stime,P.sensor{ids}.peakvalley_new_3.sample(peak_ind-1)+offset,'ks','MarkerFaceColor','k');
                            plot(P.sensor{ids}.peakvalley_new_3.timestamp(peak_ind)-stime,P.sensor{ids}.peakvalley_new_3.sample(peak_ind)+offset,'rs','Markerfacecolor','r');
                            plot(P.sensor{ids}.peakvalley_new_3.timestamp(peak_ind+1)-stime,P.sensor{ids}.peakvalley_new_3.sample(peak_ind+1)+offset,'ks','Markerfacecolor','k');
                            plot(P.sensor{ids}.peakvalley_new_3.timestamp(peak_ind+2)-stime,P.sensor{ids}.peakvalley_new_3.sample(peak_ind+2)+offset,'cs','MarkerFaceColor','c');
                            plot(P.sensor{ids}.peakvalley_new_3.timestamp(peak_ind+3)-stime,P.sensor{ids}.peakvalley_new_3.sample(peak_ind+3)+offset,'cs','MarkerFaceColor','c');
                        end
                        now=now+1;
                        [a,b]=binarysearch(P.sensor{ids}.timestamp,stime,etime);
                        ind=a:b;
                        %                        ind=find(P.sensor{ids}.timestamp>=stime & P.sensor{ids}.timestamp<=etime);
                        %                    if isempty(ind), continue;end;
                        plot(P.sensor{ids}.timestamp(ind)-stime,P.sensor{ids}.sample(ind)+offset,color{now},'markersize',4);
                        plot(xlim,[offset,offset],'k-');
                        
                        xx=find(P.sensor{1}.peakvalley_1.timestamp>=stime & P.sensor{1}.peakvalley_1.timestamp<=etime);
                        plot(P.sensor{1}.peakvalley_1.timestamp(xx)-stime,P.sensor{1}.peakvalley_1.sample(xx)+offset,'r.','markersize',20);
                        
                        %                        xx=find(P.sensor{1}.peakvalley_2.timestamp>=stime & P.sensor{1}.peakvalley_2.timestamp<=etime);
                        %                        plot(P.sensor{1}.peakvalley_2.timestamp(xx)-stime,P.sensor{1}.peakvalley_2.sample(xx)+offset,'ro','markersize',8);
                        
                    else
                        ind=find(P.sensor{ids}.timestamp>=stime & P.sensor{ids}.timestamp<=etime);
                        %                    if isempty(ind), continue;end;
                        plot(P.sensor{ids}.timestamp(ind)-stime,P.sensor{ids}.sample(ind)+offset,color{now},'markersize',4);
                        plot(xlim,[-600,-600]+offset,'k:');
                        plot(xlim,[0,0]+offset,'k-');
                        plot(xlim,[600,600]+offset,'k:');
                    end
                    offset=offset+5000;now=now+1;
                    
                end
                ind=find(P.wrist{id}.timestamp>=stime & P.wrist{id}.timestamp<=etime);
                plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude(ind)+offset-1000,'-ko','markersize',2);
                plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude_800(ind)+offset-1000,'-bo','markersize',2);
                plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude_8000(ind)+offset-1000,'-ro','markersize',2);
                
                plot([P.smoking_episode{e}.puff.gyr.starttimestamp(p),P.smoking_episode{e}.puff.gyr.starttimestamp(p)]-stime,ylim,'k-','linewidth',2);
                plot([P.smoking_episode{e}.puff.gyr.endtimestamp(p),P.smoking_episode{e}.puff.gyr.endtimestamp(p)]-stime,ylim,'k-','linewidth',2);
                %                plot(xlim,[1000,1000],'k-','linewidth',2);
                %                plot(xlim,[1250,1250],'k--','linewidth',2);
                %                plot(xlim,[1500,1500],'k--','linewidth',2);
                plot(xlim,[600,600],'k-','linewidth',2);
                %                plot([P.smoking_episode{e}.puff.timestamp(p)-stime,P.smoking_episode{e}.puff.timestamp(p)-stime],ylim,'k:');
                %                ylim([-1500, 3500]);
                %               if id==1, IDS=[G.SENSOR.WL9_GYRXID:G.SENSOR.WL9_GYRZID]; else IDS=[G.SENSOR.WR9_GYRXID:G.SENSOR.WR9_GYRZID];end
                %                ind=find(P.sensor{IDS(1)}.timestamp>=stime & P.sensor{IDS(1)}.timestamp<=etime);
                %                plot(P.sensor{IDS(1)}.timestamp(ind)-stime,P.sensor{IDS(1)}.sample(ind)+3500,'-bo');
                %                ind=find(P.sensor{IDS(2)}.timestamp>=stime & P.sensor{IDS(2)}.timestamp<=etime);
                %                plot(P.sensor{IDS(2)}.timestamp(ind)-stime,P.sensor{IDS(2)}.sample(ind)+3500,'-mo');
                %                ind=find(P.sensor{IDS(3)}.timestamp>=stime & P.sensor{IDS(3)}.timestamp<=etime);
                %                plot(P.sensor{IDS(3)}.timestamp(ind)-stime,P.sensor{IDS(3)}.sample(ind)+3500,'-co');
                x=xlim;
                %                label=cellstr(strcat(num2str((0:10:(x(2)/1000))','%d')))';
                %                set(gca,'XTickLabel',label);
                str=sprintf('%d_%s_%s_%02d_%02d_%02d',valid,pid,sid,e,p,floor(missing*100));
                filename=[G.DIR.DATA G.DIR.SEP 'plot_puff_rip_groundtruth1' G.DIR.SEP str '.png'];
                set(gcf,'PaperUnits','inches','PaperSize',[16,8],'PaperPosition',[0 0 16 8])
                print('-dpng','-r100',filename);
                %                saveas(h,[filename '.fig']);
                close(h);
            end
        end
    end
end
disp('abc');
