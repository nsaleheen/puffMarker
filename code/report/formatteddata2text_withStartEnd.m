function formatteddata2text_withStartEnd(D,starttime,endtime,filename)  %write to the text file from start to end using the label as a file name
%ind_rip=find(D.sensor(1).timestamp>=D.datalabel(lebel).starttime & D.sensor(1).timestamp<D.datalabel(lebel).endtime);
%{
if nargin < 4
    endtime=D.datalabel(lebel).endtime;
else
    endtime=D.datalabel(lebel).starttime+durationInMinute*60*1000;
end
%}
ind_rip=find(D.sensor(1).timestamp>=starttime & D.sensor(1).timestamp<endtime);
figure;
plot(D.sensor(1).timestamp(ind_rip),D.sensor(1).sample(ind_rip));
data=[D.sensor(1).sample(ind_rip)' D.sensor(1).timestamp(ind_rip)'];
name=['C:\Users\mmrahman\Desktop\Umass\rip' filename '.txt'];
%fid=fopen('C:\Users\mmrahman\Desktop\Umass\ripRunning.txt','w');
fid=fopen(name,'w');
for i=1:length(ind_rip)
    line=[num2str(int64(data(i,1))) ',' num2str(int64(data(i,2)))];
    fprintf(fid,'%s\n',line);
end
fclose(fid);
%dlmwrite('C:\Users\mmrahman\Desktop\Umass\ripRunning.txt',data);

ind_X=find(D.sensor(4).timestamp>=starttime & D.sensor(4).timestamp<endtime);
ind_Y=find(D.sensor(5).timestamp>=starttime & D.sensor(5).timestamp<endtime);
ind_Z=find(D.sensor(6).timestamp>=starttime & D.sensor(6).timestamp<endtime);

len=min([length(ind_X) length(ind_Y) length(ind_Z)]);
figure;
plot(D.sensor(4).timestamp(ind_X(1:len)),D.sensor(4).sample(ind_X(1:len)));
figure;
plot(D.sensor(5).timestamp(ind_Y(1:len)),D.sensor(5).sample(ind_Y(1:len)));
figure;
plot(D.sensor(6).timestamp(ind_Z(1:len)),D.sensor(6).sample(ind_Z(1:len)));

data=[D.sensor(4).sample(ind_X(1:len))' D.sensor(4).timestamp(ind_X(1:len))' D.sensor(5).sample(ind_Y(1:len))' D.sensor(5).timestamp(ind_Y(1:len))' D.sensor(6).sample(ind_Z(1:len))' D.sensor(6).timestamp(ind_Z(1:len))'];
name=['C:\Users\mmrahman\Desktop\Umass\accel1' filename '.txt'];
fid=fopen(name,'w');
for i=1:len
    line=[num2str(int64(data(i,1))) ',' num2str(int64(data(i,2))) ',' num2str(int64(data(i,3))) ',' num2str(int64(data(i,4))) ',' num2str(int64(data(i,5))) ',' num2str(int64(data(i,6)))];
    fprintf(fid,'%s\n',line);
end
fclose(fid);
end




