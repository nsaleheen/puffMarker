function [total,incorrect]=correct_orientation2(G,P,pid,sid)
fprintf('...correct_orientation');
now=0;
total=zeros(2,40);incorrect=total;
PP=P;
%vl=smooth(P.sensor{G.SENSOR.WL9_ACLXID}.sample,9601,'moving');
%vr=smooth(P.sensor{G.SENSOR.WR9_ACLXID}.sample,9601,'moving');

%plot_fig(G,P,pid,sid,vl,vr);
%return;

for i=[G.SENSOR.WL9_ACLXID,G.SENSOR.WR9_ACLXID]
    now=now+1;
    ind_all=[];
    P=PP;
    vm=smooth(P.wrist{now}.magnitude,961,'moving');
    vmind=find(vm<=10);
    for j=1:length(vmind)
        time=P.wrist{now}.timestamp(vmind(j));
        stime=time-60*1000;
        etime=time+60*1000;
        [a,b]=binarysearch(P.sensor{i}.timestamp,stime,etime);
        ind_all=[ind_all,a:b];
    end
    P.sensor{i}.timestamp(ind_all)=[];
    P.sensor{i}.sample(ind_all)=[];
    P.sensor{i}.matlabtime(ind_all)=[];
    
    
    % vl=smooth(P.sensor{G.SENSOR.WL9_ACLXID}.sample,9601,'moving');
    % vr=smooth(P.sensor{G.SENSOR.WR9_ACLXID}.sample,9601,'moving');
    %
    % plot_fig(G,P,pid,sid,vl,vr);
    % return;
    % for i=1:2
    for d=1:40
        disp(d)
        time=d*30*1000;
        for t=P.sensor{i}.timestamp(1):1000:P.sensor{i}.timestamp(end)
            [a,b]=binarysearch(P.sensor{i}.timestamp,t-time/2,t+time/2);
            ind=a:b;
            if isempty(ind),continue;end;
            if length(ind)<0.50*(time/1000)*16, continue;end
            total(now,d)=total(now,d)+1;
            if mean(P.sensor{i}.sample(ind))<0
                incorrect(now,d)=incorrect(now,d)+1;
            end
        end
    end
end
return;
vl=smooth(P.sensor{G.SENSOR.WL9_ACLXID}.sample,9601,'moving');
vr=smooth(P.sensor{G.SENSOR.WR9_ACLXID}.sample,9601,'moving');

plot_fig(G,P,pid,sid,vl,vr);

%P=rev_xy(G,P,G.SENSOR.WL9_ACLXID,[G.SENSOR.WL9_ACLXID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_GYRXID,G.SENSOR.WL9_GYRYID]);
%P=rev_xy(G,P,G.SENSOR.WR9_ACLXID,[G.SENSOR.WR9_ACLXID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_GYRXID,G.SENSOR.WR9_GYRYID]);

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
plot(P.sensor{G.SENSOR.WL9_ACLXID}.matlabtime,P.sensor{G.SENSOR.WL9_ACLXID}.sample+offset,'b.');
plot(P.sensor{G.SENSOR.WL9_ACLXID}.matlabtime,vl+offset,'k-','linewidth',3);
plot(xlim,[0,0]+offset,'r-');
vm=smooth(P.wrist{1}.magnitude,16*60*1,'moving');
ind=find(vm<=10);
plot(P.wrist{1}.matlabtime(ind),vm(ind),'g.');

offset=offset+2000;
plot(P.sensor{G.SENSOR.WR9_ACLXID}.matlabtime,P.sensor{G.SENSOR.WR9_ACLXID}.sample+offset,'b.');
plot(P.sensor{G.SENSOR.WR9_ACLXID}.matlabtime,vr+offset,'k-','linewidth',3);
plot(xlim,[0,0]+offset,'r-');
vm=smooth(P.wrist{2}.magnitude,16*60*1,'moving');
ind=find(vm<=10);
plot(P.wrist{2}.matlabtime(ind),vm(ind)+offset,'g.');

dynamicDateTicks
fprintf('HL: negative=%d HR: negative=%d\n',length(find(vl<0)),length(find(vr<0)));
end