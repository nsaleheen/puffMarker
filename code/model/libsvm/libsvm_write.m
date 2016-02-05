%convert the data format from the csv to the format of the s3vm input
function write_libsvm(filename, feature,output)

fid = fopen(filename, 'w');
[row,col]=size(feature);
for r=1:row
    if output(r)==1
        line='+1';
    else
        line='-1';
    end
    for c=1:col
        num=sprintf('%.10f',feature(r,c));
        line=[line,' ',num2str(c),':',num];
    end
    fprintf(fid,'%s\n',line);
    
end
fclose(fid);
return;
