function iplot4_monowar_pv_puff_bar_filter_updown_mark(G, pid,sid,episode,INDIR, slist,barvalue)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
hh=figure('units','normalized','outerposition',[0 0 1 1]);
title(['pid=' pid ' sid=' sid ' episode=' num2str(episode)]);
xlabel('Time');ylabel('Magnitude');
P.smoking_episode{episode}.starttimestamp
stime=P.smoking_episode{episode}.starttimestamp-30*1000;
etime=P.smoking_episode{episode}.endtimestamp+30*1000;
plot_sensor(G,P,episode,slist,barvalue,stime,etime);
plot_datalabel(G,P,episode);
end
function plot_datalabel(G,P,episode)
plot_signal([P.smoking_episode{episode}.startmatlabtime,P.smoking_episode{episode}.startmatlabtime],ylim,'k-',2);
text(P.smoking_episode{episode}.startmatlabtime, 0  , ['Smoking ' num2str(episode) '   : Start'], 'Color', 'k','FontSize',18,'Rotation',90);
plot_signal([P.smoking_episode{episode}.endmatlabtime,P.smoking_episode{episode}.endmatlabtime],ylim,'k-',2);
text(P.smoking_episode{episode}.endmatlabtime, 0  , ['Smoking ' num2str(episode) '   : end'], 'Color', 'k','FontSize',18,'Rotation',90);

for i=1:length(P.smoking_episode{episode}.puff.matlabtime)
    plot_signal([P.smoking_episode{episode}.puff.matlabtime(i),P.smoking_episode{episode}.puff.matlabtime(i)],ylim,'k:',2);
    text(P.smoking_episode{episode}.puff.matlabtime(i), 0  , ['Puff ' num2str(i)], 'Color', 'k','FontSize',18,'Rotation',90);
    
end
end

function plot_sensor(G,P,episode,slist,barvalue,stime,etime)
yMax=0;
for s=slist,    yMax=yMax+max(P.sensor{s}.sample)+abs(min(P.sensor{s}.sample));end
offset=yMax;
for s=slist
    hold on;
    offset=offset-max(P.sensor{s}.sample)-abs(min(P.sensor{s}.sample));
    if isempty(P.sensor{s}.matlabtime), continue;  end
    ind=find(P.sensor{s}.timestamp>=stime & P.sensor{s}.timestamp<=etime);
    if s==G.SENSOR.R_RIPID,
        plot_signal(P.sensor{s}.matlabtime(ind),P.sensor{s}.sample(ind),'g-',1,offset-4000);        
        for v=1:length(P.smoking_episode{episode}.puff.ind_R_V)
            ind=P.smoking_episode{episode}.puff.ind_R_V(v);
            if ind==-1, continue;end;
            plot_signal(P.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime(ind),P.sensor{G.SENSOR.R_RIPID}.peakvalley.sample(ind),'ro',5,offset-4000);
            plot_signal(P.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime(ind+1),P.sensor{G.SENSOR.R_RIPID}.peakvalley.sample(ind+1),'bo',5,offset-4000);
            plot_signal(P.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime(ind+2),P.sensor{G.SENSOR.R_RIPID}.peakvalley.sample(ind+2),'ro',5,offset-4000);
        end
    elseif s==G.SENSOR.WL9_ACLYID
        plot_signal(P.sensor{s}.matlabtime(ind),P.sensor{s}.sample(ind),'c-',1,offset);
        plot_signal(P.sensor{s}.matlabtime(ind),P.sensor{s}.sample_filtered(ind),'r-',1,offset);        
        xx=xlim;
        plot_signal(xx,[barvalue,barvalue],'k--',2,offset);
        plot_signal(xx,[-barvalue,-barvalue],'k--',2,offset);
        plot_signal(xx,[0,0],'k-',2,offset);
        for v=1:length(P.smoking_episode{episode}.puff.sind_WL)
            if P.smoking_episode{episode}.puff.sind_WL(v)==-1, continue;end;
            sind=P.smoking_episode{episode}.puff.sind_WL(v);            eind=P.smoking_episode{episode}.puff.eind_WL(v);
            plot_signal(P.sensor{s}.matlabtime(sind),P.sensor{s}.sample(sind),'go',5,offset);
            plot_signal(P.sensor{s}.matlabtime(eind),P.sensor{s}.sample(eind),'co',5,offset);
        end
    else
        plot_signal(P.sensor{s}.matlabtime(ind),P.sensor{s}.sample(ind),'b-',1,offset);
        plot_signal(P.sensor{s}.matlabtime(ind),P.sensor{s}.sample_filtered(ind),'r-',1,offset);
        xx=xlim;
        plot_signal(xx,[barvalue,barvalue],'k--',2,offset);
        plot_signal(xx,[-barvalue,-barvalue],'k--',2,offset);
        plot_signal(xx,[0,0],'k-',2,offset);
        for v=1:length(P.smoking_episode{episode}.puff.sind_WR)
            if P.smoking_episode{episode}.puff.sind_WR(v)==-1, continue;end;
            sind=P.smoking_episode{episode}.puff.sind_WR(v);            eind=P.smoking_episode{episode}.puff.eind_WR(v);
            plot_signal(P.sensor{s}.matlabtime(sind),P.sensor{s}.sample(sind),'go',5,offset);
            plot_signal(P.sensor{s}.matlabtime(eind),P.sensor{s}.sample(eind),'co',5,offset);
        end
        
    end
    %{
        for j=1:2:length(P.sensor{s}.segment)
            ind1=P.sensor{s}.segment(j);
            ind2=P.sensor{s}.segment(j+1);
            t1=P.sensor{s}.timestamp(ind1);t2=P.sensor{s}.timestamp(ind2);if t2-t1<1000, continue;end;
            if t1<stime, continue;end; if t2>etime, continue;end;
            now_s=now_s+1;segment(now_s)=ind1;now_s=now_s+1;segment(now_s)=ind2;
            t1=P.sensor{s}.matlabtime(ind1);t2=P.sensor{s}.matlabtime(ind2);
            plot([t1,t2],[barvalue,barvalue]+offset+800,'k-','linewidth',20);

         ind=find(P.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime>=t1 & P.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime<=t2);
         for kk=1:length(ind)
             if mod(ind(kk),2)==1
                 plot_signal(P.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime(ind(kk)),P.sensor{G.SENSOR.R_RIPID}.peakvalley.sample(ind(kk)),'ro',5,RIPOFFSET);
             else
                 plot_signal(P.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime(ind(kk)),P.sensor{G.SENSOR.R_RIPID}.peakvalley.sample(ind(kk)),'bo',5,RIPOFFSET);
             end
         end
           
        end
    %}
end
end

