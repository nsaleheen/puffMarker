function P=correct_leftright_using_history(P)
result=[];
for i=1:length(P.wrist{1}.LR.timestamp)
    if P.wrist{1}.LR.predict(i)==P.wrist{2}.LR.predict(i), result(i)=-1;
    elseif P.wrist{1}.LR.predict(i)==-1 || P.wrist{2}.LR.predict(i)==-1, result(i)=-1;
    else
        result(i)=P.wrist{1}.LR.predict(i);
    end
end
predict1=[];
predict2=[];
predict1(1)=0;predict2(1)=1;

for i=2:length(P.wrist{1}.LR.timestamp)
    time=P.wrist{1}.LR.timestamp(i);
    ind=find(P.wrist{1}.LR.timestamp>=time-10*60*1000 & P.wrist{1}.LR.timestamp<=time);% & P.wrist{1}.LR.timestamp<=time+5*60*1000);
    if length(find(result(ind)==1))>=0.9*length(ind) %length(find(result(ind)==0))
        predict1(i)=1;predict2(i)=0;
    elseif length(find(result(ind)==0))>=0.9*length(ind) %find(result(ind)==0))
        predict1(i)=0;predict2(i)=1;
    else
        predict1(i)=predict1(i-1);predict2(i)=predict2(i-1);
    end
end
P.wrist{1}.LR.predict=predict1;
P.wrist{2}.LR.predict=predict2;
end

