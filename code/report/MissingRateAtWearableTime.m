t=find(R.sensor(SENSOR.R_RIPID).timestamp);
time=R.sensor(SENSOR.R_RIPID).timestamp(t);

diffT=diff(time);

indMissing=find(diffT>=5000);

missingMinutes=0;
avilableMinutes=0;
%calculate how many minutes are missing
%how many missing samples coinside with not wearing the sensor
%discard those missing minutes from the total count

%at first count how many minutes are missing

for i=indMissing
    missing=(time(i+1)-time(i))/60000;
    if missing<30
        missingMinutes=missingMinutes+missing;
        for j=1:length(R.dataquality_mark)
            goodStr=char(R.dataquality_mark.good(j));
            kg=strfind(goodStr,'=');
            if R.dataquality_mark(j)>=time(i) && R.dataquality_mark(j)<=time(i+1) && str2double(goodStr(kg+1:end))==0 %if band off is inside the missing minute, we discard that missing
                missingMinutes=missingMinutes-1;
            end
        end
    end
end;


