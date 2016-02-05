close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);

FFF=get_good_quality_data_map('quality data');

PS_LIST=G.PS_LIST;
R.pid=[];R.sid=[];R.episode=[];R.puff=[];R.starttimestamp=[];R.endtimestamp=[];
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        %pid='p03';sid='s03';
        
        INDIR='preprocess_wrist';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        for e=1:length(P.smoking_episode)
            if isempty(P.smoking_episode{e}.puff), continue;end;
            %            if isempty(find(P.smoking_episode{e}.puff.acl.valid==0,1)), continue;end;
            for p=1:length(P.smoking_episode{e}.puff.timestamp)
                ppid = [pid(2) pid(3)];
                p_id = str2num(ppid);
                ssid = [sid(2) sid(3)];
                s_id = str2num(ssid);

                AA = FFF{p_id, s_id, e, p};
                if isempty(AA)
                    continue;
                end
               
                    stime=P.smoking_episode{e}.puff.timestamp(p)-10000;
                    etime=P.smoking_episode{e}.puff.timestamp(p)+10000;
                    %IDS=[G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID];
                  
                    IDS=[G.SENSOR.WL9_ACLYID, G.SENSOR.WR9_ACLYID];
                    IDS=[G.SENSOR.R_RIPID, IDS];
                    h=figure('units','normalized','outerposition',[0 0 1 1]);
                    title([pid ' ' sid ' episode=' num2str(e) ' puff=' num2str(p)]);hold on;
                    offset=0;color={'g.','b.','r.','g.','b.','r.','g.','b.','r.'};now=1;
                    for ids=IDS
                        [a,b]=binarysearch(P.sensor{ids}.timestamp,stime,etime);
                        ind=a:b;
                        %                    if isempty(ind), continue;end;
                        if ids==1,
                            plot(P.sensor{ids}.timestamp(ind)-stime,P.sensor{ids}.sample_new(ind)+offset,color{now});
                            [c,d]=binarysearch(P.sensor{ids}.peakvalley_new_3.timestamp,stime,etime);
                            indpv=c:d;
                            plot(P.sensor{ids}.peakvalley_new_3.timestamp(indpv)-stime,P.sensor{ids}.peakvalley_new_3.sample(indpv)+offset,'r*','markersize',10);
                            
                        else
                            plot(P.sensor{ids}.timestamp(ind)-stime,P.sensor{ids}.sample(ind)+offset,color{now});
                            plot(xlim,[-600,-600]+offset,'k:');
                            plot(xlim,[0,0]+offset,'k-');
                            plot(xlim,[600,600]+offset,'k:');
                        end
                        offset=offset+2000;now=now+1;
                    end
                     for id=1:2
                        ind=find(P.wrist{id}.timestamp>=stime & P.wrist{id}.timestamp<=etime);
                        plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude(ind)+offset-1000,'-ko','markersize',4);
    %                     plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitudeXZ(ind)+offset-1000,'-go','markersize',2);
                        plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude_peaks(ind)+offset,'-r*','markersize',2);

    %                     plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude_800(ind)+offset-1000,'-bo','markersize',4);
                        plot(P.wrist{id}.timestamp(ind)-stime, P.wrist{id}.magnitude_8000(ind)+offset-1000,'-ro','markersize',4);
                        offset = offset+2000;
                     end
                    plot(xlim,[600,600],'k-','linewidth',2);
                    plot([P.smoking_episode{e}.puff.timestamp(p)-stime,P.smoking_episode{e}.puff.timestamp(p)-stime],ylim,'k-','linewidth',3);
                    x=xlim;
                    set(gca,'XTick',0:1000:x(2));
                    str=sprintf('0_%d_%s_%s_%02d_%02d_%02d',id,pid,sid,e,p);
                    filename=[G.DIR.DATA G.DIR.SEP 'plot_puff_R_A_G_M_nazir' G.DIR.SEP str '.png'];
                    set(gcf,'PaperUnits','inches','PaperSize',[16,8],'PaperPosition',[0 0 16 8])
                    print('-dpng','-r100',filename);
                    %                saveas(h,[filename '.fig']);
                    close(h);
                            
            end
        end
    end
end
disp('abc');
