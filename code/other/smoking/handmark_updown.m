function handmark_updown(G,pid,sid,INDIR)
disp(['pid= ' pid 'sid=' sid ' Task=mark hand up down']);
indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end
load([indir G.DIR.SEP infile]);
plot_rr_avg_threshold_macd_recovery_general(G,pid,sid);
pause;

outdir=[G.DIR.DATA G.DIR.SEP 'segment'];
outfile=[pid '_' sid '_segment.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');
fprintf(') =>  done\n');

end
function valid=isused(G,pid,sid,now)
valid=0;
ppid=str2num(pid(2:end));ssid=str2num(sid(2:end));
J{1}{1}=[0,1,1];J{1}{2}=[1,0,0,0,0];J{1}{3}=[1,0,0,0,0,0];J{1}{8}=[0,1,1];J{1}{9}=[1,0,0,0,0,0,0];J{1}{11}=[0,0,0];J{1}{12}=[1,0,0,0];
J{2}{1}=[0,1,1,1];J{2}{6}=[0,1,1];J{2}{7}=1;J{2}{9}=1;J{2}{10}=0;J{2}{13}=[0,1,1];J{2}{14}=0;J{2}{16}=1;J{2}{17}=0;J{2}{20}=[0,0,0];J{2}{21}=1;J{2}{23}=1;J{2}{24}=0;
J{3}{1}=[0,1,0,1];J{3}{4}=[0,1,1];J{3}{5}=1;J{3}{7}=0;J{3}{8}=1;J{3}{11}=[0,0,0];J{3}{12}=0;J{3}{14}=0;J{3}{15}=1;J{3}{18}=[0,0,1];J{3}{19}=0;J{3}{21}=0;J{3}{22}=0;
N{1}{6}=1;N{1}{9}=1;N{1}{12}=1;
N{2}{4}=1;N{2}{8}=0;
N{3}{1}=0;N{3}{5}=1;N{3}{10}=1;
N{4}{1}=1;N{4}{5}=1;N{4}{8}=1;
N{5}{3}=1;N{5}{6}=1;
N{6}{1}=1;N{6}{4}=1;N{6}{8}=1;

if strcmp(G.STUDYNAME,'JHU')==1
    valid=J{ppid}{ssid}(now);
elseif strcmp(G.STUDYNAME,'NIDAc')==1
    valid=N{ppid}{ssid}(now);
end
end

