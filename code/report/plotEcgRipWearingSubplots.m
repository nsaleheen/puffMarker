ecg_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_ecg.csv');
rip_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_rip.csv');
wearingTimes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_wearing.csv');

participant=36;
day=3;
load('c:\dataProcessingFrameworkV2\data\memphis\formatteddata\p36_s03_frmtdata.mat')


figure;
subplot(211);plot(D.sensor{1}.timestamp,D.sensor{1}.sample)
title(['p' num2str(participant) ' s' num2str(day) ' rip']);
subplot(212);plot(D.sensor{2}.timestamp,D.sensor{2}.sample)
title(['p' num2str(participant) ' s' num2str(day) ' ecg']);
subplot(212);hold on;
ind=find(ecg_episodes(:,1)==participant & ecg_episodes(:,2)==day);
for i=1:length(ind)
    plot([ecg_episodes(ind(i),3) ecg_episodes(ind(i),4)],[3500 3500],'g');
    text(ecg_episodes(ind(i),3),3400, num2str(i));
end
wearing=find(wearingTimes(:,1)== participant & wearingTimes(:,2)==day);
for i=1:length(wearing)
    plot([wearingTimes(wearing(i),3) wearingTimes(wearing(i),4)],[4000 4000],'r');
end


subplot(211);hold on;
ind2=find(rip_episodes(:,1)==participant & rip_episodes(:,2)==day);
for i=1:length(ind2)
    plot([rip_episodes(ind2(i),3) rip_episodes(ind2(i),4)],[3500 3500],'g');
    text(rip_episodes(ind2(i),3),3400, num2str(i));
end
wearing=find(wearingTimes(:,1)== participant & wearingTimes(:,2)==day);
for i=1:length(wearing)
    plot([wearingTimes(wearing(i),3) wearingTimes(wearing(i),4)],[4000 4000],'r');
    text(wearingTimes(wearing(i),3),3900, num2str(i));
end
% (cursor_info2.Position(1)-cursor_info1.Position(1))
% subplot(212);hold on;
% ind=find(D.sensor{2}.quality.value==0);
% for i=1:length(ind)
%     plot([D.sensor{2}.quality.starttimestamp(ind(i)) D.sensor{2}.quality.endtimestamp(ind(i))],[3000 3000],'r');
% end
% 
% for i=1:size(wearingEpisodes,1)
%     plot([wearingEpisodes(i,3) wearingEpisodes(i,4)],[4000 4000],'r');
% end