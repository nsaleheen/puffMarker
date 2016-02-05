function [header,value,timestamp,matlabtime]=gen_feature_array(G,F,featureids,featurelist)
x=cell2mat([featurelist{:,1}]);
header=[];
quality=zeros(length(F.window),1);
timestamp=zeros(length(F.window),1);
matlabtime=zeros(length(F.window),1);
fno=0;
for fid=featureids
    lid=find(x==fid);
    list_feature=cell2mat([featurelist{lid,2}]);
    for l=list_feature
        fno=fno+1;
        header{fno}=F.FEATURE{fid}.FEATURENAME.NAME{l};
        for i=1:length(F.window)
            matlabtime(i)=F.window(i).start_matlabtime;
            timestamp(i)=F.window(i).starttimestamp;
            quality(i)=quality(i)+F.window(i).feature{fid}.quality;
            if F.window(i).feature{fid}.quality==G.QUALITY.GOOD
                str=[];
                for j=1:length(F.window(i).feature{fid}.value{l})
                    if j~=1,str=[str ';'];end
                    str=[str,num2str(F.window(i).feature{fid}.value{l}(j))];
                end
                value{i,fno}=str;
            else
                value{i,fno}='-1';
            end
        end
    end
end
x=find(quality~=0);
value(x,:)=[];

%{
%header=generate_header(G,F,featureids);
value=[];
timestamp=[];
i=0;
for w=1:length(F.window)
    valid=1;
    for featureid=featureids
        
        if F.window(w).feature{featureid}.quality~=G.QUALITY.GOOD
            valid=0;
            continue;
        end
    end
    if valid==0,continue;end;
    j=0;
    for id=featureids
        i=i+1;
        fid=find(x==id);
        list_feature=cell2mat([G.RUN.FEATURE.FEATURELIST{fid,:}]);        
        timestamp(i)=F.window(w).endtimestamp;
        
        for f=list_feature
            j=j+1;
            value(i,j)=F.window(w).feature{featureid}.value{f};
        end
    end
end
end

function header=generate_header(G,F,featureids)
header=[];
x=cell2mat([G.RUN.FEATURE.FEATURELIST{:,1}]);

i=0;
for id=featureids
    fid=find(x==id);
    list_feature=cell2mat([G.RUN.FEATURE.FEATURELIST{fid,:}]);
    for f=list_feature
        i=i+1;
        header{i}=F.FEATURE{id}.FEATURENAME.NAME{f};
    end
end
end
%}
