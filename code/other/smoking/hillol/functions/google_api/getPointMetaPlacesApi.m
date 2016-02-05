function poi = getPointMetaPlacesApi( lat, lon, radius, typeArr )

typesStr = '';
for i=1:length(typeArr)
    typesStr = strcat(typesStr, getPlaceTypeStr(typeArr(i)));
    if i~= length(typeArr)
        typesStr = strcat(typesStr, '|');
    end
end
if iscell(typesStr) == 1
    typesStr = typesStr{1};
end

%disp(typesStr);
apiKey = 'AIzaSyBjbEimJ-5MZGa3C8jxNzmxQ1gL2fAxmHE';
apiUrl = sprintf('https://maps.googleapis.com/maps/api/place/search/xml?location=%f,%f&types=%s&sensor=false&radius=%d&key=%s', lat, lon, typesStr, radius, apiKey);
strXml = urlread(apiUrl);
strXml = regexprep(strXml,'[^a-zA-Z0-9<>&:/\+-?"`\r\n ]','');

stream = java.io.StringBufferInputStream(strXml);

factory = javaMethod('newInstance', 'javax.xml.parsers.DocumentBuilderFactory');
builder = factory.newDocumentBuilder;

doc = builder.parse(stream);
results = doc.getElementsByTagName('result');

poi.names = [];
poi.vicinities = [];
poi.lats = [];
poi.lons = [];
poi.typeIdArrs = [];
poi.typeStrArr = [];
for i=0:results.getLength()-1
    resultItem = results.item(i);
    poiName = char(resultItem.getElementsByTagName('name').item(0).getTextContent());
    poiVicinity = char(resultItem.getElementsByTagName('vicinity').item(0).getTextContent());
    lat = str2num(resultItem.getElementsByTagName('lat').item(0).getTextContent());
    lon = str2num(resultItem.getElementsByTagName('lng').item(0).getTextContent());
    typeIdArr = [];
    typeStrArr = [];
    typeItems = resultItem.getElementsByTagName('type');
    for j=0:typeItems.getLength()-1
        typeStr = char(typeItems.item(j).getTextContent());
        typeId = getPlaceTypeId(typeStr);
        typeIdArr(end+1) = typeId;
        typeStrArr{j+1} = typeStr;
    end
    a=0;
    poi.names{i+1} = poiName;
    poi.vicinities{i+1} = poiVicinity;
    poi.lats{i+1} = lat;
    poi.lons{i+1} = lon;
    poi.typeIdArrs{i+1} = typeIdArr;
    poi.typeStrArr{i+1} = typeStrArr;
end

end

