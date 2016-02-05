function P=calculate_interpolate(G, P)
fprintf('...interpolate');
P=wrist_interpolate(G,P,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID);
P=wrist_interpolate(G,P,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID);
end

function P=wrist_interpolate(G,P, IDS)
starttimestamp=inf;
endtimestamp=-inf;
duration=1000/G.SENSOR.ID(IDS(1)).FREQ;
for id=IDS  
    starttimestamp=min(starttimestamp,P.sensor{id}.timestamp(1));
    endtimestamp=max(endtimestamp,P.sensor{id}.timestamp(end));
    
end
new_timestamp=starttimestamp:duration:endtimestamp;
new_matlabtime=convert_timestamp_matlabtimestamp(G,new_timestamp);
for id=IDS
    ddd=length(P.sensor{id}.timestamp) - length(unique(P.sensor{id}.timestamp))
    if ddd~=0
%         fprintf('.nnnnn');
        P.sensor{id}.timestamp=makeUniqueTimeStamp(P.sensor{id}.timestamp);
%         P.sensor{id}.timestamp=makeUniqueTimeStamp(P.sensor{id}.timestamp);
    end
    ddd1=length(P.sensor{id}.timestamp) - length(unique(P.sensor{id}.timestamp))
    P.sensor{id}.sample_interpolate=interp1(P.sensor{id}.timestamp,P.sensor{id}.sample,new_timestamp);
    P.sensor{id}.timestamp_interpolate=new_timestamp;
    P.sensor{id}.matlabtime_interpolate=new_matlabtime;
end
end

function a1=makeUniqueTimeStamp(aa)

    a1=aa;
    for i=2:length(aa)
        if(a1(i)<=a1(i-1))
            a1(i)=a1(i-1)+1;
        end
    end
end
