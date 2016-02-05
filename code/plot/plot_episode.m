function plot_episode(G, pid,sid, n, INDIR, slist)

%color={'r-','g-','b-','y-','m-','c-','w-', 'k-',   'r-','g-','b-','y-','m-','c-','w-', 'k-'};
color={'b-','r-','g-','b-','m-','c-', 'k-',   'r-','g-','b-','m-','c-', 'k-'};
%color={'r.','g.','S.','m.','c.', 'k.',   'r.','g.','S.','m.','c.', 'k.'};

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_e' num2str(n) '_episode.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);

for s=slist
    maxS = max(S.sensor{s}.sample);
    minS = min(S.sensor{s}.sample);
%    S.sensor{s}.sampleNorm = (S.sensor{s}.sample-minS)/(maxS-minS);%Scaling from 0 to 1
    S.sensor{s}.sampleNorm=S.sensor{s}.sample;
    S.sensor{s}.matlabtime=convert_timestamp_matlabtimestamp(G,S.sensor{s}.timestamp);
end

figure;
title(['pid=' pid ' sid=' sid]);
yMax=0;
for s=slist
    if isempty(S.sensor{s}.sampleNorm), continue;end;
    yMax=yMax+max(S.sensor{s}.sampleNorm);
end

offset=yMax;
i=0;
h=[];
for s=slist
    hold on;
    if length(S.sensor{s}.matlabtime)==0
        i=i+1;
        continue;
    end
    offset=offset-max(S.sensor{s}.sampleNorm);
    
    h(i+1)=plot_signal(S.sensor{s}.matlabtime,S.sensor{s}.sampleNorm,color{rem(i,length(color))+1},1,offset);
    xx=xlim;
    plot_signal(xx,[720,720],'k-',2,offset);
    legend_text{i+1}=S.sensor{s}.NAME;    
    
    %h(i+1)=plot_signal(S.sensor{s}.matlabtime,S.sensor{s}.sampleNorm,color{rem(i,length(color)+1)+1},1,offset);
    i=i+1;
end

%legend(h,legend_text,'Interpreter', 'none');
xlabel('Time');
ylabel('Magnitude');


mattime=convert_timestamp_matlabtimestamp(G,S.report_smoking_timestamp);




hold on;
plot([mattime,mattime],ylim,'r-','LineWidth',2);
hold on;
text(mattime, 0  , 'Smoking Report', 'Color', 'k','FontSize',18,'Rotation',90);
filename=['C:\Users\smhssain\Desktop\smoking\figures\_' pid '_' sid '_e' num2str(n) '.bmp'];
print (gcf, '-dbmp', filename);

end
