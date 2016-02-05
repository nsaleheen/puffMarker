function load_NIDAc_pda_labreport_segment(G,pid,sid,INDIR, OUTDIR)
indir=[G.DIR.DATA G.DIR.SEP INDIR];

adminmark=[];
filename=[indir G.DIR.SEP pid '_mark.csv'];
if exist(filename, 'file') ~= 2, disp('FILE NOT FOUND'), return;end

fileID = fopen(filename);
C = textscan(fileID,'%s','delimiter',',');
fclose(fileID);
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_segment.mat'];
load([outdir G.DIR.SEP outfile]);

starttimestamp=P.starttimestamp;
endtimestamp=P.endtimestamp;

ind=find(strcmpi(C{1},'cocaine')==1);
k=0;
ind=ind';
for i=ind
    cdate=C{1}{i+4};
    if strcmp(cdate,'NULL')==1, continue;end;
    cdate=[cdate ':00'];
    curtimestamp=convert_time_timestamp(G,cdate);
    if curtimestamp>=starttimestamp && curtimestamp<=endtimestamp
        k=k+1;
        adminmark.time{k}=cdate;
        adminmark.timestamp(k)=curtimestamp;
        adminmark.matlabtime(k)=convert_timestamp_matlabtimestamp(G,curtimestamp);
        adminmark.dose(k)=10;
%        adminmark.zonisamide(k)='';
%        adminmark.sessionname{k}='';
        
    end
end
P.adminmark=adminmark;
save([outdir G.DIR.SEP outfile],'P');

end
