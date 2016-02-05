function plot_monowar_preprocess(G, pid,sid,slist)
color={'b-','r-','g-','b-','m-','c-', 'k-',   'r-','g-','b-','m-','c-', 'k-'};
%color={'r.','g.','S.','m.','c.', 'k.',   'r.','g.','S.','m.','c.', 'k.'};

indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
infile=[pid '_' sid '_basicfeature.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);


figure;
title(['pid=' pid ' sid=' sid]);
yMax=0;
for s=slist
    yMax=yMax+max(B.sensor{s}.sample);
end

offset=yMax;
i=0;
h=[];
for s=slist
    hold on;
    offset=offset-max(B.sensor{s}.sample);
    if length(B.sensor{s}.matlabtime)==0
        continue;
    end
    h(i+1)=plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sample,color{rem(i,length(color))+1},1,offset);    
%    B.sensor{s}.sample=smooth(B.sensor{s}.sample,8);
%    i=i+1;
%    h(i+1)=plot_signal(B.sensor{s}.matlabtime,B.sensor{s}.sample,color{rem(i+1,length(color))+1},1,offset);
    legend_text{i+1}=B.sensor{s}.NAME;
    %h(i+1)=plot_signal(S.sensor{s}.matlabtime,S.sensor{s}.sampleNorm,color{rem(i,length(color)+1)+1},1,offset);
    i=i+1;
end
xx=xlim;
plot(xx,0.75*[1019,1019],'r-');
list_selfreport=[G.SELFREPORT.SMKID];
for s=list_selfreport
    hold on;
    for i=1:length(B.selfreport{s}.matlabtime)
        hold on;
        plot([B.selfreport{s}.matlabtime(i),B.selfreport{s}.matlabtime(i)],ylim,'r-','LineWidth',2);
        hold on;
        text(B.selfreport{s}.matlabtime(i), 0  , [B.selfreport{s}.NAME ' : ' int2str(i)], 'Color', 'k','FontSize',18,'Rotation',90);
    end
end

%legend(h,legend_text,'Interpreter', 'none');
xlabel('Time');
ylabel('Magnitude');


end
