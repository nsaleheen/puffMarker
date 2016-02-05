%search band loose event
%back track from the band loose, find missing for more than 5 minutes
%end time of the missing / or start time of the window after the missing
%window. find the duration from that time to start of the band loose
cd C:\DataProcessingFramework\data\memphis\formatteddata

threshold=5*60*1000;  %assume more than 5 minute band of / missing is intentional
short = 60*1000;      %two  band loose episodes should be >1 minute apart
timeToLoose=[];
loose.filename=[];
loose.indices=[];

flist=dir;

for l=3:length(flist)
    %load formatted data
    flist(l).name
    load(flist(l).name);
    %load('p12_s02_frmtdata')
%     ind=find(D.sensor{1}.quality.value==3);
%     if ~isempty(ind)
        % first check to see if the duration between two band loose is
        % very short
%         ind1=ind(1);
%         for i=2:length(ind)
%             if D.sensor{1}.quality.starttimestamp(i)
%         end
%         for i=1:length(ind)
%             for k=ind(i)-1:-1:1
%                 if D.sensor{1}.quality.value(k)==3 || (D.sensor{1}.quality.value(k)==1 &&  (D.sensor{1}.quality.endtimestamp(k) - D.sensor{1}.quality.starttimestamp(k))>threshold)   %missing
%                     if (D.sensor{1}.quality.starttimestamp(ind(i))-D.sensor{1}.quality.endtimestamp(k))/1000>60
%                         timeToLoose=[timeToLoose (D.sensor{1}.quality.starttimestamp(ind(i))-D.sensor{1}.quality.endtimestamp(k))/1000];
%                     end
%                     break;
%                 end
%             end
%         end
%     end
    duration=0;
    for i=1:length(D.sensor{1}.quality.value)
        if D.sensor{1}.quality.value(i)~=2
            dur=(D.sensor{1}.quality.endtimestamp(i)-D.sensor{1}.quality.starttimestamp(i));
            if D.sensor{1}.quality.value(i)==1 && dur>threshold
                duration=0;
            else
                duration=duration+dur;
            end
        else
            if duration/1000/60<1
                loose.filename=[loose.filename;flist(l).name];
                loose.indices=[loose.indices i];
            end
            if duration==0 || duration>short
                timeToLoose=[timeToLoose duration];
            end
            duration=0;
        end
    end
end