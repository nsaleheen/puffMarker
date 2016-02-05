function plot_basicfeature(G,pid,sid,INDIR,slist)
color={'b','g','k','c','y'};
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([indir G.DIR.SEP infile]);
offset=0;
i=0;
h=[];
for s=slist
    hold on;
    if s==G.SENSOR.R_RIPID
        offset=offset-min(B.sensor{s}.sample)+100;
        h(i+1)=plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sample,[color{rem(i,length(color)+1)+1} '-'],1,offset);        
        plot_signal(B.sensor{s}.peakvalley.matlabtime,B.sensor{s}.peakvalley.sample,'ro',1,offset);
        legend_text{i+1}=B.sensor{s}.NAME;
        offset=offset+max(B.sensor{s}.sample);
        i=i+1;
%{
        offset=offset-quantile(B.sensor{s}.feature{G.FEATURE.R_RIP.RESPDURATION},.20)+500;
        h(i+1)=plot_signal(B.sensor{s}.peakvalley.matlabtime(1:2:end-2),B.sensor{s}.feature{G.FEATURE.R_RIP.RESPDURATION},[color{rem(i,length(color)+1)+1}(1) '.'],1,offset);        
        legend_text{i+1}=B.sensor{s}.NAME;
        offset=offset+quantile(B.sensor{s}.feature{G.FEATURE.R_RIP.RESPDURATION},.95);
        i=i+1;
        
        offset=offset-quantile(B.sensor{s}.feature{G.FEATURE.R_RIP.EXPRDURATION},.20)+500;
        h(i+1)=plot_signal(B.sensor{s}.peakvalley.matlabtime(1:2:end-2),B.sensor{s}.feature{G.FEATURE.R_RIP.EXPRDURATION},[color{rem(i,length(color)+1)+1}(1) '.'],1,offset);        
        legend_text{i+1}=B.sensor{s}.NAME;
        offset=offset+quantile(B.sensor{s}.feature{G.FEATURE.R_RIP.EXPRDURATION},.95);
        i=i+1;
        
        offset=offset-quantile(B.sensor{s}.feature{G.FEATURE.R_RIP.STRETCH},.20)+500;
        h(i+1)=plot_signal(B.sensor{s}.peakvalley.matlabtime(1:2:end-2),B.sensor{s}.feature{G.FEATURE.R_RIP.STRETCH},[color{rem(i,length(color)+1)+1} '.'],1,offset);        
        legend_text{i+1}=B.sensor{s}.NAME;
        offset=offset+quantile(B.sensor{s}.feature{G.FEATURE.R_RIP.STRETCH},.95);
        i=i+1;

        offset=offset-quantile(B.sensor{s}.feature{G.FEATURE.R_RIP.IERATIO},.20)+500;
        h(i+1)=plot_signal(B.sensor{s}.peakvalley.matlabtime(1:2:end-2),B.sensor{s}.feature{G.FEATURE.R_RIP.IERATIO},[color{rem(i,length(color)+1)+1} '.'],1,offset);        
        legend_text{i+1}=B.sensor{s}.NAME;
        offset=offset+quantile(B.sensor{s}.feature{G.FEATURE.R_RIP.IERATIO},.95);
        i=i+1;
  %}      
    elseif s==G.SENSOR.R_ECGID
%        plot_signal(B.sensor{s}.rr.matlabtime,B.sensor{s}.rr.sample*1000,'r.',1,offset);
        ind=find(B.sensor{s}.rr.quality==G.QUALITY.GOOD);
        offset=offset-min(B.sensor{s}.rr.sample(ind)*6000)+100;
        if ~isempty(ind)
            h(i+1)=plot_signal(B.sensor{s}.rr.matlabtime(ind),B.sensor{s}.rr.sample(ind)*6000,[color{rem(i,length(color)+1)+1}(1) '.'],1,offset);
            legend_text{i+1}='RR Interval';
            offset=offset+max(B.sensor{s}.rr.sample(ind)*6000);
        end
%{        
    elseif s==G.SENSOR.R_ACLXID
        offset=offset-min(B.sensor{s}.var_x.value)+100;
        h(i+1)=plot_signal(convert_timestamp_matlabtimestamp(G,B.sensor{s}.var_x.timestamp),B.sensor{s}.var_x.value,[color{rem(i,length(color)+1)+1}(1) '.'],1,offset);
        legend_text{i+1}='VAR X';
        offset=offset+max(B.sensor{s}.var_x.value);
    elseif s==G.SENSOR.R_ACLYID
        offset=offset-min(sqrt(B.sensor{s}.var_y.value))+100;
        h(i+1)=plot_signal(convert_timestamp_matlabtimestamp(G,B.sensor{s}.var_y.timestamp),sqrt(B.sensor{s}.var_y.value),[color{rem(i,length(color)+1)+1}(1) '.'],1,offset);
        legend_text{i+1}='VAR y';
        offset=offset+max(sqrt(B.sensor{s}.var_y.value));

        offset=offset-min(B.sensor{s}.dt_y.value)+100;
        h(i+1)=plot_signal(convert_timestamp_matlabtimestamp(G,B.sensor{s}.dt_y.timestamp),B.sensor{s}.dt_y.value,[color{rem(i,length(color)+1)+1}(1) '.'],1,offset);
        legend_text{i+1}='Raw Signal y';
        offset=offset+max(B.sensor{s}.dt_y.value);

        offset=offset-min(B.sensor{s}.sample)+100;
        h(i+1)=plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sample,[color{rem(i,length(color)+1)+1}(1) '.'],1,offset);
        legend_text{i+1}='Raw Signal y';
        offset=offset+max(B.sensor{s}.sample);

  %}      
        
    else
        offset=offset-min(B.sensor{s}.sample)+100;        
        h(i+1)=plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sample,color{rem(i,length(color)+1)+1},1,offset); 
        legend_text{i+1}=B.sensor{s}.NAME;
        offset=offset+max(B.sensor{s}.sample);
        
    end        
    i=i+1;
end
legend(h,legend_text,'Interpreter', 'none');
xlabel('Time');
ylabel('Magnitude');
end
