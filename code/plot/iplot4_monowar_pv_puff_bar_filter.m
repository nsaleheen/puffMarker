function iplot4_monowar_pv_puff_bar_filter(G, pid,sid, INDIR, slist, plotCress,barvalue)
shiftCress=0;
%color={'r-','g-','b-','y-','m-','c-','w-', 'k-',   'r-','g-','b-','y-','m-','c-','w-', 'k-'};
%color={'r.','g.','b.','m.','c.', 'k.',   'r.','g.','b.','m.','c.', 'k.'};

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
B=P;

%figure;
hh=figure('units','normalized','outerposition',[0 0 1 1]);
title(['pid=' pid ' sid=' sid]);
xlabel('Time');
ylabel('Magnitude');
yMax=0;
for s=slist
    yMax=yMax+max(B.sensor{s}.sample)+abs(min(B.sensor{s}.sample));
end

if plotCress==1, plot_cress(G,B,yMax);end;
plot_sensor(G,B,slist,barvalue);
plot_selfreport(G,B);
plot_datalabel(G,B);
%	legend(h,legend_text,'Interpreter', 'none');

%save_figure(G,B,pid,sid);
end
function save_figure(G,B,pid,sid)
filename=[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.png'];
set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10])
print('-dpng','-r100',filename);

%saveas(hh,filename,'png');
%print (gcf, '-dbmp', filename)
if isfield(B,'selfreport')==1
    list_selfreport=[G.SELFREPORT.SMKID];
    for s=list_selfreport
        hold on;
        for i=1:length(B.selfreport{s}.matlabtime)
            stime=B.selfreport{s}.matlabtime(i)-(10/(24*60));
            etime=B.selfreport{s}.matlabtime(i)+(1/(24*60));
            xlim([stime,etime]);
            filename=[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '_s' num2str(i) '.png'];
            set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10])
            print('-dpng','-r100',filename);
            %        print (gcf, '-dbmp', filename)
            %    saveas(hh,filename,'png');
        end
    end
end
count=0;
if isfield(B,'datalabel')==1
        for i=1:length(B.datalabel)
            if isempty(strfind(B.datalabel(i).label,'Smoking')), continue;end;
            count=count+1;
            stime=B.datalabel(i).startmatlabtime-(1/(24*60));
            etime=B.datalabel(i).endmatlabtime+(1/(24*60));
            xlim([stime,etime]);
            filename=[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '_s' num2str(count) '.png'];
            set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10])
            print('-dpng','-r100',filename);
            %        print (gcf, '-dbmp', filename)
            %    saveas(hh,filename,'png');
        end
end





end

function plot_datalabel(G,B)
if isfield(B,'datalabel')~=1, return;end;
count=0;
for i=1:length(B.datalabel)
    hold on;
    plot_signal([B.datalabel(i).startmatlabtime,B.datalabel(i).startmatlabtime],ylim,'r-',2);
    hold on;
    if ~isempty(strfind(B.datalabel(i).label,'Smoking'))
        count=count+1;
        text(B.datalabel(i).startmatlabtime, 0  , [B.datalabel(i).label ' : ' num2str(count)], 'Color', 'k','FontSize',18,'Rotation',90);    
    else
        text(B.datalabel(i).startmatlabtime, 0  , [B.datalabel(i).label ' : Start'], 'Color', 'k','FontSize',18,'Rotation',90);            
    end
    if B.datalabel(i).startmatlabtime~=B.datalabel(i).endmatlabtime,
        plot_signal([B.datalabel(i).endmatlabtime,B.datalabel(i).endmatlabtime],ylim,'m-',2);
    if ~isempty(strfind(B.datalabel(i).label,'Smoking'))
        text(B.datalabel(i).endmatlabtime, 0  , [B.datalabel(i).label ' : ' num2str(count)], 'Color', 'k','FontSize',18,'Rotation',90);    
    else
        text(B.datalabel(i).endmatlabtime, 0  , [B.datalabel(i).label ' : End'], 'Color', 'k','FontSize',18,'Rotation',90);            
    end
    end
end

end

function plot_sensor(G,B,slist,barvalue)
color={'g-','b-','c-','g-','b-','c-'};

yMax=0;
for s=slist
    yMax=yMax+max(B.sensor{s}.sample)+abs(min(B.sensor{s}.sample));
end
offset=yMax;
i=0;
for s=slist
    hold on;
    offset=offset-max(B.sensor{s}.sample)-abs(min(B.sensor{s}.sample));
    if isempty(B.sensor{s}.matlabtime)
        continue;
    end
    h(i+1)=plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sample,color{rem(i,length(color))+1},1,offset);
    if isfield(B.sensor{s},'sample_filtered')
        plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sample_filtered,'r-',1,offset);
    end
    if isfield(B.sensor{s},'variance')
        plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.variance,'k-',1,offset);
    end
    if s==G.SENSOR.R_RIPID, RIPOFFSET=offset;end;
    %    B.sensor{s}.sample=exponential_movingavg(B.sensor{s}.sample,100);
    res=[];
    tm=[];
    if s~=1
        xx=xlim;
        plot_signal(xx,[barvalue,barvalue],'k--',2,offset);
        plot_signal(xx,[-barvalue,-barvalue],'k--',2,offset);
        plot_signal(xx,[0,0],'k-',2,offset);
        
        for j=1:2:length(B.sensor{s}.segment)
            ind1=B.sensor{s}.segment(j);
            ind2=B.sensor{s}.segment(j+1);
            t1=B.sensor{s}.timestamp(ind1);t2=B.sensor{s}.timestamp(ind2);if t2-t1<800, continue;end;
            t1=B.sensor{s}.matlabtime(ind1);t2=B.sensor{s}.matlabtime(ind2);
            plot([t1,t2],[barvalue,barvalue]+offset+800,'k-','linewidth',20);
