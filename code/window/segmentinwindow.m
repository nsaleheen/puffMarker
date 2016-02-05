function window=segmentinwindow(G,sensor,starttimestamp,endtimestamp,MODEL)

%This function takes in samples and timestamps and segments it into windows
%each segment: has its samples and timestamps. WindowLength is in seconds

ind=0;
for i=starttimestamp:MODEL.WINDOW_LEN:endtimestamp-1
    ind=ind+1;
    window(ind).starttimestamp = i;    
    window(ind).endtimestamp = i+MODEL.WINDOW_LEN;
    
    window(ind).start_matlabtime=convert_timestamp_matlabtimestamp(G,window(ind).starttimestamp);
    window(ind).end_matlabtime=convert_timestamp_matlabtimestamp(G,window(ind).endtimestamp);
    
    for sensorID=MODEL.SENSORLIST
        indices= find(sensor{sensorID}.timestamp>=i & sensor{sensorID}.timestamp<i+MODEL.WINDOW_LEN);
        window(ind).sensor{sensorID}.sample = sensor{sensorID}.sample(indices);
        window(ind).sensor{sensorID}.timestamp = sensor{sensorID}.timestamp(indices);
        if length(window(ind).sensor{sensorID}.sample)>G.SENSOR.ID(sensorID).FREQ*MODEL.WINDOW_LEN/1000*(1-MODEL.MISSINGRATE)
            window(ind).sensor{sensorID}.quality=G.QUALITY.GOOD;
        else
            window(ind).sensor{sensorID}.quality=G.QUALITY.MISSING;
        end
        if sensorID==G.SENSOR.R_RIPID
            ind1=find(sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp>=i & sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp<i+MODEL.WINDOW_LEN);
            % this part is added by karen  to ensure start from valley and
            % end at valley
            if ~isempty(ind1)
                if mod(ind1(1),2)==0
                    ind1 = [ind1(1)-1,ind1];
                end
                if mod(ind1(end),2)==0
                    if ind1(end)<length(sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp)
                        ind1 = [ind1,ind1(end)+1];
                    else ind1(end)=[];
                    end
                end
                %end karen code
                window(ind).sensor{sensorID}.peakvalley.timestamp=sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp(ind1);
                window(ind).sensor{sensorID}.peakvalley.sample=sensor{G.SENSOR.R_RIPID}.peakvalley.sample(ind1);
                %window(ind).sensor{sensorID}.peakvalley.sequence=sensor{G.SENSOR.R_RIPID}.peakvalley.sequence(ind1);
                %{
            W.sensor{sensorID}.window(ind).peakindex=[];
            W.sensor{sensorID}.window(ind).valleyindex=[];
            for p=1:size(W.sensor{sensorID}.window(ind).peakvalley_timestamp,2)
                pvind=find(B.sensor{SENSOR.R_RIPID}.timestamp==W.sensor{sensorID}.window(ind).peakvalley_timestamp(p));
                if mod(p,2)==0
                    W.sensor{sensorID}.window(ind).peakindex=[W.sensor{sensorID}.window(ind).peakindex pvind];
                else
                    W.sensor{sensorID}.window(ind).valleyindex=[W.sensor{sensorID}.window(ind).valleyindex pvind];
                end
            end
            for f=1:BASICFEATURE.RIP.NO
                W.sensor{sensorID}.window(ind).basicfeature=B.sensor{sensorID}.basicfeature(ind1(2:2:end)./2);
            end
            W.sensor{sensorID}.window(ind).outlier=B.sensor{sensorID}.outlier(ind1(2:2:end)./2);
            W.sensor{sensorID}.META_BASICFEATURE=B.sensor{sensorID}.META_BASICFEATURE;
            W.sensor{sensorID}.META_PEAKVALLEY=B.sensor{sensorID}.META_PEAKVALLEY;
                %}
            end
            
        elseif sensorID==G.SENSOR.R_ECGID
            window(ind).sensor{sensorID}.rr.timestamp=[];
            window(ind).sensor{sensorID}.rr.sample=[];
            window(ind).sensor{sensorID}.rr.quality=[];
            
            ind1=find(sensor{G.SENSOR.R_ECGID}.rr.timestamp>=i & sensor{G.SENSOR.R_ECGID}.rr.timestamp<i+MODEL.WINDOW_LEN);
            if length(ind1)<=0, continue;end;
%            disp([num2str(length(ind1)) ' ' num2str(length(sensor{G.SENSOR.R_ECGID}.rr.sample)) ' ' num2str(length(sensor{G.SENSOR.R_ECGID}.rr.quality))]);
            window(ind).sensor{sensorID}.rr.timestamp=sensor{G.SENSOR.R_ECGID}.rr.timestamp(ind1);
            window(ind).sensor{sensorID}.rr.sample=sensor{G.SENSOR.R_ECGID}.rr.sample(ind1);
            window(ind).sensor{sensorID}.rr.quality=sensor{G.SENSOR.R_ECGID}.rr.quality(ind1);
        end
    end
end
end
