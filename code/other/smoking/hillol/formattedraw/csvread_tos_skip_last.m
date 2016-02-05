function csvM = csvread_tos_skip_last(filePath)

fp = fopen(filePath, 'r');
csv = textscan(fp, '%d64 %d64 %d64 %d64 %d64 %d64 %d64', 'Delimiter', ',');
fclose(fp);

maxCount = length(csv{1});

csvM = [];
rowCount = maxCount-1;

for col=1:length(csv)
    tmp = csv{col};
    csvM(:,col) = tmp(1:rowCount);
end




end

