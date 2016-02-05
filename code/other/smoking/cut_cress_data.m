function cut_cress_data(G,pid,sid,OUTDIR)
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
infile=[pid '_' sid '_preprocess.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
B=P;
if isfield(B.cress,'episode')~=1,return;end;
for c=1:length(B.cress.episode)
    C=[];
    sm_time=B.cress.episode{c}.startmatlabtime-(5*60)/(24*60*60);
    em_time=B.cress.episode{c}.endmatlabtime+(5*60)/(24*60*60);
    C.cress=B.cress.episode{c};
    for s=[G.SENSOR.R_RIPID, G.SENSOR.WL9_ACLYID, G.SENSOR.WR9_ACLYID]
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
