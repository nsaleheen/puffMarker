function sensor=read_tosfiles(G,indir,starttimestamp,endtimestamp)
filelist=findfiles(indir,G.FILE.TOS_NAME);
filelist=finduniquefiles(filelist); % Same file can be multiple times. Only take unique ones
noFile=size(filelist,2);

for i=G.RUN.FRMTRAW.SENSORLIST_TOS
    sensor{i}.NAME=G.SENSOR.ID(i).NAME;
    sensor{i}.METADATA=G.SENSOR.ID(i);
    sensor{i}.sample=[];
    sensor{i}.timestamp=[];
end
all_sensor=[];
for i=1:noFile
    fileInfo = dir(filelist{i});
    if fileInfo.bytes==0
        continue;
    end
    data=csvread(filelist{i});
    data(size(data,1),:)=[];
    data=data(data(:,1)~=-1,:); % When phone software is closed at that time there is some garbage data. Discard that.
    col=size(data,2);
    data=data(data(:,col-1)>=starttimestamp & data(:,col-1)<=endtimestamp,:); % there is a comma(,) at last. So last column is empty.
    all_sensor=[all_sensor;data]; % all_sensor have all data of that session. Combine all files as they belong to same session.
end
all_sensor=unique(all_sensor,'rows'); % There should be no duplicate. Still to be sure.
sensor=save_sensor(G,all_sensor(:,1:col-1),sensor); % one file have all the sensors. So categorize them

end

function sensor=save_sensor(G,all_sensor,sensor)
row=size(all_sensor,1);
if row==0
    return;
end

for i=G.RUN.FRMTRAW.SENSORLIST_TOS % defined in "config_run.m". Read and store only those that are mentioned there.
    [row]=size(all_sensor,1);
    onesensor=all_sensor(all_sensor(1:row,1) == G.SENSOR.ID(i).TOS_CHANNEL,:); % sensor id "G.SENSOR.ID" of each different type of sensor is defined in "config/config_sensor.m"
    if issorted(onesensor(:,7))==0
        %        fprintf('...sorted');
        onesensor=sortrows(onesensor,7); % sort by timestamp. Make sure that in case inconsistency in receiving order, it is corrected
    end
    if i==G.SENSOR.R_BATID || i==G.SENSOR.R_SKINID || i==G.SENSOR.R_AMBID
        [sensor{i}.sample, sensor{i}.timestamp]=read_battery_skin_ambient(G,onesensor,i);
        sensor{i}.matlabtime=convert_timestamp_matlabtimestamp(G,sensor{i}.timestamp);        
    else    
        [sensor{i}.sample, sensor{i}.timestamp]=assign_timestamp(G,onesensor,G.SENSOR.ID(i).FREQ);
        sensor{i}.matlabtime=convert_timestamp_matlabtimestamp(G,sensor{i}.timestamp);
    end
end
end

function [sample,timestamp]=assign_timestamp(G,onesensor,freq)
sample1=onesensor(:,2:6);
sample1=sample1';
sample=sample1(:);
sample=sample';
temp=onesensor(:,7)';
timestamp=zeros(1,size(sample,2));
timestamp(G.SAMPLE_TOS:G.SAMPLE_TOS:end)=temp;
timestamp=correct_timestamps_basic(timestamp,freq);
end

function [sample,timestamp]=read_battery_skin_ambient(G,onesensor,sensorid)
if sensorid==G.SENSOR.R_BATID, pos=1;
elseif sensorid==G.SENSOR.R_SKINID, pos=2;
elseif sensorid==G.SENSOR.R_AMBID,pos=3;
else return;
end
sample=onesensor(:,pos+1)';timestamp=onesensor(:,7)';
end
