function [timestamp, matlabtime] = get_first_selfreport_time( G,data )
if isfield(data,'selfreport')~=1, return;end;
list_selfreport=[G.SELFREPORT.SMKID];
timestamp = 0;
    matlabtime = 0;
    
for s=list_selfreport
    
    for i=1:length(data.selfreport{s}.matlabtime)
        if matlabtime == 0 | data.selfreport{s}.matlabtime(i) < matlabtime
            timestamp = data.selfreport{s}.timestamp(i);
            matlabtime = data.selfreport{s}.matlabtime(i);
        end
        
    end
end
