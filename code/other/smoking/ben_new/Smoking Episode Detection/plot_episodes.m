function plot_episodes(windows,Yhat, P, puffL,puffR,probL,probR,Y,self_report,fig)

  num_windows=size(windows,1);
  figure(fig);
%  figure(fig,'Position', [100, 100, 1000, 200]);
  clf;
  hold on;
  
  idx = find(probL>=0.05);
  probL  = probL(idx);

  idx = find(probR>=0.05);
  probR  = probR(idx);
  
  grid on;
  plot(puffL,1.0 + probL/12,'r.');
  plot(puffR,1.1 + probR/12,'b.');
  plot(mean(windows,2),1.2+P/11,'r-');
  
  for i=1:num_windows
    if(Yhat(i)==2);
      plot(windows(i,:),1.3*ones(1,2),'r-','linewidth',10);
     end 
    if(Y(i)==2);
      plot(windows(i,:),1.4*ones(1,2),'k-','linewidth',10);
     end 
  end
  
  for i=1:length(self_report)
    plot(self_report(i)*[1,1],[1,1.4],'k');
  end
  
  set(gca,'ytick',[1,1.1,1.2,1.3,1.4]);
  set(gca,'yticklabel',{'LPuff','RPuff','Phat','Yhat','Ytrue'});