function rip=rip_features(G,P)
rip.starttimestamp=P.sensor{1}.peakvalley_new_3.timestamp(1:2:end-2);
rip.endtimestamp=P.sensor{1}.peakvalley_new_3.timestamp(3:2:end);
rip.missing=calculate_missing_rip(G,P);
rip.feature(1,:)=P.sensor{1}.peakvalley_new_3.timestamp(2:2:end)-P.sensor{1}.peakvalley_new_3.timestamp(1:2:end-1);rip.featurename{1}='INSP';
rip.feature(2,:)=P.sensor{1}.peakvalley_new_3.timestamp(3:2:end)-P.sensor{1}.peakvalley_new_3.timestamp(2:2:end-1);rip.featurename{2}='EXPR';
rip.feature(3,:)=P.sensor{1}.peakvalley_new_3.timestamp(3:2:end)-P.sensor{1}.peakvalley_new_3.timestamp(1:2:end-2);rip.featurename{3}='RESP';
rip.feature(4,:)=rip.feature(1,:)./rip.feature(2,:);rip.featurename{4}='IE';
rip.featurename{5}='Stretch';rip.featurename{6}='U_Stretch';rip.featurename{7}='L_Stretch';rip.featurename{8}='ROC_MAX';rip.featurename{9}='ROC_MIN';

sample=smooth(P.sensor{1}.sample_new,21,'moving');
s=diff(sample);
s(end+1)=s(end);
N=length(rip.starttimestamp);
for i=1:length(rip.starttimestamp)
    stime=rip.starttimestamp(i);
    etime=rip.endtimestamp(i);
    [a,b]=binarysearch(P.sensor{1}.timestamp,stime,etime);
    sample_new=P.sensor{1}.sample_new(a:b-1);
    sample_diff=s(a:b-1);
    rip.feature(5,i)=max(sample_new)-min(sample_new);
    rip.feature(6,i)=max(sample_new);
    rip.feature(7,i)=min(sample_new);
    rip.feature(8,i)=max(sample_diff);
    rip.feature(9,i)=min(sample_diff);
end
for i=1:length(rip.starttimestamp)
    if i==1
        rip.feature(10:18,i)=0;
    else
        for j=10:18
            rip.feature(j,i)=rip.feature(j-9,i)-rip.feature(j-9,i-1);
            rip.featurename{j}=['BD_' rip.featurename{j-9}];
        end
    end
    if i==N
        rip.feature(19:27,i)=0;
    else
        for j=19:27
            rip.feature(j,i)=rip.feature(j-18,i)-rip.feature(j-18,i+1);
            rip.featurename{j}=['FD_' rip.featurename{j-18}];
            
        end
    end
    sum=zeros(9,1);
    count=0;
    for j=i-2:i+2
        if j<1, continue;end;
        if j>N, continue;end;
        if j==i, continue;end;
        for k=1:9
            sum(k)=sum(k)+rip.feature(k,j);            
        end
        count=count+1;
    end
    sum=double(sum)/double(count);
    rip.feature(28:36,i)=rip.feature(1:9,i)./sum;
    
    for j=28:36
        rip.featurename{j}=['D5_' rip.featurename{j-27}];        
    end    
%{
    if i==1 || i==N
        rip.feature(14,i)=0;
        rip.feature(15,i)=0;    
    else
        rip.feature(14,i)=rip.feature(5,i)-mean([rip.feature(5,i+1),rip.feature(5,i-1)]);
        rip.feature(15,i)=rip.feature(6,i)-mean([rip.feature(6,i+1),rip.feature(6,i-1)]);
    end
%}
end
end
