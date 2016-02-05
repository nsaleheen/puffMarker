function plot_frmtraw(G,pid,sid,INDIR,slist)
color={'b-','g-','k-','c-','y-'};
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];
load([indir G.DIR.SEP infile]);
offset=0;
i=0;
h=[];
for s=slist
    hold on;
    h(i+1)=plot_signal(R.sensor{s}.matlabtime,R.sensor{s}.sample,color{rem(i,length(color)+1)+1},1,offset);
    legend_text{i+1}=R.sensor{s}.NAME;
    h(i+1)=plot_signal(R.sensor{s}.matlabtime,R.sensor{s}.sample,color{rem(i,length(color)+1)+1},1,offset);
    i=i+1;
    offset=offset+max(R.sensor{s}.sample);
end
%plot cress data
[T,ia,ic]=unique(R.cress.data(:,13));
for i=1:length(ia)
    start=datenum(R.cress.data(ia(i),13));
    endt=datenum(R.cress.data(ia(i),14));
    plot_signal([start start],[0 offset],'r',2,0);
    plot_signal([endt endt],[0 offset],'r',2,0);
    text(start,0,'CressSmoking','fontsize',18,'rotation',90);
end

legend(h,legend_text,'Interpreter', 'none');
xlabel('Time');
ylabel('Magnitude');
end


% function matlabCressTime=getMatlabTimeForCress(cressTime)
%     matlabCressTime=zeros(1,length(cressTime));
%     for i=1:length(cressTime)
%         matlabCressTime(i)=datenum(cressTime(i));
%     end
% end
