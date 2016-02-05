function [ episodes ] = get_episodes( values )

    episodes = zeros(0,2);
    episodeIndex = 1;
    startIndex=-1;
    for i=1:numel(values)
        if values(i)==1
            if startIndex == -1
                startIndex = i;
            end
            if i == numel(values)
                episodes(episodeIndex,:) = [startIndex, i];
                episodeIndex = episodeIndex+1;
                startIndex = -1;
            end
        else
            if startIndex ~= -1
                if values(i)==0 || i==numel(values)
                    episodes(episodeIndex,:) = [startIndex, i-1];
                    episodeIndex = episodeIndex+1;
                    startIndex = -1;
                end
            end
        end
    end

end

