function content = getFileContent(path)
    fp = fopen(path);
    line = fgetl(fp);
    content = '';
    while ischar(line)
        content = [content line char(10)];
        line = fgetl(fp);
    end
    fclose(fp);

end
