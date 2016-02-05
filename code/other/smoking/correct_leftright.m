function P=correct_leftright(G,P,pid,sid)
fprintf('...correct_leftright');
%P.sensor{G.SENSOR.WL9_ACLYID}.sample=-P.sensor{G.SENSOR.WL9_ACLYID}.sample;
sample_l=P.sensor{G.SENSOR.WL9_ACLYID}.sample;timestamp_l=P.sensor{G.SENSOR.WL9_ACLYID}.timestamp;
sample_r=P.sensor{G.SENSOR.WR9_ACLYID}.sample;timestamp_r=P.sensor{G.SENSOR.WR9_ACLYID}.timestamp;
count=0;
figure;hold on;
title(['pid= ' pid ' sid=' sid]);
plot(P.sensor{G.SENSOR.WL9_ACLYID}.timestamp,P.sensor{G.SENSOR.WL9_ACLYID}.sample,'b-');plot(xlim,[0,0],'r-');
%plot(P.sensor{G.SENSOR.WL9_ACLXID}.timestamp,P.sensor{G.SENSOR.WL9_ACLXID}.sample+5000,'g-');plot(xlim,[0,0]+5000,'r-');

%plot(P.sensor{G.SENSOR.WL9_ACLZID}.timestamp,P.sensor{G.SENSOR.WL9_ACLZID}.sample+10000,'r-');plot(xlim,[0,0]+10000,'b-');


hold on;
plot(xlim,[0,0],'r-');
vl=smooth(P.sensor{G.SENSOR.WL9_ACLYID}.sample,19601,'moving');
plot(P.sensor{G.SENSOR.WL9_ACLYID}.timestamp,vl,'k-','linewidth',3);


plot(P.sensor{G.SENSOR.WR9_ACLYID}.timestamp,P.sensor{G.SENSOR.WR9_ACLYID}.sample+5000,'b-');plot(xlim,[0,0]+5000,'r-');
%plot(P.sensor{G.SENSOR.WR9_ACLXID}.timestamp,P.sensor{G.SENSOR.WR9_ACLXID}.sample+20000,'g-');plot(xlim,[0,0]+20000,'r-');
%plot(P.sensor{G.SENSOR.WR9_ACLZID}.timestamp,P.sensor{G.SENSOR.WR9_ACLZID}.sample+25000,'r-');plot(xlim,[0,0]+25000,'b-');



plot(P.sensor{G.SENSOR.WR9_ACLYID}.timestamp,P.sensor{G.SENSOR.WR9_ACLYID}.sample+5000,'b-');
plot(xlim,[0,0]+5000,'r-');
vr=smooth(P.sensor{G.SENSOR.WR9_ACLYID}.sample,19601,'moving');
plot(P.sensor{G.SENSOR.WR9_ACLYID}.timestamp,vr+5000,'k-','linewidth',3);
%plot(P.wrist{1}.timestamp,P.wrist{1}.pitch*10+8000,'k-');plot(xlim,[8000,8000],'r-');
%plot(P.wrist{1}.timestamp,P.wrist{1}.roll*10+10000,'g-');plot(xlim,[10000,10000],'r-');
%plot(P.wrist{2}.timestamp,P.wrist{2}.pitch*10+12000,'k-');plot(xlim,[12000,12000],'r-');
%plot(P.wrist{2}.timestamp,P.wrist{2}.roll*10+14000,'g-');plot(xlim,[14000,14000],'r-');

return;
count=0;
for t=timestamp_l(1):1000:timestamp_l(end)
    stime=t-10*60*1000;etime=t+10*60*1000;
    [al,bl]=binarysearch(timestamp_l,stime,etime);
    rl=length(find(sample_l(al:bl)>700));
    ll=length(find(sample_l(al:bl)<-700));
    [ar,br]=binarysearch(timestamp_r,stime,etime);
    rr=length(find(sample_r(ar:br)>700));
    lr=length(find(sample_r(ar:br)<-700));
    if (rl>ll+50 && rr>lr+50), 
        count=count+1;fprintf('%d\n',count);
    end
end

%vl=smooth(P.sensor{G.SENSOR.WL9_ACLXID}.sample,9601,'moving');
%vr=smooth(P.sensor{G.SENSOR.WR9_ACLXID}.sample,9601,'moving');

%plot_fig(G,P,pid,sid,vl,vr);

P=rev_xy(G,P,G.SENSOR.WL9_ACLXID,[G.SENSOR.WL9_ACLXID,G.SENSOR.WL9_ACLYID]);
P=rev_xy(G,P,G.SENSOR.WR9_ACLXID,[G.SENSOR.WR9_ACLXID,G.SENSOR.WR9_ACLYID]);

%vl=smooth(P.sensor{G.SENSOR.WL9_ACLXID}.sample,9601,'moving');
%vr=smooth(P.sensor{G.SENSOR.WR9_ACLXID}.sample,9601,'moving');

%plot_fig(G,P,pid,sid,vl,vr);

%P.sensor{G.SENSOR.WL9_ACLXID}.sample(ind)=-P.sensor{G.SENSOR.WL9_ACLXID}.sample(ind);



end
function P=rev_xy(G,P,xid,ids)
v=smooth(P.sensor{xid}.sample,9601,'moving');
ind=find(v<0);
ind2=find(diff(ind)>1);
for i=1:length(ind2)
    if i==1, sx=ind(1);else, sx=ind(ind2(i-1)+1);end
    if i==length(ind2), ex=ind(end); else ex=ind(ind2(i));end;
    stime=P.sensor{xid}.timestamp(sx);
    etime=P.sensor{xid}.timestamp(ex);
    if (etime-stime)/(1000*60)<1000*60*10, continue;end;
    for id=ids
        [a,b]=binarysearch(P.sensor{id}.timestamp,stime,etime);
        P.sensor{id}.sample(a:b)=-P.sensor{id}.sample(a:b);
    end

%    hold on; plot(P.sensor{xid}.matlabtime(sx:ex),0,'g-','linewidth',4);
end
end
function plot_fig(G,P,pid,sid,vl,vr)
figure;hold on;
title(['pid=' pid ' sid=' sid]);
offset=0;
plot(P.sensor{G.SENSOR.WL9_ACLXID}.matlabtime,P.sensor{G.SENSOR.WL9_ACLXID}.sample+offset,'b-');
plot(P.sensor{G.SENSOR.WL9_ACLXID}.matlabtime,vl+offset,'k-','linewidth',3);
plot(xlim,[0,0]+offset,'r-');

offset=offset+2000;
plot(P.sensor{G.SENSOR.WR9_ACLXID}.matlabtime,P.sensor{G.SENSOR.WR9_ACLXID}.sample+offset,'b-');
plot(P.sensor{G.SENSOR.WR9_ACLXID}.matlabtime,vr+offset,'k-','linewidth',3);
plot(xlim,[0,0]+offset,'r-');
dynamicDateTicks
fprintf('HL: negative=%d HR: negative=%d\n',length(find(vl<0)),length(find(vr<0)));
end