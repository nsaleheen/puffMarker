function P=fix_wrist_orientation(G,P,time,pid,sid)
IDS{1}=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID;
IDS{2}=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID;
for i=IDS{1} P.sensor{i}.sample_org=P.sensor{i}.sample;end;
for i=IDS{2} P.sensor{i}.sample_org=P.sensor{i}.sample;end;

P=test_wrist_orientation(G,P,time,pid,sid);
P=correct_orientation_using_history(P);
for i=1:2
    P.sensor{IDS{i}(1)}.CI.stime=[];P.sensor{IDS{i}(1)}.CI.etime=[];
    P.sensor{IDS{i}(2)}.CI.stime=[];P.sensor{IDS{i}(2)}.CI.etime=[];
    
    ind=find(P.wrist{i}.CI.predict==1);
    if isempty(ind),continue;end;
    x=find(diff(ind)>1);
    x=[0,x,length(ind)];
    for n=1:length(x)-1
        xx=ind(x(n)+1);
        yy=ind(x(n+1));
        fprintf('(%d %d) ',xx,yy);
        stime=P.wrist{i}.CI.timestamp(xx);
        etime=P.wrist{i}.CI.timestamp(yy);
        P.sensor{IDS{i}(1)}.CI.stime(n)=stime;P.sensor{IDS{i}(1)}.CI.etime(n)=etime;
        P.sensor{IDS{i}(2)}.CI.stime(n)=stime;P.sensor{IDS{i}(2)}.CI.etime(n)=etime;
        
        z=find(P.sensor{IDS{i}(1)}.timestamp>=stime & P.sensor{IDS{i}(1)}.timestamp<=etime);
        P.sensor{IDS{i}(1)}.sample(z)=-P.sensor{IDS{i}(1)}.sample(z);
        z=find(P.sensor{IDS{i}(2)}.timestamp>=stime & P.sensor{IDS{i}(2)}.timestamp<=etime);
        P.sensor{IDS{i}(2)}.sample(z)=-P.sensor{IDS{i}(2)}.sample(z);
    end
end
end
