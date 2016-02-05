function plot_all_drug_jhu(G,MODEL)
PS_20= {
    {'p01'},{'s01','s03','s08','s12'};
    {'p02'},{'s06','s09','s13','s16','s21'};
    {'p03'},{'s05','s11','s12','s18','s21'};
    };
PS_40= {
    {'p01'},{'s01','s02','s08','s09'};
    {'p02'},{'s06','s07','s13','s14','s23'};
    {'p03'},{'s08','s11','s15','s18','s19'};
    };
h=figure;
plot_smooth(G,PS_20,20,'b-',MODEL,h);
plot_smooth(G,PS_40,40,'r-',MODEL,h);
end
function plot_smooth(G,PS_LIST,dose,color,MODEL,h)
pno=size(PS_LIST);
for p=1:pno
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        plot_drug(G,pid,sid,MODEL);
        load([G.DIR.DATA G.DIR.SEP 'formatteddata' G.DIR.SEP pid '_' sid '_' G.FILE.FRMTDATA_MATNAME]);        
        load([G.DIR.DATA G.DIR.SEP 'curve' G.DIR.SEP MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_smooth.mat']);
        ind=find(D.adminmark.dose==dose);
        admin_time=D.adminmark.timestamp(ind(1));
        ind=find(C.timestamp(C.valley_ind)>admin_time);
        if isempty(ind), continue;end;
        valley_timestamp=C.timestamp(ind(1));
        starttimestamp=C.timestamp(ind(1))-15*60*1000;
        endtimestamp=C.timestamp(ind(1))+45*60*1000;
        ind=find(C.timestamp>=starttimestamp &  C.timestamp<=endtimestamp);
        %%
        figure(h);
        hold on; plot_signal(C.timestamp(ind)-valley_timestamp,C.Q9_smooth(ind)*500,color,1);
        ylim([200 600]);
    end
end
end