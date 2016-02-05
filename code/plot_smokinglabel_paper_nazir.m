function plot_smokinglabel_paper_nazir(G,data)
if isfield(data,'smoking_episode')~=1, return;end;
 
for i=1:length(data.smoking_episode)
    hold on;
    plot([data.smoking_episode{i}.startmatlabtime,data.smoking_episode{i}.startmatlabtime],ylim,'k-','linewidth',2);
    plot([data.smoking_episode{i}.endmatlabtime,data.smoking_episode{i}.endmatlabtime],ylim,'k-','linewidth',2);
    
    text(data.smoking_episode{i}.startmatlabtime, 0  , ['Smoking ' num2str(i) ' : Start'], 'Color', 'k','FontSize',18,'Rotation',90);            
    text(data.smoking_episode{i}.endmatlabtime, 0  , ['Smoking ' num2str(i) ' : End'], 'Color', 'k','FontSize',18,'Rotation',90);            
    if isfield(data.smoking_episode{i},'puff')~=1 || isfield(data.smoking_episode{i}.puff,'matlabtime')~=1, continue;end;
    for j=1:length(data.smoking_episode{i}.puff.matlabtime)

            plot([data.smoking_episode{i}.puff.matlabtime(j),data.smoking_episode{i}.puff.matlabtime(j)],ylim,'k:','linewidth',2);
            text(data.smoking_episode{i}.puff.matlabtime(j), 500  , 'Puff ', 'Color', 'k','FontSize',24,'Rotation',90);     
    end
end
end
