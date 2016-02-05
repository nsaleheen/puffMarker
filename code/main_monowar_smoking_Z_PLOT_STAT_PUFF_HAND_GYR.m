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
        
        INDIR='segment_gyr';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        %        sample{1}=smooth(P.wrist{1}.magnitude.sample,16);sample{1}=medfilt1(sample{1},8);
        %        sample{2}=smooth(P.wrist{2}.magnitude.sample,16);sample{2}=medfilt1(sample{2},8);
%        sample{1}=medfilt1(P.wrist{1}.gyr.magnitude.sample,9);
        sample{1}=P.wrist{1}.magnitude;
        sample_800{1}=P.wrist{1}.magnitude_800;
        sample_8000{1}=P.wrist{1}.magnitude_8000;
%        sample{2}=medfilt1(P.wrist{2}.gyr.magnitude.sample,9);
        sample{2}=P.wrist{2}.magnitude;
        sample_800{2}=P.wrist{2}.magnitude_800;
        sample_8000{2}=P.wrist{2}.magnitude_8000;
        
        for e=1:length(P.smoking_episode)
            if isempty(P.smoking_episode{e}.puff), continue;end;
            %            if isempty(find(P.smoking_episode{e}.puff.acl.valid==0,1)), continue;end;
            for p=1:length(P.smoking_episode{e}.puff.acl.starttimestamp)
%                if P.smoking_episode{e}.puff.gyr.valid(p)~=0, continue;end;
%                if P.smoking_episode{e}.puff.gyr.missing(p)>0.33, continue;end;
                R.pid(end+1)=str2num(pid(2:end));R.sid(end+1)=str2num(sid(2:end));R.episode(end+1)=e;R.puff(end+1)=p;
                R.starttimestamp(end+1)=P.smoking_episode{e}.puff.gyr.starttimestamp(p);
                R.endtimestamp(end+1)=P.smoking_episode{e}.puff.gyr.endtimestamp(p);
                id=P.smoking_episode{e}.puff.acl.id;
                stime=P.smoking_episode{e}.puff.acl.starttimestamp(p)-5000;
                etime=P.smoking_episode{e}.puff.acl.endtimestamp(p)+5000;
                
                ind=find(P.wrist{id}.acl.timestamp>=stime & P.wrist{id}.acl.timestamp<=etime);
                if isempty(ind), continue;end;
                h=figure;title([pid ' ' sid ' episode=' num2str(e) ' puff=' num2str(p) ' missing=' num2str(P.smoking_episode{e}.puff.acl.missing(p))]);hold on;
                plot(P.wrist{id}.acl.timestamp(ind)-stime,P.wrist{id}.acl.sample(ind),'-go','markersize',4);
                ind=find(P.wrist{id}.gyr.magnitude.timestamp>=stime & P.wrist{id}.gyr.magnitude.timestamp<=etime);
                plot(P.wrist{id}.gyr.magnitude.timestamp(ind)-stime,P.wrist{id}.gyr.magnitude.sample(ind)+1000,'-bo','markersize',4);
                plot(P.wrist{id}.gyr.magnitude.timestamp(ind)-stime,sample_800{id}(ind)+1000,'-ro','markersize',4);
                plot(P.wrist{id}.gyr.magnitude.timestamp(ind)-stime,sample_8000{id}(ind)+1000,'-mo','markersize',4);
                
                sstime=P.smoking_episode{e}.puff.gyr.starttimestamp(p);
                setime=P.smoking_episode{e}.puff.gyr.endtimestamp(p);
                
                ind1=find(P.wrist{id}.gyr.magnitude.timestamp>=sstime & P.wrist{id}.gyr.magnitude.timestamp<=setime);
                plot(P.wrist{id}.gyr.magnitude.timestamp(ind1)-stime,sample_800{id}(ind1)+1000,'-ko','markersize',4, 'MarkerFaceColor','k');
                
                plot([P.smoking_episode{e}.puff.acl.starttimestamp(p),P.smoking_episode{e}.puff.acl.starttimestamp(p)]-stime,ylim,'k-','linewidth',2);
                plot([P.smoking_episode{e}.puff.acl.endtimestamp(p),P.smoking_episode{e}.puff.acl.endtimestamp(p)]-stime,ylim,'k-','linewidth',2);
                plot(xlim,[1000,1000],'k-','linewidth',2);
                plot(xlim,[1250,1250],'k--','linewidth',2);
                plot(xlim,[1500,1500],'k--','linewidth',2);
                plot(xlim,[600,600],'k-','linewidth',2);
%                plot([P.smoking_episode{e}.puff.timestamp(p)-stime,P.smoking_episode{e}.puff.timestamp(p)-stime],ylim,'k-');
                %                ylim([-1500, 3500]);
 %               if id==1, IDS=[G.SENSOR.WL9_GYRXID:G.SENSOR.WL9_GYRZID]; else IDS=[G.SENSOR.WR9_GYRXID:G.SENSOR.WR9_GYRZID];end
                %                ind=find(P.sensor{IDS(1)}.timestamp>=stime & P.sensor{IDS(1)}.timestamp<=etime);
                %                plot(P.sensor{IDS(1)}.timestamp(ind)-stime,P.sensor{IDS(1)}.sample(ind)+3500,'-bo');
                %                ind=find(P.sensor{IDS(2)}.timestamp>=stime & P.sensor{IDS(2)}.timestamp<=etime);
                %                plot(P.sensor{IDS(2)}.timestamp(ind)-stime,P.sensor{IDS(2)}.sample(ind)+3500,'-mo');
                %                ind=find(P.sensor{IDS(3)}.timestamp>=stime & P.sensor{IDS(3)}.timestamp<=etime);
                %                plot(P.sensor{IDS(3)}.timestamp(ind)-stime,P.sensor{IDS(3)}.sample(ind)+3500,'-co');
                
                filename=[G.DIR.DATA G.DIR.SEP 'plot_puff_acl_groundtruth' G.DIR.SEP pid '_' sid '_' num2str(e) '_' num2str(p) '.png'];
                set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10])
                print('-dpng','-r100',filename);
%                saveas(h,[filename '.fig']);
                close(h);
            end
        end
    end
end
disp('abc');
