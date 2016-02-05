function [ ret ] = kmlWriteFooter( fpOut )
    try
        skeletonPath = 'skleton_kml.txt';
        skeletonKml = getFileContent(skeletonPath);
        skeletonKmlParts = regexp(skeletonKml,'#PUT_CONTENT_HERE#', 'split');
        %skeletonKmlHeader = char(skeletonKmlParts(1));
        skeletonKmlFooter = char(skeletonKmlParts(2));

        fprintf(fpOut, '%s', skeletonKmlFooter);

        ret = true;
    catch e
        disp(['Error : ' e.message]);
        ret = false;
    end
end