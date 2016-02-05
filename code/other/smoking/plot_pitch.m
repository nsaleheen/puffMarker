function plot_pitch(G,data,IDS)

for i=IDS
    hold on;
    maxv=max(data.wrist{i}.pitch.sample*10);
    y=ylim;
    offset=y(1)-maxv;
    plot(xlim,[0,0]+offset,'k-');
    plot(xlim,[90,90]*10+offset,'k--');
    plot(xlim,[-90,-90]*10+offset,'k--');
    plot(data.wrist{i}.pitch.matlabtime,data.wrist{i}.pitch.sample*10+offset,'b-');
%    plot(data.wrist{i}.pitch.matlabtime,data.wrist{i}.pitch.sample_filtered+(y(1)-maxv),'r-');
%     s=prctile(data.wrist{i}.pitch.sample,95);
%     e=prctile(data.wrist{i}.pitch.sample,5);
%     barv=0.2*(s-e)+e;
%     plot(xlim,[barv,barv]+(y(1)-maxv),'k-','linewidth',2);
end
end