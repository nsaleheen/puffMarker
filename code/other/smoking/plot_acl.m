function plot_acl(G,data,IDS,hand_acl,segment,segment_gyr_acl)

for i=IDS
    if i==1, id=G.SENSOR.WL9_ACLYID;else, id=G.SENSOR.WR9_ACLYID;end;
    hold on;
    if ~isfield(data.wrist{i},'acl'), data.wrist{i}.acl=data.sensor{id};end;
    maxv=max(data.wrist{i}.acl.sample);
    y=ylim;
    offset=y(1)-maxv;
    
    plot(data.wrist{i}.acl.matlabtime,data.wrist{i}.acl.sample+offset,'g.');
%    plot(xlim,[data.wrist{i}.acl.threshold,data.wrist{i}.acl.threshold]+offset,'k-');
    if segment==1
        for s=1:length(data.wrist{i}.acl.segment.starttimestamp)
%            if data.wrist{i}.acl.segment.valid(s)>0, continue;end;
            stime=data.wrist{i}.acl.segment.startmatlabtime(s);
            etime=data.wrist{i}.acl.segment.endmatlabtime(s);
            tind=find(data.wrist{i}.acl.matlabtime>=stime & data.wrist{i}.acl.matlabtime<=etime);
%            if data.wrist{i}.acl.segment.valid(s)==0,
                plot(data.wrist{i}.acl.matlabtime(tind),data.wrist{i}.acl.sample(tind)+offset,'k-','linewidth',3);
%            else
%                plot(data.wrist{i}.acl.matlabtime(tind),data.wrist{i}.acl.sample(tind)+offset,'c-','linewidth',3);
%            end
        end
    end
    if segment_gyr_acl==1
        for s=1:length(data.wrist{i}.gyr.segment.starttimestamp)
            stime=data.wrist{i}.gyr.segment.startmatlabtime(s);
            etime=data.wrist{i}.gyr.segment.endmatlabtime(s);
            if data.wrist{i}.gyr.segment.valid_all(s)==1, plot([stime,etime],[offset+100,offset+100],'c-','linewidth',2);
            elseif data.wrist{i}.gyr.segment.valid_all(s)==2, plot([stime,etime],[offset+140,offset+140],'k-','linewidth',2);
            elseif data.wrist{i}.gyr.segment.valid_all(s)==3, plot([stime,etime],[offset+140,offset+140],'k-','linewidth',2);
                
            elseif data.wrist{i}.gyr.segment.valid_all(s)==4, plot([stime,etime],[offset+180,offset+180],'b-','linewidth',2);
            elseif data.wrist{i}.gyr.segment.valid_all(s)==0, plot([stime,etime],[offset+200,offset+200],'r-','linewidth',2);
            end
        end
    end
    
    if hand_acl==1,
        for e=1:length(data.smoking_episode)
            if isempty(data.smoking_episode{e}.puff), continue;end;
            if data.smoking_episode{e}.puff.acl.id~=i, continue;end;
            for p=1:length(data.smoking_episode{e}.puff.acl.starttimestamp)
                if data.smoking_episode{e}.puff.acl.valid(p)~=0, continue;end;
                stime=data.smoking_episode{e}.puff.acl.startmatlabtime(p);
                etime=data.smoking_episode{e}.puff.acl.endmatlabtime(p);
                tind=find(data.wrist{i}.acl.matlabtime>=stime & data.wrist{i}.acl.matlabtime<=etime);
%                if data.smoking_episode{e}.puff.acl.missing(p)~=0
%                    plot(data.wrist{i}.acl.matlabtime(tind),data.wrist{i}.acl.sample(tind)+offset,'c-','linewidth',3);
%                else
%                if data.wrist{i}.acl.segment.missing(p)==0
                    plot(data.wrist{i}.acl.matlabtime(tind),data.wrist{i}.acl.sample(tind)+offset,'r-','linewidth',3);
                
 %               end
            end
        end
    end
    
end
