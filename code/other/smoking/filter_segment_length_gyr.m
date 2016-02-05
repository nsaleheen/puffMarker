function P=filter_segment_length_gyr(G,P,MINLIM,MAXLIM)


for i=1:2
      [P.wrist{i}.gyr.segment.valid_length, P.wrist{i}.gyr.segment.length_gyr]=filter_length(P.wrist{i},MINLIM,MAXLIM);
%     if i==1,
%         valid=filter_yaxis(P.wrist{i}.magnitude,P.sensor{G.SENSOR.WL9_ACLYID},valid);
%     else
%         valid=filter_yaxis(P.wrist{i}.magnitude,P.sensor{G.SENSOR.WR9_ACLYID},valid);        
%     end
end
end

function [valid,diff]=filter_length(wrist,minlen,maxlen)
valid=zeros(1,length(wrist.gyr.segment.starttimestamp));
diff=wrist.gyr.segment.endtimestamp-wrist.gyr.segment.starttimestamp;
valid(diff<minlen)=1;
valid(diff>maxlen)=2;
end
