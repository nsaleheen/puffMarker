function [finalmd,PR]=find_dynamicbaseline(G,pid,sid,INDIR)
finalmd=-1;PR=-1;
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([indir G.DIR.SEP infile]);

%h=figure;
s=G.SENSOR.R_ECGID;
ind=find(B.sensor{s}.rr.quality==G.QUALITY.GOOD);
sample=B.sensor{s}.rr.sample(ind);
timestamp=B.sensor{s}.rr.timestamp(ind);
matlabtime=B.sensor{s}.rr.matlabtime(ind);
ind=find(sample<1.5);
sample=sample(ind);timestamp=timestamp(ind);matlabtime=matlabtime(ind);
if isempty(ind)
    return ;
end
%plot_signal(matlabtime,sample,'b.',1);

nowtimestamp=timestamp(1);
i=0;md=[];t=[];mt=[];
while nowtimestamp<timestamp(end)
    ind=find(timestamp>=nowtimestamp & timestamp<nowtimestamp+10*1000);
    nowtimestamp=nowtimestamp+10*1000;
    if length(ind)<=5, continue;end;
    i=i+1;
    md(i)=median(sample(ind));
    t(i)=timestamp(ind(1));
    mt(i)=matlabtime(ind(1));
end
if isempty(md), return;end
PR=90; MNWINDOW=6;%TOT=60;
%high=prctile(md,99);
%low=prctile(md,1);
%val=(high-low)*PR+low;
for PR=90:-1:90
    for MNWINDOW=1:10
        finalmd(MNWINDOW)=-1;
        val=prctile(md,PR);
        ind=find(md>val);
        orgmd=[];
        %d=diff(ind);
        %q=diff([-1 d -1] ==1);
        %v=find(q==-1) - find(q==1);
        if isempty(ind), continue;end;
        
        tempmd(1)=md(ind(1));
        orgmd=[];
        
        for i=2:length(ind)
            if ind(i)-ind(i-1)==1
                tempmd(end+1)=md(ind(i));
            else
                if length(tempmd)>=MNWINDOW
                    orgmd=[orgmd tempmd];
                end
                tempmd=[];
                tempmd(1)=md(ind(i));
            end
        end
        if length(tempmd)>=MNWINDOW
            orgmd=[orgmd tempmd];
        end
        %    if length(orgmd)>=TOT
        %        break;
        %    end
    finalmd(MNWINDOW)=median(orgmd);        
    end;
end
%hold on;plot_signal(mt,md,'r-',1);
%hold on; plot_signal([mt(1),mt(end)],[finalmd,finalmd],'k-',2);
%saveas(h,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.jpg']);
%close(h);

end
