function [Err_p,Err_d,MinDist,MaxDist]=find_threshold_1_segmentation_gyr(G, P, TH)
Err_p=zeros(1,TH);
Err_d=zeros(1,TH);
MinDist=inf;
MaxDist=0;
for i=1:2
        sample{i}=P.wrist{i}.magnitude;
%        sample{i}=P.wrist{i}.gyr.magnitude.sample;        
        timestamp{i}=P.wrist{i}.timestamp;
        sample_800{i}=P.wrist{i}.magnitude_800;
        sample_8000{i}=P.wrist{i}.magnitude_8000;
        
        [sind{i},eind{i}]=calculate_segment_gyr(sample_800{i},sample_8000{i});
        t_starttimestamp{i}=timestamp{i}(sind{i});t_endtimestamp{i}=timestamp{i}(eind{i});
        for j=1:length(t_starttimestamp{i})
            stime=t_starttimestamp{i}(j);etime=t_endtimestamp{i}(j);
            ind=find(timestamp{i}>=stime & timestamp{i}<=etime);
            value{i}(j)=mean(sample_8000{i}(ind)-sample_800{i}(ind));
        end
end
for th=1:TH
    fprintf('th=%d\n',th);
    starttimestamp{1}=[];starttimestamp{2}=[];%t_starttimestamp;
    endtimestamp{1}=[];endtimestamp{2}=[];%t_endtimestamp;
    for i=1:2
 %       [ssind{i},eeind{i}]=filter_segment_height(sample_8000{i},sample_800{i},timestamp{i},sind{i},eind{i},th);
        ind=find(value{i}>th);
        starttimestamp{i}=t_starttimestamp{i}(ind);
        endtimestamp{i}=t_endtimestamp{i}(ind);
        
%        segment{i}=gyr_segmentation(res{i},0.001,1);
%        sind=segment{i}(1:2:end);eind=segment{i}(2:2:end);starttimestamp{i}=timestamp{i}(sind);endtimestamp{i}=timestamp{i}(eind);
    end
   
    for e=1:length(P.smoking_episode)
        if isempty(P.smoking_episode{e}.puff), continue;end;
        i=P.smoking_episode{e}.puff.acl.id;
%        sx=find(endtimestamp{i}-starttimestamp{i}>200);
%        stime=starttimestamp{i}(sx);
%        etime=endtimestamp{i}(sx);

        stime=starttimestamp{i};
        etime=endtimestamp{i};
        for p=1:length(P.smoking_episode{e}.puff.acl.starttimestamp)
            if P.smoking_episode{e}.puff.acl.missing(p)>0.20, continue;end;
            if P.smoking_episode{e}.puff.acl.valid(p)~=0, continue;end;
            pstime=P.smoking_episode{e}.puff.acl.starttimestamp(p)-3000;
            petime=P.smoking_episode{e}.puff.acl.endtimestamp(p)+3000;
            Err=inf;
            x=find(stime>=pstime & etime<=petime);
            if ~isempty(x),
                [a,b]=max(etime(x)-stime(x));
%                sstime=stime(x(b));eetime=etime(x(b));
                Err=(petime-pstime)-a;%(eetime-sstime);
                if MinDist>a, MinDist=a;end;
                if MaxDist<a, MaxDist=a;end;
            end
            if Err==inf
                Err_p(th)=Err_p(th)+1;
            else
%                Err_d(th)=Err_d(th)+Err*Err;
            end
        end
    end
    Err_d(th)=length(starttimestamp{1})+length(starttimestamp{2});
end
end


