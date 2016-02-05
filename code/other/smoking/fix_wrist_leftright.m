function P=fix_wrist_leftright(G,P,time,pid,sid)
IDS{1}=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID;
IDS{2}=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID;

P=test_wrist_leftright(G,P,time,pid,sid);
P=correct_leftright_using_history(P);
for i=1:2
    P.sensor{IDS{i}(2)}.LR.stime=[];P.sensor{IDS{i}(2)}.LR.etime=[];
    
    if i==1,    ind=find(P.wrist{i}.LR.predict==1);
    else ind=find(P.wrist{i}.LR.predict==0);
    end
    if isempty(ind),continue;end;
    x=find(diff(ind)>1);
    x=[0,x,length(ind)];
    for n=1:length(x)-1
        xx=ind(x(n)+1);
        yy=ind(x(n+1));
        fprintf('(%d %d) ',xx,yy);
        stime=P.wrist{i}.LR.timestamp(xx);
        etime=P.wrist{i}.LR.timestamp(yy); 
        P.sensor{IDS{i}(2)}.LR.stime(n)=stime;P.sensor{IDS{i}(2)}.LR.etime(n)=etime;
        z=find(P.sensor{IDS{i}(2)}.timestamp>=stime & P.sensor{IDS{i}(2)}.timestamp<=etime);
        P.sensor{IDS{i}(2)}.sample(z)=-P.sensor{IDS{i}(2)}.sample(z);
    end
end
end
