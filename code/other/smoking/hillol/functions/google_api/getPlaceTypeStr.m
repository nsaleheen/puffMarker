function placeTypeStr = getPlaceTypeStr( placeTypeId )

fp=fopen('google_api_place_type.csv', 'r');
typeMap = textscan(fp, '%d,%s');
fclose(fp);

typeIdArr = typeMap{1};
typeStrArr = typeMap{2};

placeTypeStr = typeStrArr(find(typeIdArr==placeTypeId));




end

