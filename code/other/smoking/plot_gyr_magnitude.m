function plot_gyr_magnitude(G,data,IDS,hand_gyr,segment_gyr,segment_acl_gyr)
for i=IDS
    hold on;
    maxv=prctile(data.wrist{i}.magnitude,80);
    y=ylim;
    offset=y(1)-maxv;
    %    plot(data.wrist{i}.magnitude.matlabtime,data.wrist{i}.magnitude.sample+offset,'b-');
    %    y=smooth(data.wrist{i}.magnitude.sample);
    %    plot(data.wrist{i}.magnitude.matlabtime,y+offset,'r-');
    %    ss=data.wrist{i}.magnitude.sample;
    %    data.wrist{i}.magnitude.sample_filtered=s;
    
    plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude+offset,'g-');
    plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude_800+offset,'b-');
    plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude_8000+offset,'r-');
    
    plot(xlim,[50,50]+offset,'k--');
    plot(xlim,[0,0]+offset,'k-');
    
    %    plot(xlim,[data.wrist{i}.magnitude.threshold,data.wrist{i}.magnitude.threshold]+offset,'k-');
    if segment_gyr==1,
        for s=1:length(data.wrist{i}.gyr.segment.starttimestamp)
            stime=data.wrist{i}.gyr.segment.startmatlabtime(s);
            etime=data.wrist{i}.gyr.segment.endmatlabtime(s);
            
            if data.wrist{i}.gyr.segment.valid_height(s)>0, 
                plot([stime,etime],[offset-400,offset-400],'m-','linewidth',2);
            elseif data.wrist{i}.gyr.segment.valid_length(s)>0, 
                plot([stime,etime],[offset-500,offset-500],'g-','linewidth',2);
            elseif data.wrist{i}.gyr.segment.valid_rp(s)>0, 
                plot([stime,etime],[offset-600,offset-600],'c-','linewidth',2);
            elseif data.wrist{i}.gyr.segment.valid_all(s)==0
                plot([stime,etime],[offset-200,offset-200],'r-','linewidth',10);
            end
            if data.wrist{i}.gyr.segment.valid_all(s)==0
                plot([stime,etime],[offset-150,offset-150],'b-','linewidth',5);
            end
            
%            if data.wrist{i}.gyr.segment.valid_all(s)~=0,
%                continue;
%            end
                
        end
    end
    if hand_gyr==1,
        if isfield(data.wrist{i}.gyr.segment,'puff')==1,
            ind=find(data.wrist{i}.gyr.segment.puff==1);
            for j=1:length(ind)
                stime=data.wrist{i}.gyr.segment.startmatlabtime(ind(j));
                etime=data.wrist{i}.gyr.segment.endmatlabtime(ind(j));
                plot([stime,etime],[offset,offset],'r-','linewidth',10);
            end
        end
        
        %         for p=1:length(data.smoking_episode)
        %             if ~isfield(data.smoking_episode{p},'puff'), continue;end;
        %             if ~isfield(data.smoking_episode{p}.puff,'hand'), continue;end;
        %             if i==1 && data.smoking_episode{p}.puff.hand=='R', continue;end;
        %             if i==2 && data.smoking_episode{p}.puff.hand=='L', continue;end;
        %             seg=data.smoking_episode{p}.puff.seg_ind;
        %             for s=1:length(seg)
        %                 %                if data.wrist{i}.magnitude.valid(s)~=0, continue;end
        %                 if seg(s)==-1, continue;end;
        %                 stime=data.wrist{i}.gyr.segment.startmatlabtime(seg(s));
        %                 etime=data.wrist{i}.gyr.segment.endmatlabtime(seg(s));
        %                 plot([stime,etime],[offset,offset],'r-','linewidth',10);
        %             end
        %         end
    end
    if segment_acl_gyr==1,
        for e=1:length(data.smoking_episode)
            if isempty(data.smoking_episode{e}.puff), continue;end;
            if data.smoking_episode{e}.puff.acl.id~=i, continue;end;
            for p=1:length(data.smoking_episode{e}.puff.acl.starttimestamp)
                if data.smoking_episode{e}.puff.acl.starttimestamp(p)==-1, continue;end;
                stime=data.smoking_episode{e}.puff.acl.startmatlabtime(p);
                etime=data.smoking_episode{e}.puff.acl.endmatlabtime(p);
                tind=find(data.wrist{i}.magnitude.matlabtime>=stime & data.wrist{i}.magnitude.matlabtime<=etime);
                plot(data.wrist{i}.magnitude.matlabtime(tind),ss(tind)+offset,'r.','linewidth',3);
                %                if data.smoking_episode{e}.puff.acl.missing(p)==1,
                %                    plot(data.wrist{i}.magnitude.matlabtime(tind),ss(tind)+offset,'c-','linewidth',3);
            end
        end
    end
    
end
end
