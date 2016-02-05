function plot_peakvalley(G,data,SENSORIDS)

ymax=0;
for s=SENSORIDS
    ymax=ymax+max(data.sensor{s}.sample)+abs(min(data.sensor{s}.sample));
end
offset=ymax;
for s=SENSORIDS
    hold on;
    offset=offset-max(data.sensor{s}.sample)-abs(min(data.sensor{s}.sample));
    if isempty(data.sensor{s}.matlabtime),        continue;    end
    if s==G.SENSOR.R_RIPID
        minv=min(data.sensor{s}.sample);
        plot(data.sensor{s}.peakvalley_1.matlabtime(1:2:end),data.sensor{s}.peakvalley_1.sample(1:2:end)+abs(minv)+offset,'bo');
        plot(data.sensor{s}.peakvalley_1.matlabtime(2:2:end),data.sensor{s}.peakvalley_1.sample(2:2:end)+abs(minv)+offset,'ro');
        plot(data.sensor{s}.peakvalley_2.matlabtime(1:2:end),data.sensor{s}.peakvalley_2.sample(1:2:end)+abs(minv)+offset,'b*');
        plot(data.sensor{s}.peakvalley_2.matlabtime(2:2:end),data.sensor{s}.peakvalley_2.sample(2:2:end)+abs(minv)+offset,'r*');

        plot(data.sensor{s}.peakvalley_new_1.matlabtime(1:2:end),data.sensor{s}.peakvalley_new_1.sample(1:2:end)+abs(minv)+offset,'bo');
        plot(data.sensor{s}.peakvalley_new_1.matlabtime(2:2:end),data.sensor{s}.peakvalley_new_1.sample(2:2:end)+abs(minv)+offset,'ro');
        plot(data.sensor{s}.peakvalley_new_2.matlabtime(1:2:end),data.sensor{s}.peakvalley_new_2.sample(1:2:end)+abs(minv)+offset,'b*');
        plot(data.sensor{s}.peakvalley_new_2.matlabtime(2:2:end),data.sensor{s}.peakvalley_new_2.sample(2:2:end)+abs(minv)+offset,'r*');
        for i=1:2
            ind=find(data.wrist{i}.gyr.segment.puff==1);
            if isempty(ind), continue;end;
            pind=data.wrist{i}.gyr.segment.peak_ind(ind);
            plot(data.sensor{s}.peakvalley_new_1.matlabtime(pind-1),data.sensor{s}.peakvalley_new_1.sample(pind-1)+abs(minv)+offset,'ks','MarkerFaceColor','k');
            plot(data.sensor{s}.peakvalley_new_1.matlabtime(pind),data.sensor{s}.peakvalley_new_1.sample(pind)+abs(minv)+offset,'ks','MarkerFaceColor','k');
            plot(data.sensor{s}.peakvalley_new_1.matlabtime(pind+1),data.sensor{s}.peakvalley_new_1.sample(pind+1)+abs(minv)+offset,'ks','MarkerFaceColor','k');
            
        end    
    end
end
end
