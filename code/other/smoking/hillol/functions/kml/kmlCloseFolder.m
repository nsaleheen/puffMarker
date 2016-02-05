function [ ret ] = kmlCloseFolder( fpOut)
    try
        fprintf(fpOut, '</Folder>\n');
        ret = true;
    catch e
        disp(['Error : ' e.message]);
        ret = false;
    end
end
