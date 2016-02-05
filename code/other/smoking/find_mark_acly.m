function find_mark_acly(G, pid,sid,episode,INDIR)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
distL=0;distR=0;seg_L_ind=[];seg_R_ind=[];
for p=1:length(P.smoking_episode{episode}.puff.timestamp)
    [segind,dist]=find_segment(G,P,G.SENSOR.WL9_ACLYID,P.smoking_episode{episode}.puff.timestamp(p));
    distL=distL+dist;seg_L_ind=[seg_L_ind,segind];
    [segind,dist]=find_segment(G,P,G.SENSOR.WR9_ACLYID,P.smoking_episode{episode}.puff.timestamp(p));
    distR=distR+dist;seg_R_ind=[seg_R_ind,segind];
end
P.smoking_episode{episode}.puff.seg_L_ind=seg_L_ind;
P.smoking_episode{episode}.puff.seg_R_ind=seg_R_ind;
if distL<distR
     P.smoking_episode{episode}.hand='L';
else
     P.smoking_episode{episode}.hand='R';
end    
outdir=indir;outfile=infile;
if isempty(dir(outdir)),    mkdir(outdir);end
save([outdir G.DIR.SEP outfile],'P');
end

function [segid,dist]=find_segment(G,P,SENSORID,marktime)
segid=-1;dist=inf;
if isempty(P.sensor{SENSORID}.segment), return;end;
seg=P.sensor{SENSORID}.segment(1:2:end);
[dist,pos1]=min(abs(P.sensor{SENSORID}.timestamp(seg)-marktime));
segid=find(P.sensor{SENSORID}.segment==seg(pos1));
end
