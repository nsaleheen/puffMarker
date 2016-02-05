function [TOT,C_PASS,A_PASS,C_FAIL,A_FAIL,MA,MC,D,O]=main_monowar_cocaine_7_TEST_PID_TAU2(G,pid,E,result,fig,tau2)
ppid=str2num(pid(2:end));
base=result{ppid}.base;
tau1=result{ppid}.tau1;
%tau2=result{ppid}.tau2;
MA=[];MC=[];D=[];O=[];
TOT=length(E{ppid}.N)+length(E{ppid}.C);

dist=E{ppid}.rr.prctile_95-E{ppid}.rr.prctile_5;
[ma,mc,C_PASS,C_FAIL,d,o,COUT]=test_one(E{ppid}.C,base,tau1,tau2,'c',dist);MA=[MA ma];MC=[MC mc];D=[D,d];O=[O,o];
[ma,mc,A_PASS,A_FAIL,d,o,NOUT]=test_one(E{ppid}.N,base,tau1,tau2,'n',dist);MA=[MA ma];MC=[MC mc];D=[D,d];O=[O,o];
if fig~=1, return;end;
for p=1:size(G.PS_LIST,1)
    if strcmp(char(G.PS_LIST{p,1}),pid)~=1, continue;end;
    slist=G.PS_LIST{p,2};
    for s=slist
        sid=char(s);
        [hh,leg]=plot_rr_avg_threshold_macd_recovery_cocaine_activity(G,pid,sid);
        for i=1:length(COUT)
            if strcmp(COUT{i}.pid,pid)==1 && strcmp(COUT{i}.sid,sid)==1
                midtime=convert_timestamp_matlabtimestamp(G,(COUT{i}.window_time(4)+COUT{i}.window_time(1))/2);
                if COUT{i}.window.predict==1,                    plot_signal(midtime,1800,'b*',5);
                else                    plot_signal(midtime,1800,'r*',5);
                end
                if COUT{i}.window.mark>=1,                    plot_signal(midtime,1700,'bo',5);
                else                    plot_signal(midtime,1700,'ro',5);
                end
                
            end
        end
        for i=1:length(NOUT)
            if strcmp(NOUT{i}.pid,pid)==1 && strcmp(NOUT{i}.sid,sid)==1
                midtime=convert_timestamp_matlabtimestamp(G,(NOUT{i}.window_time(4)+NOUT{i}.window_time(1))/2);
                if NOUT{i}.window.predict==1,
                    plot_signal(midtime,1800,'b*',5);
                else
                    plot_signal(midtime,1800,'r*',5);
                end
                if NOUT{i}.window.mark>=1,                    plot_signal(midtime,1700,'bo',5);
                else                    plot_signal(midtime,1700,'ro',5);
                end
                
            end
            
        end
        temp=[G.DIR.DATA G.DIR.SEP 'figure_output' G.DIR.SEP pid '_' sid '.jpg'];
        export_fig(temp);
%        close(hh);
        
    end
end
end

function [MA,MC,pass,fail,D,O,CN]=test_one(CN,base,tau1,tau2,type,dist)
MA=[];MC=[];pass=0;V=[];D=[];O=[];fail=0;
for n=1:length(CN)
    %    disp(n);
    CN{n}.window.predict=0;
    if CN{n}.window.mark<0, continue;end;
    if type=='n' && isvalid(CN{n},dist)==0, fail=fail+1;continue;end;
    %    if isvalid(CN{n})==0, continue;end;
    
    [v,ma,mc,d]=test_emre(CN{n},base,tau1,tau2);
    if v==0, fail=fail+1;else
        pass=pass+1;
        if mc/ma<=0.52, CN{n}.window.predict=1;end;
        MA=[MA, ma]; MC=[MC, mc];            D=[D, d];O=[O, CN{n}.window.mark];
    end
end

end
function valid=isvalid(CN,dist)
p1time= CN.window_time(1);   p2time= CN.window_time(4);
v1time= CN.window_time(2);   v2time= CN.window_time(3);
if CN.window.mark<0, valid=0;return;end;
if p2time-p1time<20*60*1000, valid=0;return;end;
a=2*60*1000;
ind=find(CN.acl.timestamp>=p1time & CN.acl.timestamp<=p1time+a);
val=CN.acl.avg.t60(ind);
ind1=find(val>CN.acl.avg.th60);
if length(val) *0.66<length(ind1), valid=0;return;end;
b=3*60*1000;
ind=find(CN.acl.timestamp>=v2time-a & CN.acl.timestamp<=v2time);
val=CN.acl.avg.t60(ind);
ind1=find(val>CN.acl.avg.th60);
if length(val) *0.66<length(ind1), valid=0;return;end;

ind=find(CN.rr.timestamp>CN.window_time(1) & CN.rr.timestamp<=CN.window_time(4));
e=prctile(CN.rr.sample(ind),95)-prctile(CN.rr.sample(ind),5);
if dist*0.33>e, valid=0;return;end;

ind=find(CN.rr.timestamp>CN.window_time(1) & CN.rr.timestamp<=CN.window_time(3));
e=prctile(CN.rr.sample(ind),95)-prctile(CN.rr.sample(ind),5);
if dist*0.33>e, valid=0;return;end;


%find(CN.rr.timestamp>
valid=1;
return;
end
