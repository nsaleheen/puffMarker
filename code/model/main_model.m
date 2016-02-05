function main_model(G,pid,sid,INDIR,OUTDIR)
G
pid
sid
INDIR
OUTDIR
pause
fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_model');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FEATURE_MATNAME];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' G.FILE.MODEL_MATNAME];

load([indir G.DIR.SEP infile]);
if isempty(dir([outdir G.DIR.SEP outfile])) || G.RUN.MODEL.LOADDATA==0, D=R;
else load([outdir G.DIR.SEP outfile]);end

libsvm_gen_test(G,F);
createtestparam(pid,sid);
run_session(pid,sid);
end
