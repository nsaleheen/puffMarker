function iplot4(G, participant,session, INDIR, slist, plotCres, shiftCress)
    
    %color={'r-','g-','b-','y-','m-','c-','w-', 'k-',   'r-','g-','b-','y-','m-','c-','w-', 'k-'};
    color={'r-','g-','b-','m-','c-', 'k-',   'r-','g-','b-','m-','c-', 'k-'};
    
	pid = ['p' num2str(participant','%02d')];
	sid = ['s' num2str(session','%02d')];
	indir=[G.DIR.DATA G.DIR.SEP INDIR];
	infile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];
	if exist([indir G.DIR.SEP infile],'file')~=2,return;end
	load([indir G.DIR.SEP infile]);
    
    for s=slist
        maxS = max(R.sensor{s}.sample);
        minS = min(R.sensor{s}.sample);
        R.sensor{s}.sampleNorm = (R.sensor{s}.sample-minS)/(maxS-minS);%Scaling from 0 to 1
    end
    
    figure;
    
	yMax=0;
	for s=slist
		yMax=yMax+max(R.sensor{s}.sampleNorm);
    end
    
    %plot cress data
    if plotCres==1 && isfield(R, 'cress') && length(R.cress.data)>0
        [T,ia,ic] = unique(datenum(R.cress.data(:,13)));
        hold on;
        fromIndex = 1;
        hSmokingSession=[];
        hSmokingPuff=[];
        k=1;
        %StartTime=13, EndTime=14, TimeToRemoval(ms)=15, TimeToFirstPuff(ms)=16, IPI(ms)=23, Duration(ms)=22
        for i=1:length(ia)
            start=datenum(R.cress.data(ia(i),13));
            endt=datenum(R.cress.data(ia(i),14));
            %plot_signal([start start],[0 offset],'c',2,0);
            %plot_signal([endt endt],[0 offset],'c',2,0);
            hSmokingSession(i) = area([start+shiftCress, endt+shiftCress], [yMax, yMax]);
            text((start+endt)/2 + shiftCress, 0  , ['Smoking Session : ' int2str(i)], 'Color', 'k', 'FontSize', 18, 'Rotation', 90);
            ttStart=start;
            for j=fromIndex:ia(i)
                ipi = str2double(R.cress.data(j,23))/(1000*60*60*24);
                duration = str2double(R.cress.data(j,22))/(1000*60*60*24);
                hSmokingPuff(k) = area([ttStart+ipi+shiftCress, ttStart+ipi+duration+shiftCress], [yMax, yMax]);
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

        
    end

    
    
    
		
    offset=yMax;
    i=0;
    h=[];
    for s=slist
        hold on;
        offset=offset-max(R.sensor{s}.sampleNorm);
        if length(R.sensor{s}.matlabtime)==0
            continue;
        end
        h(i+1)=plot_signal(R.sensor{s}.matlabtime,R.sensor{s}.sampleNorm,color{rem(i,length(color)+1)+1},1,offset);
        legend_text{i+1}=R.sensor{s}.NAME;
        %h(i+1)=plot_signal(R.sensor{s}.matlabtime,R.sensor{s}.sampleNorm,color{rem(i,length(color)+1)+1},1,offset);
        i=i+1;
	end
    
	legend(h,legend_text,'Interpreter', 'none');
    xlabel('Time');
    ylabel('Magnitude');
	
	
	
	
    
	
	
    %plot_selfreport(G,pid,sid,'formattedraw',[G.SELFREPORT.SMKID]);
    list_selfreport=[G.SELFREPORT.SMKID];
    for s=list_selfreport
        hold on;
        for i=1:length(R.selfreport{s}.matlabtime)
            hold on;
            plot([R.selfreport{s}.matlabtime(i),R.selfreport{s}.matlabtime(i)],ylim,'r-','LineWidth',2);
            hold on;
            text(R.selfreport{s}.matlabtime(i), 0  , [R.selfreport{s}.NAME ' : ' int2str(i)], 'Color', 'k','FontSize',18,'Rotation',90);
        end
    end
    plot_ema(G,pid,'s01','formattedraw_lab',22);
    
    noOfSelfReport=length(R.selfreport{s}.matlabtime);
    fprintf('No of self-report = %d\n', noOfSelfReport);
    
    totalEmaCount = 0;
    specialEmaCount = 0;
    if length(R.ema.data)>0
        specialEmaCount = sum(str2num(char(R.ema.data(:,3))) == 22);
        totalEmaCount = length(R.ema.data(:,3));
    end
    fprintf('Total EMA = %d\n', totalEmaCount);
    fprintf('Special EMA = %d\n', specialEmaCount);
end
