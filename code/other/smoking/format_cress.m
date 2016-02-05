function format_cress(G,pid,sid,INDIR,OUTDIR)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
episode=[];
ei=0;
if isfield(R, 'cress') && length(R.cress.data)>0
    [T,ia,ic] = unique(datenum(R.cress.data(:,13)));
    fromIndex = 1;
    k=1;
    %StartTime=13, EndTime=14, TimeToRemoval(ms)=15, TimeToFirstPuff(ms)=16, IPI(ms)=23, Duration(ms)=22
    for i=1:length(ia)
        start=datenum(R.cress.data(ia(i),13));
        endt=datenum(R.cress.data(ia(i),14));
        ei=ei+1;
        episode{ei}.startmatlabtime=start;
        episode{ei}.endmatlabtime=endt;
%        hSmokingSession(i) = area([start+shiftCress, endt+shiftCress], [yMax, yMax]);
%        text((start+endt)/2 + shiftCress, 0  , ['Smoking Session : ' int2str(i)], 'Color', 'k', 'FontSize', 18, 'Rotation', 90);
        ttStart=start;
        ej=0;
        for j=fromIndex:ia(i)
            ipi = str2double(R.cress.data(j,23))/(1000*60*60*24);
            duration = str2double(R.cress.data(j,22))/(1000*60*60*24);
            ej=ej+1;
            episode{ei}.puff{ej}.startmatlabtime=ttStart+ipi;
            episode{ei}.puff{ej}.endmatlabtime=ttStart+ipi+duration;
%            hSmokingPuff(k) = area([ttStart+ipi+shiftCress, ttStart+ipi+duration+shiftCress], [yMax, yMax]);
%            text(ttStart+ipi+duration/2+shiftCress, 0  , ['Puff : ' int2str(j-fromIndex+1)], 'Color', 'k', 'FontSize', 18, 'Rotation', 90);
            ttStart = ttStart+ipi+duration;
            k=k+1;
        end
        fromIndex=ia(i)+1;
    end
    
end

fprintf('pid=%s sid=%s episode=%d\n',pid,sid,length(episode));


outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];

if isempty(dir(outdir))
    mkdir(outdir);
end
load([outdir G.DIR.SEP outfile]);
D.cress.episode=episode;
save([outdir G.DIR.SEP outfile],'D');
end