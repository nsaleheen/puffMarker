function mark_cocaine_segment(G,pid,sid)
disp(['pid= ' pid 'sid=' sid ' Task=mark cocaine segment']);
indir=[G.DIR.DATA G.DIR.SEP 'segment'];infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end
load([indir G.DIR.SEP infile]);
if isfield(P.rr,'window')
    P.rr.window.mark=zeros(1,length(P.rr.window.p1));
    for i=1:length(P.rr.window.p1)
        if P.rr.window.v1(i)==-1 || P.rr.window.v2(i)==-1,P.rr.window.mark(i)=-1;continue;end;
        stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
        etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
        rr_matlabtime=P.rr.matlabtime(find(P.rr.matlabtime>=stime & P.rr.matlabtime<=etime));
        %% Missing
        good=0;bad=0;
        for now=stime:60/(24*60*60):etime
            len=length(find(rr_matlabtime>=now & rr_matlabtime<now+60/(24*60*60)));
            if len<40, bad=bad+1; else good=good+1;end;
        end
        if bad/(bad+good)>0.6, P.rr.window.mark(i)=-2;continue;end;
        %% Missing
        %    expected=((etime-stime)*24*60)*50;
        %    estimated=length(ind_rr);
        %    if estimated<=expected*0.7,        P.rr.window.mark(i)=-2;        continue;    end
        
    end
end
if isfield(P,'adminmark') & isfield(P.adminmark,'matlabtime'),
    for j=1:length(P.adminmark.matlabtime)
        if isused(G,pid,sid,j)==0, continue;end;
        minv=inf;who=0;
        for i=1:length(P.rr.window.p1)
            if abs(P.adminmark.matlabtime(j)-P.rr.avg.matlabtime(P.rr.window.p1(i)))<minv,minv=abs(P.adminmark.matlabtime(j)-P.rr.avg.matlabtime(P.rr.window.p1(i)));who=i;end;
        end
        if P.rr.window.mark(who)~=-1 & P.rr.window.mark(who)~=-2,
            P.rr.window.mark(who)=P.adminmark.dose(j);
        end
        
    end
end

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
J{2}{1}=[0,0,1,1];J{2}{6}=[0,1,1];J{2}{7}=1;J{2}{9}=1;J{2}{10}=0;J{2}{13}=[0,1,1];J{2}{14}=0;J{2}{16}=1;J{2}{17}=0;J{2}{20}=[0,0,0];J{2}{21}=1;J{2}{23}=1;J{2}{24}=0;
J{3}{1}=[0,0,0,1];J{3}{4}=[0,1,1];J{3}{5}=1;J{3}{7}=0;J{3}{8}=1;J{3}{11}=[0,0,0];J{3}{12}=0;J{3}{14}=0;J{3}{15}=1;J{3}{18}=[0,1,1];J{3}{19}=0;J{3}{21}=0;J{3}{22}=0;
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

