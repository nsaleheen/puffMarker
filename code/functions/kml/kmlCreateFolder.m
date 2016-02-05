function [ ret ] = kmlCreateFolder( fpOut, folderName, open )
    % open = 1 or 0
    try
        fprintf(fpOut, '<Folder>\n');
        fprintf(fpOut, '<name>%s</name>\n<open>%d</open>\n', folderName, open);
        ret = true;
    catch e
        disp(['Error : ' e.message]);
        ret = false;
    end
end
