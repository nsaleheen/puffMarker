clear;
%a=getPlaceTypeId('car_repair');
%a=getPlaceTypeStr(0);


%{
lat = 35.111989;
lon = -89.946395;
radius = 2000;
typeArr = [70 71 96];
%}
lat = 35.143485;
lon = -90.188869;
radius = 50000;
typeArr = [9 96];
poi=getPointMetaPlacesApi(lat, lon, radius, typeArr);
%disp(poi);

for i=1:length(poi.lats)
    typeStrArr = poi.typeStrArr{i};
    fprintf('%s,%s,%.10f,%.10f',char(poi.names{i}), char(poi.vicinities{i}), poi.lats{i}, poi.lons{i});
    for j=1:length(typeStrArr)
        fprintf(',%s',typeStrArr{j});
    end
    fprintf('\n');
end


