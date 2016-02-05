function sensor=read_gpsfiles(G,indir,starttimestamp,endtimestamp)
    filelist=findfiles(indir,G.FILE.LOCATION_NAME);%LOCATION_LOG
    filelist=finduniquefiles(filelist);
    noFile=size(filelist,2);
    
    %Meta data : what is going where. When sensor id 1 means RIP.
    for i=G.RUN.FRMTRAW.SENSORLIST_GPS
        sensor{i}.NAME=G.SENSOR.ID(i).NAME;
        sensor{i}.METADATA=G.SENSOR.ID(i);
        sensor{i}.sample=[];
        sensor{i}.timestamp=[];
        sensor{i}.matlabtime=[];
    end
    
    all_sensor=[];
    for i=1:noFile
        fileInfo = dir(filelist{i});
        if fileInfo.bytes==0
            continue;
        end
        %Latitude(1), Longitude(2), Altitude(3), Bear(4), Speed(5), Accuracy(6), gps(7), Timestamp(8)
        %data=csvread(filelist{i});
        fp = fopen(filelist{i}, 'r');
        data = textscan(fp, '%f %f %f %f %f %f %s %f', 'delimiter', ',');
        fclose(fp);
        data = [data{1:6} data{8}]; % remove gps column
        data=data(data(:,1)~=-1,:); % Garbage data when first column is -1 is removed
        col=size(data,2);
        data=data(data(:,7)>=starttimestamp & data(:,7)<=endtimestamp,:);
        all_sensor=[all_sensor;data];
    end
    all_sensor=unique(all_sensor,'rows');
    sensor=save_sensor(G,all_sensor,sensor);
end

function sensor=save_sensor(G,all_sensor,sensor)
    row=size(all_sensor,1);
    if row==0
        return;
    end
    
    %Latitude(1), Longitude(2), Altitude(3), Bear(4), Speed(5), Accuracy(6), Timestamp(7)
    if issorted(all_sensor(:,7))==0
%        disp('... gps data needed to sort');
        all_sensor=sortrows(all_sensor,7);
    end
    
    for i=G.RUN.FRMTRAW.SENSORLIST_GPS
        sensor{i}.sample = all_sensor(:,G.SENSOR.ID(i).CSV_COLUMN);
        sensor{i}.timestamp = all_sensor(:,7);
        sensor{i}.matlabtime=convert_timestamp_matlabtimestamp(G,all_sensor(:,7));
	end
end
