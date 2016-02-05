function [ episodes_merged ] = get_episodes_merged( xValues, yValues, xDiffAcceptable )
    episodes = get_episodes( yValues );
    [rowCount, colCount] = size(episodes);
    j=1;
    episodes_merged = [];
    for i=1:rowCount
        if i==1
            episodes_merged(j,1) = episodes(i,1);
            episodes_merged(j,2) = episodes(i,2);
            j=j+1;
            continue;
        end
        if (xValues(episodes(i,1)) - xValues(episodes_merged(j-1,2))) <= xDiffAcceptable
            episodes_merged(j-1,2) = episodes(i,2);
        else
            episodes_merged(j,1) = episodes(i,1);
            episodes_merged(j,2) = episodes(i,2);
            j=j+1;
        end
    end
end

