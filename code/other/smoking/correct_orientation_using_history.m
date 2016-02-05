function P=correct_orientation_using_history(P)
for i=1:2
    predict=[];
    predict(1)=0;
%    P.wrist{i}.CI.predict(1)=0;
    for j=2:length(P.wrist{i}.CI.timestamp)
        time=P.wrist{i}.CI.timestamp(j);
        ind=find(P.wrist{i}.CI.timestamp>=time-10*60*1000 & P.wrist{i}.CI.timestamp<=time);
        
        if length(find(P.wrist{i}.CI.predict(ind)==1))>=0.9*length(ind) %length(find(result(ind)==0))
            predict(j)=1;
        elseif length(find(P.wrist{i}.CI.predict(ind)==0))>=0.9*length(ind) %find(result(ind)==0))
            predict(j)=0;
        else
            predict(j)=predict(j-1);
        end
    end
    P.wrist{i}.CI.predict=predict;
end
end
