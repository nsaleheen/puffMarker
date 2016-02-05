function plot_smokinglabel(G,data)
if isfield(data,'smoking_episode')~=1, return;end;
ylimit=ylim;
for i=1:length(data.smoking_episode)
    hold on;
    plot([data.smoking_episode{i}.startmatlabtime,data.smoking_episode{i}.startmatlabtime],ylim,'k-','linewidth',2);
    plot([data.smoking_episode{i}.endmatlabtime,data.smoking_episode{i}.endmatlabtime],ylim,'k-','linewidth',2);
    text(data.smoking_episode{i}.startmatlabtime, 0  , ['Smoking ' num2str(i) ' : Start'], 'Color', 'k','FontSize',18,'Rotation',90);            
    text(data.smoking_episode{i}.endmatlabtime, 0  , ['Smoking ' num2str(i) ' : End'], 'Color', 'k','FontSize',18,'Rotation',90);            
    if isfield(data.smoking_episode{i},'puff')~=1 || isfield(data.smoking_episode{i}.puff,'matlabtime')~=1, continue;end;
    for j=1:length(data.smoking_episode{i}.puff.matlabtime)
        if ~isfield(data.smoking_episode{i}.puff,'acl') || ~isfield(data.smoking_episode{i}.puff.acl,'valid')
            plot([data.smoking_episode{i}.puff.matlabtime(j),data.smoking_episode{i}.puff.matlabtime(j)],ylim,'k--','linewidth',2);
            text(data.smoking_episode{i}.puff.matlabtime(j), ylimit(1)  , ['Puff ' num2str(j)], 'Color', 'k','FontSize',18,'Rotation',90);
        elseif data.smoking_episode{i}.puff.acl.valid(j)==0,
            plot([data.smoking_episode{i}.puff.matlabtime(j),data.smoking_episode{i}.puff.matlabtime(j)],ylim,'k--','linewidth',2);
            text(data.smoking_episode{i}.puff.matlabtime(j), ylimit(1)  , ['Puff ' num2str(j) ' (Miss=' num2str(data.smoking_episode{i}.puff.acl.missing(j)) ')'], 'Color', 'k','FontSize',18,'Rotation',90);     
        else
            plot([data.smoking_episode{i}.puff.matlabtime(j),data.smoking_episode{i}.puff.matlabtime(j)],ylim,'k:','linewidth',2);
            text(data.smoking_episode{i}.puff.matlabtime(j), ylimit(1)  , ['Puff ' num2str(j) ' (Miss=' num2str(data.smoking_episode{i}.puff.acl.missing(j)) ')'], 'Color', 'k','FontSize',18,'Rotation',90);     
        end
    end
end
end