%            ind=find(B.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime>=t1 & B.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime<=t2);
%            for kk=1:length(ind)
%                plot_signal(B.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime(ind(kk)),B.sensor{G.SENSOR.R_RIPID}.peakvalley.sample(ind(kk)),'ro',5,RIPOFFSET);
%            end
            %            plot_signal([t1,t2],[barvalue,barvalue],'r-',5,offset);
            %            hUPSession(i) = area([t1,t2], [yMax, yMax]);
            %            hold off;
            %                hc=get(hUPSession(i),'children');
            %                set(hc,'FaceColor',[1 1 .63], 'EdgeColor', [1 1 .33]);
            %set(hc,'FaceAlpha',0.5);
            
            
            
        end
        
    end
    %     if s==1,
    %         plot_signal(B.sensor{s}.peakvalley.matlabtime(2:2:end),B.sensor{s}.peakvalley.sample(2:2:end),'b.',1,offset);
    %         hold on;
    %
    %         if isfield(B.cress,'puff_peak')
    %             for j=1:length(B.cress.puff_peak)
    %                 if isfield(B.cress,'hand') && ~isempty(B.cress.hand{j})
    %                     plot_signal([B.cress.hand{j},B.cress.hand{j}],[0,5],'k-',3);
    %                 end
    %                 for ii=1:length(B.cress.puff_peak{j})
    %                     x=B.cress.puff_peak{j}(ii);
    %                     plot_signal(B.sensor{1}.peakvalley.matlabtime(x),B.sensor{1}.peakvalley.sample(x),'go',5,offset);
    %                 end
    %             end
    %         end
    %     end
    legend_text{i+1}=B.sensor{s}.NAME;
    %h(i+1)=plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sampleNorm,color{rem(i,length(color)+1)+1},1,offset);
    i=i+1;
end
end



function plot_cress(G,B,yMax)
%plot cress data
shiftCress=0;
if isfield(B, 'cress') && ~isempty(B.cress.data)
    [T,ia,ic] = unique(datenum(B.cress.data(:,13)));
    hold on;
    fromIndex = 1;
    hSmokingSession=[];
    hSmokingPuff=[];
    k=1;
    %StartTime=13, EndTime=14, TimeToRemoval(ms)=15, TimeToFirstPuff(ms)=16, IPI(ms)=23, Duration(ms)=22
    for i=1:length(ia)
        start=datenum(B.cress.data(ia(i),13));
        endt=datenum(B.cress.data(ia(i),14));
        %plot_signal([start start],[0 offset],'c',2,0);
        %plot_signal([endt endt],[0 offset],'c',2,0);
        hSmokingSession(i) = area([start, endt], [yMax, yMax]);
        xSmokingSession(i) = area([start+shiftCress, endt+shiftCress], [yMax, yMax]);
        
        text((start+endt)/2 + shiftCress, 0  , ['Smoking Session : ' int2str(i)], 'Color', 'k', 'FontSize', 18, 'Rotation', 90);
        ttStart=start;
        for j=fromIndex:ia(i)
            ipi = str2double(B.cress.data(j,23))/(1000*60*60*24);
            duration = str2double(B.cress.data(j,22))/(1000*60*60*24);
            hSmokingPuff(k) = area([ttStart+ipi, ttStart+ipi+duration], [yMax, yMax]);
            xSmokingPuff(k) = area([ttStart+ipi+shiftCress, ttStart+ipi+duration+shiftCress], [yMax, yMax]);
            
            text(ttStart+ipi+duration/2+shiftCress, 0  , ['Puff : ' int2str(j-fromIndex+1)], 'Color', 'k', 'FontSize', 18, 'Rotation', 90);
            ttStart = ttStart+ipi+duration;
            k=k+1;
        end
        fromIndex=ia(i)+1;
    end
    
    hold off;
    for i=1:numel(hSmokingSession)
        hc=get(hSmokingSession(i),'children');
        set(hc,'FaceColor',[1 1 .33], 'EdgeColor', [1 1 .33]);
        %set(hc,'FaceAlpha',0.5);
    end
    %alpha(1.0);
    for i=1:numel(hSmokingPuff)
        hc=get(hSmokingPuff(i),'children');
        %set(hc,'FaceColor',[.5 1 .5], 'EdgeColor', [.5 1 .5]);
        set(hc,'FaceColor',[1 .5 1], 'EdgeColor', [1 .5 1]);
        %set(hc,'FaceAlpha',0.5);
    end
    for i=1:numel(xSmokingSession)
        hc=get(xSmokingSession(i),'children');
        set(hc,'FaceColor',[1 1 .66], 'EdgeColor', [1 1 .66]);
        %set(hc,'FaceAlpha',0.5);
    end
    %alpha(1.0);
    for i=1:numel(xSmokingPuff)
        hc=get(xSmokingPuff(i),'children');
        %set(hc,'FaceColor',[.5 1 .5], 'EdgeColor', [.5 1 .5]);
        set(hc,'FaceColor',[.5 .2 .2], 'EdgeColor', [.5 .2 .2]);
        %set(hc,'FaceAlpha',0.5);
    end
end

end