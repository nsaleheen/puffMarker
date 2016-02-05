function P = filter_segment_acl_gyr( G,P,RP )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for i=1:2
    acl_startmatlabtime = P.wrist{i}.acl.segment.startmatlabtime;
    acl_endmatlabtime = P.wrist{i}.acl.segment.endmatlabtime;

    gyr_startmatlabtime = P.wrist{i}.gyr.segment.startmatlabtime;
    gyr_endmatlabtime = P.wrist{i}.gyr.segment.endmatlabtime;
    
    validRP = ones(1,length(P.wrist{i}.gyr.segment.starttimestamp));% P.wrist{i}.gyr.segment.valid_rp;
    P.wrist{i}.gyr.segment.valid_acl_gyr=ones(1,length(P.wrist{i}.gyr.segment.starttimestamp));
    cnt=0;
    for gIndex=find(P.wrist{i}.gyr.segment.valid_length==0 & P.wrist{i}.gyr.segment.valid_height==0 & P.wrist{i}.gyr.segment.valid_rp==0)
%         if P.wrist{i}.gyr.segment.valid_rp(gIndex) ~=0 
%             continue;
%         end
cnt=cnt+1;
       gS = P.wrist{i}.gyr.segment.startmatlabtime(gIndex);
       gE= P.wrist{i}.gyr.segment.endmatlabtime(gIndex);       
       for aIndex=1:length(P.wrist{i}.acl.segment.startmatlabtime)
           if P.wrist{i}.acl.segment.endtimestamp - P.wrist{i}.acl.segment.starttimestamp > 12000
               continue;
           end
           aS=P.wrist{i}.acl.segment.startmatlabtime(aIndex);
           aE=P.wrist{i}.acl.segment.endmatlabtime(aIndex);
           if(max(aS, gS)<min(aE, gE))
               overlapSegLen = min(aE, gE)-max(aS, gS);
               if((gE-gS)*0.70 <= overlapSegLen)
                   validRP(gIndex)=0;
                   P.wrist{i}.gyr.segment.valid_acl_gyr(gIndex)=0;
                   break;
               end
           end       
       end
    end
    pvl = length(find(P.wrist{i}.gyr.segment.valid_rp==0));
    nvl = length(find(validRP==0));
    fprintf('%d acl_seg:%d; gyr_seg:%d; prevalid : %d, nowValid : %d\n',i,length(P.wrist{i}.acl.segment.startmatlabtime), length(P.wrist{i}.gyr.segment.startmatlabtime), cnt, nvl);
       
end
   
   end

