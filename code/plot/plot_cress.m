function plot_cress(G,data)
%plot cress data
y=ylim;yMax=y(2);
shiftCress=0;
if isfield(data, 'cress') && ~isempty(data.cress.data)
    [T,ia,ic] = unique(datenum(data.cress.data(:,13)));
    hold on;
    fromIndex = 1;
    hSmokingSession=[];
    hSmokingPuff=[];
    k=1;
    %StartTime=13, EndTime=14, TimeToRemoval(ms)=15, TimeToFirstPuff(ms)=16, IPI(ms)=23, Duration(ms)=22
    for i=1:length(ia)
        start=datenum(data.cress.data(ia(i),13));
        endt=datenum(data.cress.data(ia(i),14));
        %plot_signal([start start],[0 offset],'c',2,0);
        %plot_signal([endt endt],[0 offset],'c',2,0);
        hSmokingSession(i) = area([start, endt], [yMax, yMax]);
        xSmokingSession(i) = area([start+shiftCress, endt+shiftCress], [yMax, yMax]);
        
        text((start+endt)/2 + shiftCress, 0  , ['Smoking Session : ' int2str(i)], 'Color', 'k', 'FontSize', 18, 'Rotation', 90);
        ttStart=start;
        for j=fromIndex:ia(i)
            ipi = str2double(data.cress.data(j,23))/(1000*60*60*24);
            duration = str2double(data.cress.data(j,22))/(1000*60*60*24);
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
