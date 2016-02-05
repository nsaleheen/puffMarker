function mark=plot_adminmark(G,pid,sid,INDIR,ylim,txtpos)
mark=0;
indir=[G.DIR.DATA G.DIR.SEP 'segment'];
infile=[pid '_' sid '_segment.mat'];
load([indir G.DIR.SEP infile]);
if ~isfield(P,'adminmark'),return;end;
if isempty(P.adminmark),return;end;

for l=2:length(P.adminmark.timestamp)
    hold on;
    mark=1;
    plot([P.adminmark.matlabtime(l),P.adminmark.matlabtime(l)],ylim,'k--','LineWidth',2);
    hold on;
    text(P.adminmark.matlabtime(l)+3/(24*60),txtpos  , [ 'Cocaine (' num2str(P.adminmark.dose(l)) 'mg)' ], 'Color', 'k','FontSize',20,'Rotation',90);
end
end
