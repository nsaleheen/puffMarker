function Hand=generate_orientation_data(G,P,time)
%fprintf('...generate_orientation_data');
IDS{1}=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID;
IDS{2}=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID;
for i=1:2
    X=[];Y=[];Z=[];timestamp=[];valid=[];
    for t=min(P.sensor{IDS{1}(1)}.timestamp(1),P.sensor{IDS{2}(1)}.timestamp(1)):30*1000:max(P.sensor{IDS{1}(1)}.timestamp(end),P.sensor{IDS{2}(1)}.timestamp(end))
        now=0;
        mn(1:3)=0;
        v=0;
        %        [a,b]=binarysearch(P.sensor{1}.timestamp,t-time/2,t+time/2);
        %        ind=a:b;if isempty(ind), continue;end; if length(ind)<0.50*(time/1000)*21.33, continue;end;
        for id=IDS{i}
            [a,b]=binarysearch(P.sensor{id}.timestamp,t-time/2,t+time/2);
            ind=a:b;
            %            if isempty(ind),continue;end;
            %            if length(ind)<0.50*(time/1000)*16, continue;end
            now=now+1;
            if isempty(ind) || length(ind)<0.5*(time/1000)*16,
                mn(now)=inf;
                v=1;
            else
                mn(now)=median(P.sensor{id}.sample(ind));
            end
        end
        X(end+1)=mn(1);Y(end+1)=mn(2);Z(end+1)=mn(3);
        timestamp(end+1)=t;
        valid(end+1)=v;
    end
    [Hand(i,1).roll,Hand(i,1).pitch]=calculate_roll_pitch_new(X,Y,Z);
    [Hand(i,2).roll,Hand(i,2).pitch]=calculate_roll_pitch_new(-X,-Y,Z); % change orientation
    Hand(i,1).timestamp=timestamp;    Hand(i,2).timestamp=timestamp;
    Hand(i,1).valid=valid;    Hand(i,2).valid=valid;
end
