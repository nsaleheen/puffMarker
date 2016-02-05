function ERR=calculate_error_all(G,pid,sid,INDIR,ERR,M)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_preprocess.mat'];

load([indir G.DIR.SEP infile]);

ppid=str2num(pid(2:end));ssid=str2num(sid(2:end));
length(M{1}{ppid,ssid})
for f=10:1:120
    for s=3:1:f-1
        for t=2:1:s+10
            pos=P.rr.macd.mavg{f,s,t};
            %            if f==10 && s==4 && t==2,
            %                disp(length(pos));
            %            end
            if ~isempty(M{1}{ppid,ssid})
                time=sort(M{1}{ppid,ssid});
                for i=1:2:length(time)
                    [res,ind]=min(abs(P.rr.macd.time(pos)-time(i)));
                    if length(pos)==ind, continue;end;
                    res=res*24*60*60;
                    ERR(1,f,s,t)=ERR(1,f,s,t)+res;
                    
                    temp=abs(P.rr.macd.time(pos(ind+1))-time(i+1));
                    temp=temp*24*60*60;
                    ERR(3,f,s,t)=ERR(3,f,s,t)+res+temp;%+1.8^length(pos);
                    
                    [temp,ind]=min(abs(P.rr.macd.time(pos)-time(i+1)));
                    temp=temp*24*60*60;
                    ERR(2,f,s,t)=ERR(2,f,s,t)+temp;%+1.8^length(pos);
                    %res=min(abs(P.rr.macd.time(pos)-maxtime))*24*60*60;
                    %ERR(2,f,s,t)=ERR(2,f,s,t)+res*res;
                end
            end
        end
    end
end
end
