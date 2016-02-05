close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
PS_LIST=G.PS_LIST;
R.pid=[];R.sid=[];R.episode=[];R.puff=[];R.starttimestamp=[];R.endtimestamp=[];
pid='p01';sid='s02';e=1;p=2; type='standing_gyr';% standing
pid='p03';sid='s03';e=2;p=10; type='sitting_gyr';  % sitting
pid='p03';sid='s03';e=1;p=6; type='walking_gyr'; % walking

lw=3;
INDIR='segment_rip';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
id=P.smoking_episode{e}.puff.acl.id;
stime=P.smoking_episode{e}.puff.acl.starttimestamp(p)-5000;
etime=P.smoking_episode{e}.puff.acl.endtimestamp(p)+10000;
if id==1, IDS=[G.SENSOR.WL9_GYRXID:G.SENSOR.WL9_GYRZID]; else IDS=[G.SENSOR.WR9_GYRXID:G.SENSOR.WR9_GYRZID];end;
h=figure;hold on;
%title([pid ' ' sid ' episode=' num2str(e) ' puff=' num2str(p) ' missing=' num2str(P.smoking_episode{e}.puff.acl.missing(p)) ' valid=' num2str(P.smoking_episode{e}.puff.acl.valid(p))]);hold on;
xlabel('Time (in second)');
%ylabel('Magnitude');
offset=50;
%color={[0,0.7,0],[0,0.25,0.5],[0.8,0.4,0],[0,0.7,0],[0,0.25,0.5],[0.8,0.4,0]};

color={'r-','g-','b-','r-','g-','b-'};
now=1;
l=0;
ind=find(P.wrist{id}.timestamp>=stime & P.wrist{id}.timestamp<=etime);
mx=max(P.wrist{id}.magnitude(ind));mn=min(P.wrist{id}.magnitude(ind));
mg=100*(P.wrist{id}.magnitude(ind)-mn)/(mx-mn);
mg_800=100*(P.wrist{id}.magnitude_800(ind)-mn)/(mx-mn);
mg_8000=100*(P.wrist{id}.magnitude_8000(ind)-mn)/(mx-mn);

plot((P.wrist{id}.timestamp(ind)-stime)/1000, mg+offset,'k-','linewidth',2);
plot((P.wrist{id}.timestamp(ind)-stime)/1000, mg_800+offset,'b-','linewidth',2);
plot((P.wrist{id}.timestamp(ind)-stime)/1000, mg_8000+offset,'r-','linewidth',2);

offset=offset+110;

for ids=IDS
    if ids==1,
        [a,b]=binarysearch(P.sensor{ids}.timestamp,stime,etime);
        ind=a:b;
%        mx=max(P.sensor{ids}.sample_new(ind));mn=min(P.sensor{ids}.sample_new(ind));
%        sample=100*(P.sensor{ids}.sample_new(ind)-mn)/(mx-mn);
        sample=P.sensor{ids}.sample_new(ind);
        plot((P.sensor{ids}.timestamp(ind)-stime)/1000,sample+offset,color{now},'linewidth',lw);
        plot(xlim,[offset,offset],'k--');
    else
        ind=find(P.sensor{ids}.timestamp>=stime & P.sensor{ids}.timestamp<=etime);
        %                    if isempty(ind), continue;end;
%        mx=1000;mn=-1000;
        mx=max(P.sensor{ids}.sample(ind));mn=min(P.sensor{ids}.sample(ind));
        sample=100*(P.sensor{ids}.sample(ind)-mn)/(mx-mn);
%        sample=P.sensor{ids}.sample(ind);
        plot((P.sensor{ids}.timestamp(ind)-stime)/1000,sample+offset,color{now},'linewidth',lw);
        %                        plot(xlim,[-600,-600]+offset,'k:');
        plot(xlim,[50,50]+offset,color{now},'linestyle','--');
        %                        plot(xlim,[600,600]+offset,'k:');
    end
    offset=offset+130;now=now+1;
    
end
%{
for pp=p-1:p
plot(([P.smoking_episode{e}.puff.gyr.starttimestamp(pp),P.smoking_episode{e}.puff.gyr.starttimestamp(pp)]-stime)/1000,ylim,'k-','linewidth',lw);
hold on;text((P.smoking_episode{e}.puff.gyr.starttimestamp(pp)-stime)/1000, 800  ,{' Hand';'   at';' Mouth'}, 'Color', 'k','FontSize',18);

plot(([P.smoking_episode{e}.puff.gyr.endtimestamp(pp),P.smoking_episode{e}.puff.gyr.endtimestamp(pp)]-stime)/1000,ylim,'k-','linewidth',lw);
%text((P.smoking_episode{e}.puff.gyr.endtimestamp(pp)-stime)/1000-0.5, 100  ,'Puff End', 'Color', 'k','FontSize',18,'Rotation',90);

end
%}
set(findall(gcf,'type','text'),'FontSize',24);
set(gca,'FontSize',16,'fontWeight','bold');

x=xlim;
xlim([0,15]);
ylim([20,550]);
ylabel('            Mag.            G_Z            G_Y         G_X                     ');
set(gca,'yticklabel',{[]});

leg={'Mag','Mag(MA=0.8s)', 'Mag(MA=8s)'};
legend(leg,'Location','Northoutside','Orientation','horizontal');

%                label=cellstr(strcat(num2str((0:10:(x(2)/1000))','%d')))';
%                set(gca,'XTickLabel',label);

%str=sprintf('%d_%s_%s_%02d_%02d_%02d',valid,pid,sid,e,p,floor(missing*100));
filename=['C:\Users\smh\Desktop\smoking_fig' G.DIR.SEP 'presentation/' type '.png'];
%set(gcf,'PaperUnits','inches','PaperSize',[16,8],'PaperPosition',[0 0 16 8])
print('-dpng','-r100',filename);
print('-depsc',[filename '.eps']);
%                saveas(h,[filename '.fig']);
disp('abc');
