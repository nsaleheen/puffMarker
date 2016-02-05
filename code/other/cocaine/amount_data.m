function minute=amount_data(G,pid,sid)
fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_window');
indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([indir G.DIR.SEP infile]);
minute=0;
for i=1:length(B.sensor{2}.quality.value)
    if B.sensor{2}.quality.value(i)==4, continue;end;
    minute=minute+(B.sensor{2}.quality.endtimestamp(i)-B.sensor{2}.quality.starttimestamp(i))/(1000*60);
end