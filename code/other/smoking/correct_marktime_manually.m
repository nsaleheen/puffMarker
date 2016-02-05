function P=correct_marktime_manually(G,pid,sid,P)
if strcmp(pid,'p01')==1 && strcmp(sid,'s02')==1, 
    time=735804.666806;
    timestamp=convert_time_timestamp(G,datestr(time,G.TIME.FORMAT));
    P.smoking_episode{2}.puff.timestamp(1)=timestamp;
    P.smoking_episode{2}.puff.matlabtime(1)=convert_timestamp_matlabtimestamp(G,timestamp);
end;
if strcmp(pid,'p01')==1 && strcmp(sid,'s03')==1, 
    time=735805.597008;
    timestamp=convert_time_timestamp(G,datestr(time,G.TIME.FORMAT));
    P.smoking_episode{2}.puff.timestamp(1)=timestamp;
    P.smoking_episode{2}.puff.matlabtime(1)=convert_timestamp_matlabtimestamp(G,timestamp);
end;

if strcmp(pid,'p03')==1 && strcmp(sid,'s01')==1, 
    P.smoking_episode{3}.puff.timestamp(4)=1406676792693;P.smoking_episode{3}.puff.matlabtime(4)=convert_timestamp_matlabtimestamp(G,P.smoking_episode{3}.puff.timestamp(4));
end;
end
