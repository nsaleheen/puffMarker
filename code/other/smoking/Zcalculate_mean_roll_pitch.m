function R=calculate_mean_roll_pitch(G, pid,sid,episode,INDIR,R)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
if ~isfield(R,'pid'), R.pid=[];R.sid=[];R.episode=[];R.puff=[];R.hand=[];R.pitch=[];R.roll=[];end;
if ~isfield(P.smoking_episode{episode},'hand'), return;end;
if P.smoking_episode{episode}.hand=='L', ID=1;segind=P.smoking_episode{episode}.puff.seg_L_ind;else ID=2;segind=P.smoking_episode{episode}.puff.seg_R_ind;end

for s=1:length(segind)
    if segind(s)==-1, continue;end;
    R.pid=[R.pid, str2num(pid(2:end))];    R.sid=[R.sid, str2num(sid(2:end))];    R.episode=[R.episode, episode]; R.puff=[R.puff, s];
    R.hand=[R.hand, P.smoking_episode{episode}.hand];
    
    s1=P.wrist{ID}.magnitude.segment(segind(s));
    s2=P.wrist{ID}.magnitude.segment(segind(s)+1);
    stime=P.wrist{ID}.magnitude.timestamp(s1);
    etime=P.wrist{ID}.magnitude.timestamp(s2);
    ind=find(P.wrist{ID}.pitch.timestamp>=stime & P.wrist{ID}.pitch.timestamp<=etime);
    R.pitch=[R.pitch, median(P.wrist{ID}.pitch.sample(ind))];
    R.roll=[R.roll, median(P.wrist{ID}.roll.sample(ind))];
end
end