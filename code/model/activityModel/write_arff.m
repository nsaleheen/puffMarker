function write_arff(name,featurenames,categorynames,features,categories)%,timestamp)

id=fopen([name '.arff'],'w');

%id_timestamp=fopen([name,'_timestamp.txt'],'w');

fprintf(id,'@relation ');
fprintf(id,name);
fprintf(id,'\n');
fprintf(id,'\n');

for i=1:length(featurenames)
    fprintf(id,'@attribute ');
    fprintf(id,featurenames{i});
    fprintf(id,' numeric');
    fprintf(id,'\n');
end
fprintf(id,'\n');

fprintf(id,'@attribute class {');
%n=length(categorynames);
n=length(find(~cellfun(@isempty,categorynames)))
for i=1:n-1
    fprintf(id,categorynames{i});
    fprintf(id,',');
end;
fprintf(id,categorynames{n});
fprintf(id,'}');
fprintf(id,'\n');
fprintf(id,'\n');

fprintf(id,'@data');
fprintf(id,'\n');

[n,m]=size(features);
for i=1:n
    str=categories{i};
    disp(str);
    disp(i);
    if  isempty(find(isnan(features(i,:))==1)) && sum(features(i,:))~=0  %for training
        for j=1:m,
            fprintf(id,'%.8f,',features(i,j));end;
        %fprintf(id,categories{i});
        fprintf(id,char(str));
        fprintf(id,'\n');
%         fprintf(id_timestamp,num2str(int64(timestamp(i))));
%         fprintf(id_timestamp,'\n');
    end;
end;
fclose(id);
% fclose(id_timestamp);
