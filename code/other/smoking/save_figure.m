function save_figure(G,data,pid,sid,OUTDIR,leftshift,rightshift,h)
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
if isempty(dir(outdir)),    mkdir(outdir); end

filename=[G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP pid '_' sid '.png'];
set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10]);
saveas(h,[filename '.fig']);
print('-dpng','-r100',filename);
save_selfreport(G,data,pid,sid,OUTDIR,leftshift,rightshift,h);
%save_cress(G,data,pid,sid,OUTDIR,leftshift,rightshift,h);
save_smokingepisode(G,data,pid,sid,OUTDIR,leftshift,rightshift,h);
end
function save_selfreport(G,data,pid,sid,OUTDIR,leftshift,rightshift,h)
if isfield(data,'selfreport')~=1, return;end;
s=[G.SELFREPORT.SMKID];
hold on;
for i=1:length(data.selfreport{s}.matlabtime)
    stime=data.selfreport{s}.matlabtime(i)-(leftshift/(24*60));
    etime=data.selfreport{s}.matlabtime(i)+(rightshift/(24*60));
    xlim([stime,etime]);
    filename=[G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP pid '_' sid '_selfreport_' num2str(i) '.png'];
    set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10])
    print('-dpng','-r100',filename);
%    saveas(h,[filename '.fig']);

end

end
function save_cress(G,data,pid,sid,OUTDIR,leftshift,rightshift,h)
if isfield(data,'cress')~=1, return;end;
if isfield(data.cress,'episode')~=1, return;end;
for i=1:length(data.cress.episode)
    stime=data.cress.episode{i}.startmatlabtime-(leftshift/(24*60));
    etime=data.cress.episode{i}.endmatlabtime+(rightshift/(24*60));
    xlim([stime,etime]);
    filename=[G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP pid '_' sid '_cress_' num2str(i) '.png'];
    set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10])
    print('-dpng','-r100',filename);
%    saveas(h,[filename '.fig']);

end
end

function save_smokingepisode(G,data,pid,sid,OUTDIR,leftshift,rightshift,h)
if isfield(data,'smoking_episode')~=1, return;end;
for i=1:length(data.smoking_episode)
    stime=data.smoking_episode{i}.startmatlabtime-(leftshift/(24*60));
    etime=data.smoking_episode{i}.endmatlabtime+(rightshift/(24*60));
    xlim([stime,etime]);
    filename=[G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP pid '_' sid '_smokingepisode_' num2str(i) '.png'];
    set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10])
    print('-dpng','-r100',filename);
%    saveas(h,[filename '.fig']);

end
end
