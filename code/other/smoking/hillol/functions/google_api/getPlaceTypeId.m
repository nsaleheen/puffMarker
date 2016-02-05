function placeTypeId = getPlaceTypeId( placeTypeStr )

fp=fopen('google_api_place_type.csv', 'r');
typeMap = textscan(fp, '%d,%s');
fclose(fp);

typeIdArr = typeMap{1};
typeStrArr = typeMap{2};

placeTypeId=-1;
for i=1:length(typeStrArr)
    if strcmp(typeStrArr(i), placeTypeStr)==1
        placeTypeId = typeIdArr(i);
    end
end



end

