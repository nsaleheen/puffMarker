function P=detect_peakvalley_v3(G,P)
sample_new=smooth(P.sensor{1}.sample_new,7,'moving')';
    mn=prctile(sample_new,5);
    mx=prctile(P.sensor{1}.sample_new,95);
    
%    sel=(mx-mn)/20;
    sel=100;
    peak=peakfinder(sample_new,sel,-100,1);
    valley=peakfinder(sample_new,sel,100,-1);
%end
a=[valley,peak];
b=[ones(1,length(valley)),ones(1,length(peak))*0];
[peakvalley,d]=sort(a);
order=b(d);
while true
    for i=1:length(order)
        if mod(i,2)~=order(i), 
            if i==1,             order(i)=[];peakvalley(i)=[];
            elseif mod(i,2)==0, %peak
                if P.sensor{1}.sample_new(peakvalley(i))>P.sensor{1}.sample_new(peakvalley(i-1))
                    order(i-1)=[];peakvalley(i-1)=[];
                else
                    order(i)=[];peakvalley(i)=[];
                end
            else
                if P.sensor{1}.sample_new(peakvalley(i))<P.sensor{1}.sample_new(peakvalley(i-1))
                    order(i-1)=[];peakvalley(i-1)=[];
                else
                    order(i)=[];peakvalley(i)=[];
                end
            end
            break;
        end;
    end
    if i==length(order), break;end;
end
P.sensor{1}.peakvalley_new_3.sample=P.sensor{1}.sample_new(peakvalley);
P.sensor{1}.peakvalley_new_3.timestamp=P.sensor{1}.timestamp(peakvalley);
P.sensor{1}.peakvalley_new_3.matlabtime=P.sensor{1}.matlabtime(peakvalley);
while true
    x=P.sensor{1}.peakvalley_new_3.timestamp(3:2:end)-P.sensor{1}.peakvalley_new_3.timestamp(1:2:end-2);
    tn=find(x<800);
    if isempty(tn), break;end;
    tv=tn(1)*2-1;
    tp=tv+1;
    if P.sensor{1}.peakvalley_new_3.sample(tp-2)<P.sensor{1}.peakvalley_new_3.sample(tp)
        tvd=tv;tpd=tv-1; td=tpd:tvd;
    else
        tvd=tv;tpd=tv+1;td=tvd:tpd;
    end
    
    P.sensor{1}.peakvalley_new_3.sample(td)=[];
    P.sensor{1}.peakvalley_new_3.timestamp(td)=[];
    P.sensor{1}.peakvalley_new_3.matlabtime(td)=[];
end
while true
    x=P.sensor{1}.peakvalley_new_3.timestamp(4:2:end)-P.sensor{1}.peakvalley_new_3.timestamp(2:2:end-2);
    tn=find(x<800);
    if isempty(tn), break;end;
    tp1=tn(1)*2;
    tp2=tp1+2;
    if P.sensor{1}.peakvalley_new_3.sample(tp1)>P.sensor{1}.peakvalley_new_3.sample(tp2)
        td=tp1+1:tp2;
    else
        td=tp1:tp2-1;
    end
    
    P.sensor{1}.peakvalley_new_3.sample(td)=[];
    P.sensor{1}.peakvalley_new_3.timestamp(td)=[];
    P.sensor{1}.peakvalley_new_3.matlabtime(td)=[];
end
for i=1:2:length(P.sensor{1}.peakvalley_new_3.sample)-2
    stime=P.sensor{1}.peakvalley_new_3.timestamp(i);
    etime=P.sensor{1}.peakvalley_new_3.timestamp(i+2);
    [a,b]=binarysearch(P.sensor{1}.timestamp,stime,etime);
    [v,ind]=max(P.sensor{1}.sample_new(a:b));
    P.sensor{1}.peakvalley_new_3.timestamp(i+1)=P.sensor{1}.timestamp(a+ind-1);
    P.sensor{1}.peakvalley_new_3.matlabtime(i+1)=P.sensor{1}.matlabtime(a+ind-1);
    P.sensor{1}.peakvalley_new_3.sample(i+1)=P.sensor{1}.sample_new(a+ind-1);
    
end
for i=2:2:length(P.sensor{1}.peakvalley_new_3.sample)-2
    stime=P.sensor{1}.peakvalley_new_3.timestamp(i);
    etime=P.sensor{1}.peakvalley_new_3.timestamp(i+2);
    [a,b]=binarysearch(P.sensor{1}.timestamp,stime,etime);
    [~,ind]=min(P.sensor{1}.sample_new(a:b));
    P.sensor{1}.peakvalley_new_3.timestamp(i+1)=P.sensor{1}.timestamp(a+ind-1);
    P.sensor{1}.peakvalley_new_3.matlabtime(i+1)=P.sensor{1}.matlabtime(a+ind-1);
    P.sensor{1}.peakvalley_new_3.sample(i+1)=P.sensor{1}.sample_new(a+ind-1);    
end
if mod(length(P.sensor{1}.peakvalley_new_3.sample),2)==0,
    P.sensor{1}.peakvalley_new_3.sample(end)=[];
    P.sensor{1}.peakvalley_new_3.timestamp(end)=[];
    P.sensor{1}.peakvalley_new_3.matlabtime(end)=[];
end

end
