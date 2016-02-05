close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        %                pid='p03';sid='s03';
        INDIR='segment_gyr';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        for e=1:length(P.smoking_episode)
            if isempty(P.smoking_episode{e}.puff), continue;end;
            %            if isempty(find(P.smoking_episode{e}.puff.acl.valid==0,1)), continue;end;
            for p=1:length(P.smoking_episode{e}.puff.gyr.starttimestamp)
                if P.smoking_episode{e}.puff.gyr.valid(p)~=0, continue;end;
                id=P.smoking_episode{e}.puff.gyr.id;
                stime=P.smoking_episode{e}.puff.gyr.starttimestamp(p)-5000;
                etime=P.smoking_episode{e}.puff.gyr.endtimestamp(p)+5000;
                if id==1, IDS=[G.SENSOR.R_RIPID,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID]; else IDS=[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID];end;
                valid=P.smoking_episode{e}.puff.gyr.valid(p);
                missing=P.smoking_episode{e}.puff.gyr.missing(p);
                h=figure('units','normalized','outerposition',[0 0 1 1]);
                title([pid ' ' sid ' episode=' num2str(e) ' puff=' num2str(p) ' missing=' num2str(P.smoking_episode{e}.puff.gyr.missing(p)) ' valid=' num2str(P.smoking_episode{e}.puff.gyr.valid(p))]);hold on;
                offset=0;color={'-go','-bo','-ro','-go','-bo','-ro','-go'};now=1;
                for ids=IDS
                    [a,b]=binarysearch(P.sensor{ids}.timestamp,stime,etime);
                    ind=a:b;
                    %                    if isempty(ind), continue;end;
                    if ids==1,
                        plot(P.sensor{ids}.timestamp(ind)-stime,P.sensor{ids}.sample_new(ind)+offset,color{now},'markersize',4);
                        [c,d]=binarysearch(P.sensor{ids}.peakvalley_new_3.timestamp,stime,etime);
                        indpv=c:d;
                        plot(P.sensor{ids}.peakvalley_new_3.timestamp(indpv)-stime,P.sensor{ids}.peakvalley_new_3.sample(indpv),'r*','markersize',10);
                    else
                        plot(P.sensor{ids}.timestamp(ind)-stime,P.sensor{ids}.sample(ind)+offset,color{now},'markersize',4);
                        plot(xlim,[-600,-600]+offset,'k:');
                        plot(xlim,[0,0]+offset,'k-');
                        plot(xlim,[600,600]+offset,'k:');
                    end
                    offset=offset+2000;now=now+1;
                end
                ind=find(P.wrist{id}.timestamp>=stime & P.wrist{id}.timestamp<=etime);
                plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude(ind)+offset-1000,'-ko','markersize',4);
                plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude_800(ind)+offset-1000,'-bo','markersize',4);
                plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude_8000(ind)+offset-1000,'-ro','markersize',4);
                
                plot([P.smoking_episode{e}.puff.acl.starttimestamp(p),P.smoking_episode{e}.puff.acl.starttimestamp(p)]-stime,ylim,'k:','linewidth',2);
                plot([P.smoking_episode{e}.puff.acl.endtimestamp(p),P.smoking_episode{e}.puff.acl.endtimestamp(p)]-stime,ylim,'k:','linewidth',2);
                plot([P.smoking_episode{e}.puff.gyr.starttimestamp(p),P.smoking_episode{e}.puff.gyr.starttimestamp(p)]-stime,ylim,'k-','linewidth',2);
                plot([P.smoking_episode{e}.puff.gyr.endtimestamp(p),P.smoking_episode{e}.puff.gyr.endtimestamp(p)]-stime,ylim,'k-','linewidth',2);
                
                %                plot(xlim,[1000,1000],'k-','linewidth',2);
                %                plot(xlim,[1250,1250],'k--','linewidth',2);
                %                plot(xlim,[1500,1500],'k--','linewidth',2);
                plot(xlim,[600,600],'k-','linewidth',2);
                plot([P.smoking_episode{e}.puff.timestamp(p)-stime,P.smoking_episode{e}.puff.timestamp(p)-stime],ylim,'k:');
                x=xlim;
                set(gca,'XTick',0:1000:x(2));
                str=sprintf('%d_%s_%s_%02d_%02d_%02d',valid,pid,sid,e,p,floor(missing*100));
                filename=[G.DIR.DATA G.DIR.SEP 'plot_puff_gyr_groundtruth' G.DIR.SEP str '.png'];
                set(gcf,'PaperUnits','inches','PaperSize',[16,8],'PaperPosition',[0 0 16 8])
                print('-dpng','-r100',filename);
                                saveas(h,[filename '.fig']);
                close(h);
            end
        end
    end
end
disp('abc');
