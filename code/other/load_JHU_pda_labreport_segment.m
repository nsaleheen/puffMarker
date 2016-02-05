function load_JHU_pda_labreport_segment(G,pid,sid)

indir=[G.DIR.DATA G.DIR.SEP 'segment'];infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end
load([indir G.DIR.SEP infile]);
indir=[G.DIR.DATA G.DIR.SEP 'formattedraw'];infile=[pid '_' sid '_frmtraw.mat'];
load([indir G.DIR.SEP infile]);

if isfield(R,'adminmark'),
    P.adminmark=R.adminmark;
else
    P.adminmark=[];
end
if isfield(R,'pdamark')
    P.pdamark=R.pdamark;
else P.pdamark=[];
end;

save([indir G.DIR.SEP infile],'P');

end
