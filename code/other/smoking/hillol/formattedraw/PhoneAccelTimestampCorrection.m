function all=PhoneAccelTimestampCorrection(all)
chunkInd=find(diff(all(:,2))/1000/60>10); %divided into segments
correctedTimestamp=[];
if length(chunkInd)>0
    for i=1:length(chunkInd)+1
        eachPart=[];
        if i==1
           eachPart=all(1:chunkInd(i),:); 
        elseif i==length(chunkInd)+1
           eachPart=all(chunkInd(i-1)+1:end,:);
        else
           eachPart=all(chunkInd(i-1)+1:chunkInd(i),:); 
        end
        freq=length(eachPart)/((eachPart(end,2)-eachPart(1,2))/1000); %freq of each segment
        len=length(eachPart(:,2));
        filltime=JFilltimeMahbub(freq,len);
        correctedTS=filltime.fill(eachPart(1,2));
        correctedTimestamp=[correctedTimestamp;correctedTS];
    end
    all=[all(:,1) correctedTimestamp];
else
    eachPart=all(1:end,:);
    freq=length(eachPart)/((eachPart(end,2)- eachPart(1,2))/1000); %freq of each segment
    len=length(eachPart(:,2));
    filltime=JFilltimeMahbub(freq,len);
    correctedTS=filltime.fill(eachPart(1,2));
    correctedTimestamp=[correctedTimestamp;correctedTS];
    all=[all(:,1) correctedTimestamp];
end
end

%{
all_firstpart=all(1:1967169,:);
all_secondpart=all(1967170:end,:);
sampling_freq1=length(all_firstpart)/((all_firstpart(end,2)-all_firstpart(1,2))/1000);
uniqTS=unique(all_firstpart(:,2));
correctedTS1=[];
for i=1:length(uniqTS)
    sampleLen=length(find(uniqTS(i)==all_firstpart(:,2)));
    filltime=JFilltimeMahbub(sampling_freq1,sampleLen);
    correctedTS1=[correctedTS1;filltime.fill(uniqTS(i))];
end


sampling_freq2=length(all_secondpart)/((all_secondpart(end,2)-all_secondpart(1,2))/1000);



allX1(:,1)=(allX(:,1)-mean(allX(:,1)))/stdev(allX(:,1));
allY1(:,1)=allY(:,1)-min(allY(:,1));
allZ1(:,1)=allZ(:,1)-min(allZ(:,1));
%}