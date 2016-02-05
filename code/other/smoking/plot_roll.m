function plot_roll(G,data,IDS)

for i=IDS
    hold on;
    maxv=max(data.wrist{i}.roll.sample*10);
    y=ylim;
    offset=y(1)-maxv;
    plot(xlim,[0,0]+offset,'k-');
    plot(xlim,[90,90]*10+offset,'k--');
    plot(xlim,[-90,-90]*10+offset,'k--');
    
    plot(data.wrist{i}.roll.matlabtime,data.wrist{i}.roll.sample*10+offset,'m-');
%    plot(data.wrist{i}.roll.matlabtime,data.wrist{i}.roll.sample_filtered+(y(1)-maxv),'r-');
%     s=prctile(data.wrist{i}.roll.sample,95);
%     e=prctile(data.wrist{i}.roll.sample,5);
%     barv=0.2*(s-e)+e;
%     plot(xlim,[barv,barv]+(y(1)-maxv),'k-','linewidth',2);
end
end