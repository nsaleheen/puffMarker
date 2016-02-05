function plot_frmtdata(G,pid,sid,INDIR,slist)
color={'b-','g-','k-','c-','y-'};
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
load([indir G.DIR.SEP infile]);
offset=0;
i=0;
h=[];
for s=slist
    hold on;
    if isfield(D.sensor{s}, 'matlabtime_all')==1 
        plot_signal(D.sensor{s}.matlabtime_all,D.sensor{s}.sample_all,'r-',1,offset);
    end
    legend_text{i+1}=D.sensor{s}.NAME;
    h(i+1)=plot_signal(D.sensor{s}.matlabtime,D.sensor{s}.sample,color{rem(i,length(color)+1)+1},1,offset);
    i=i+1;
    
    offset=offset+max(D.sensor{s}.sample);
end
legend(h,legend_text,'Interpreter', 'none');
xlabel('Time');
ylabel('Magnitude');
end
