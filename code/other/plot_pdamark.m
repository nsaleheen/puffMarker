function coc=plot_pdamark(G,pid,sid)
coc=0;
indir=[G.DIR.DATA G.DIR.SEP 'segment'];
infile=[pid '_' sid '_segment.mat'];
load([indir G.DIR.SEP infile]);
data=P;
if isempty(data), return;end;
if ~isfield(data,'pdamark') || isempty(data.pdamark), return; end;
for l=1:length(data.pdamark.matlabtime)
    hold on;
%    plot([data.pdamark.matlabtime(l),data.pdamark.matlabtime(l)],ylim,'k-','LineWidth',2);
    plot([data.pdamark.matlabtime(l),data.pdamark.matlabtime(l)],ylim,'m-','LineWidth',2);
    
    hold on;
    tx=['(' data.pdamark.actualusage {l} ')'];
    text(data.pdamark.matlabtime(l), 600  , tx, 'Color', 'k','FontSize',18,'Rotation',90);
    str=lower(data.pdamark.drugname{1});
    ind=findstr(str,'coc');
    if ~isempty(ind), coc=1;end;
%    text(data.pdamark.matlabtime(l)+3/(60*24), 1000  , 'Cocaine (100 mg) 40 Minutes ago', 'Color', 'k','FontSize',18,'Rotation',90);
end
end
