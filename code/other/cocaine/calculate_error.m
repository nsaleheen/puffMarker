function ERR=calculate_error(G,pid,sid,INDIR,ERR,M)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_preprocess.mat'];

load([indir G.DIR.SEP infile]);

ppid=str2num(pid(2:end));ssid=str2num(sid(2:end));

for f=10:1:120
    for s=3:1:f-1
        for t=2:1:s+10
            pos=P.rr.macd.mavg{f,s,t};
%            if f==10 && s==4 && t==2,
%                disp(length(pos));
%            end
            for i=1:2
                if ~isempty(M{i}{ppid,ssid})
                    mintime=min(M{i}{ppid,ssid});
                    maxtime=max(M{i}{ppid,ssid});
                    [res,ind]=min(abs(P.rr.macd.time(pos)-maxtime));
                    if ind==length(pos)
                        continue;
                    end
                    
                    res=res*24*60*60;
                    temp=abs(P.rr.macd.time(pos(ind+1))-maxtime);
                    temp=temp*24*60*60;
                    ERR(1,f,s,t)=ERR(1,f,s,t)+res+temp;%+1.8^length(pos);
                    %res=min(abs(P.rr.macd.time(pos)-maxtime))*24*60*60;
                    %ERR(2,f,s,t)=ERR(2,f,s,t)+res*res;
                end
            end
        end
    end
end
end
