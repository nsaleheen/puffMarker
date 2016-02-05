function cut_lab_data(G,pid,sid,OUTDIR)
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
infile=[pid '_' sid '_preprocess.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
B=P;

for c=1:length(B.smoking_episode)
    C=[];
    sm_time=B.smoking_episode{c}.startmatlabtime-(5*60)/(24*60*60);
    em_time=B.smoking_episode{c}.endmatlabtime+(5*60)/(24*60*60);
    C.smoking_episode=B.smoking_episode{c};
    C.smoking_episode.puff=[];
    for s=[G.SENSOR.R_RIPID, 26:31, 33:38]
        C.sensor{s}.NAME=B.sensor{s}.NAME;
        C.sensor{s}.METADATA=B.sensor{s}.METADATA;
        ind=find(B.sensor{s}.matlabtime>=sm_time & B.sensor{s}.matlabtime<=em_time);
        C.sensor{s}.sample=B.sensor{s}.sample(ind);
        C.sensor{s}.matlabtime=B.sensor{s}.matlabtime(ind);
        C.sensor{s}.timestamp=B.sensor{s}.timestamp(ind);
        if s==G.SENSOR.R_RIPID
            ind=find(B.sensor{s}.peakvalley.matlabtime>=sm_time & B.sensor{s}.peakvalley.matlabtime<=em_time);
            C.sensor{s}.METADATA='Valley Peak Valley Peak...';
            C.sensor{s}.peakvalley.sample=B.sensor{s}.peakvalley.sample(ind);
            C.sensor{s}.peakvalley.matlabtime=B.sensor{s}.peakvalley.matlabtime(ind);
            C.sensor{s}.peakvalley.timestamp=B.sensor{s}.peakvalley.timestamp(ind);
            C.smoking_episode.puff.ind_rip_valley=B.smoking_episode{c}.puff.ind_R_V-ind(1)+1;
        elseif s==G.SENSOR.WL9_ACLYID
            indu=B.smoking_episode{c}.puff.sind_WL;indd=B.smoking_episode{c}.puff.eind_WL;
            ind=[indu,indd];ind=sort(ind);
            ind1=find(ind>0);
            C.smoking_episode.puff.timestamp_handL=ones(1,length(ind))*-1;
            C.smoking_episode.puff.timestamp_handL(ind1)=B.sensor{G.SENSOR.WL9_ACLYID}.timestamp(ind(ind1));
            C.smoking_episode.puff.timestamp_handL(1:2:end)=C.smoking_episode.puff.timestamp_handL(1:2:end)-1000;
            C.smoking_episode.puff.timestamp_handL(2:2:end)=C.smoking_episode.puff.timestamp_handL(2:2:end)+500;
            C.smoking_episode.puff.timestamp_handL(C.smoking_episode.puff.timestamp_handL<1000)=-1;
        elseif s==G.SENSOR.WR9_ACLYID
            indu=B.smoking_episode{c}.puff.sind_WR;indd=B.smoking_episode{c}.puff.eind_WR;
            ind=[indu,indd];ind=sort(ind);
            ind1=find(ind>0);
            C.smoking_episode.puff.timestamp_handR=ones(1,length(ind))*-1;
            C.smoking_episode.puff.timestamp_handR(ind1)=B.sensor{G.SENSOR.WR9_ACLYID}.timestamp(ind(ind1));
            C.smoking_episode.puff.timestamp_handR(1:2:end)=C.smoking_episode.puff.timestamp_handR(1:2:end)-1000;
            C.smoking_episode.puff.timestamp_handR(2:2:end)=C.smoking_episode.puff.timestamp_handR(2:2:end)+500;
            C.smoking_episode.puff.timestamp_handR(C.smoking_episode.puff.timestamp_handR<1000)=-1;
        end
    end
    outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
    outfile=[pid '_' sid '_c' num2str(c) '_' OUTDIR '.mat']; 
    if isempty(dir(outdir))
        mkdir(outdir);
    end
    save([outdir G.DIR.SEP outfile],'C');
end
fprintf(') =>  done\n');
end
