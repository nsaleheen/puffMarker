function iplot4_monowar_pv(G, pid,sid, INDIR, slist, plotCres, shiftCress)

%color={'r-','g-','b-','y-','m-','c-','w-', 'k-',   'r-','g-','b-','y-','m-','c-','w-', 'k-'};
color={'r-','g-','b-','m-','c-', 'k-',   'r-','g-','b-','m-','c-', 'k-'};

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);

for s=slist
    maxS = max(B.sensor{s}.sample);
    minS = min(B.sensor{s}.sample);
    B.sensor{s}.sampleNorm = (B.sensor{s}.sample-minS)/(maxS-minS);%Scaling from 0 to 1
    if s==1,
        B.sensor{s}.peakvalley.sampleNorm=(B.sensor{s}.peakvalley.sample-minS)/(maxS-minS);
    end
end
hh=figure;
title(['pid=' pid ' sid=' sid]);

yMax=0;
for s=slist
    yMax=yMax+max(B.sensor{s}.sampleNorm);
end

%plot cress data
if plotCres==1 && isfield(B, 'cress') && length(B.cress.data)>0
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





offset=yMax;
i=0;
h=[];
for s=slist
    hold on;
    offset=offset-max(B.sensor{s}.sampleNorm);
    if length(B.sensor{s}.matlabtime)==0
        continue;
    end
    h(i+1)=plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sampleNorm,color{rem(i,length(color)+1)+1},1,offset);
    if s==1,
        plot_signal(B.sensor{s}.peakvalley.matlabtime(2:2:end),B.sensor{s}.peakvalley.sampleNorm(2:2:end),'b.',1,offset);
    end
    legend_text{i+1}=B.sensor{s}.NAME;
    %h(i+1)=plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sampleNorm,color{rem(i,length(color)+1)+1},1,offset);
    i=i+1;
end

legend(h,legend_text,'Interpreter', 'none');
xlabel('Time');
ylabel('Magnitude');







%plot_selfreport(G,pid,sid,'formattedraw',[G.SELFREPORT.SMKID]);
list_selfreport=[G.SELFREPORT.SMKID];
for s=list_selfreport
    hold on;
    for i=1:length(B.selfreport{s}.matlabtime)
        hold on;
        plot([B.selfreport{s}.matlabtime(i),B.selfreport{s}.matlabtime(i)],ylim,'r-','LineWidth',2);
        hold on;
        text(B.selfreport{s}.matlabtime(i), 0  , [B.selfreport{s}.NAME ' : ' int2str(i)], 'Color', 'k','FontSize',18,'Rotation',90);
    end
end

saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.jpg']);
end
