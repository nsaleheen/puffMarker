function Hands=correct_orientation4_rollpitch(G,P,Hands,times)
fprintf('...correct_orientation');
IDS{1}=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID;
IDS{2}=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID;
for d=1:length(times)
    for i=1:2
        time=times(d);
        X=[];Y=[];Z=[];
        for t=P.sensor{IDS{i}(1)}.timestamp(1)+5*60*1000:60*1000:P.sensor{IDS{i}(1)}.timestamp(end)-5*60*1000
            now=0;
            mn(1:3)=0;
            [a,b]=binarysearch(P.sensor{1}.timestamp,t-time/2,t+time/2);
            ind=a:b;if isempty(ind), continue;end; if length(ind)<0.50*(time/1000)*21.33, continue;end;
            for id=IDS{i}
                [a,b]=binarysearch(P.sensor{id}.timestamp,t-time/2,t+time/2);
                ind=a:b;
                if isempty(ind),continue;end;
                if length(ind)<0.50*(time/1000)*16, continue;end
                
                now=now+1;
                mn(now)=mean(P.sensor{id}.sample(ind));
            end
            if now==3
                X(end+1)=mn(1);Y(end+1)=mn(2);Z(end+1)=mn(3);
            end
        end
        [roll,pitch]=calculate_roll_pitch_new(X,Y,Z);
        Hands{i}{d}.roll=[Hands{i}{d}.roll, roll];
        Hands{i}{d}.pitch=[Hands{i}{d}.pitch, pitch];
    end
%     figure;
%     title([pid ' ' sid ' ' num2str(time/1000)]);
% scatter(Hand{1}{1}.roll,Hand{1}{1}.pitch,'b.')
% hold on;scatter(Hand{1}{2}.roll,Hand{1}{2}.pitch,'r.')
% hold on;scatter(Hand{2}{1}.roll,Hand{2}{1}.pitch,'g.')
% hold on;scatter(Hand{2}{2}.roll,Hand{2}{2}.pitch,'m.')
% hold on;scatter(Hand{2}{2}.roll,Hand{2}{2}.pitch,'m.')
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
offset=offset+2000;
plot(P.sensor{1}.matlabtime,P.sensor{1}.sample_new+offset,'k-');
dynamicDateTicks
fprintf('HL: negative=%d HR: negative=%d\n',length(find(vl<0)),length(find(vr<0)));
end