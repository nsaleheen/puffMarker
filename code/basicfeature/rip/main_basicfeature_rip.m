function [peakvalleyold,peakvalleynew]=main_basicfeature_rip(G,sample,timestamp)
%feature=[];
fprintf('...RIP');
fprintf('...peak valley old');peakvalleyold=detect_peakvalley(G,sample,timestamp);
fprintf('...peak valley new');peakvalleynew=detect_peakvalley_v2(G,sample,timestamp);

if ~isempty(peakvalleynew.sample),
    if rem(length(peakvalleynew.sample),2)~=1, peakvalleynew.sample(end)=[];peakvalleynew.timestamp(end)=[];peakvalleynew.matlabtime(end)=[];end;
end
if ~isempty(peakvalleyold.sample)
    if rem(length(peakvalleyold.sample),2)~=1, peakvalleyold.sample(end)=[];peakvalleyold.timestamp(end)=[];peakvalleyold.matlabtime(end)=[];end;
end
%remove outlier based on plausible respiration duration in literature
%feature=removeOutlierRespiration(G,feature);
end

