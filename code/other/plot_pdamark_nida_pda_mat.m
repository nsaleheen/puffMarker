function coc=plot_pdamark_nida_pda_mat(G,pid,sid)
coc=0;
data=findfile_pid_sid_dir(G,pid,sid,INDIR);
if isempty(data), return;end;
if ~isfield(data,'pdamark') || isempty(data.pdamark), return; end;
for l=1:length(data.pdamark.matlabtime)
    hold on;
%    plot([data.pdamark.matlabtime(l),data.pdamark.matlabtime(l)],ylim,'k-','LineWidth',2);
    plot([data.pdamark.matlabtime(l),data.pdamark.matlabtime(l)],ylim,'k-','LineWidth',2);
    
    hold on;
    tx=['Cocaine (100 mg): More than 30 minutes ago ' char(10) '(Actual time 80 minutes ago)'];
    text(data.pdamark.matlabtime(l)+3/(60*24), 600  , tx, 'Color', 'k','FontSize',18,'Rotation',90);
    str=lower(data.pdamark.drugname{1});
    ind=findstr(str,'coc');
    if ~isempty(ind), coc=1;end;
%    text(data.pdamark.matlabtime(l)+3/(60*24), 1000  , 'Cocaine (100 mg) 40 Minutes ago', 'Color', 'k','FontSize',18,'Rotation',90);
end
end
