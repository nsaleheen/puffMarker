function plot_tau(pids,res)
    [tau_ac,height_ac,dose_ac,acl_ac,duration_ac,r2_ac]=find_tau(pids,res,'a',1);
    [tau_an,height_an,dose_an,acl_an,duration_an,r2_an]=find_tau(pids,res,'a',0);
    [tau_rc,height_rc,dose_rc,acl_rc,duration_rc,r2_rc]=find_tau(pids,res,'r',1);
    [tau_rn,height_rn,dose_rn,acl_rn,duration_rn,r2_rn]=find_tau(pids,res,'r',0);
    figure;plot(tau_ac,ones(1,length(tau_ac)),'ro');
    hold on;plot(tau_an,2*ones(1,length(tau_an)),'bo');
    hold on;plot(tau_rc,3*ones(1,length(tau_rc)),'go');
    hold on;plot(tau_rn,4*ones(1,length(tau_rn)),'ko');
    ylim([0,5]);
    plot_hist2(tau_ac,tau_an,'Activation (blue=activity, red=cocaine)');
    plot_hist2(tau_rc,tau_rn,'Recovery (blue=activity, red=cocaine)');

end
function plot_hist2(Q, R,t)
figure;hold on;
title(t, 'FontSize', 14);
set(gca,'FontSize',14);
xvalues=(0:0.5:22);
hist(Q,xvalues);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','w','facealpha',0.75)
hold on;
hist(R,xvalues);
h1 = findobj(gca,'Type','patch');
set(h1,'facealpha',0.75);
end
function [tau,height,dose,acl,duration,r2]=find_tau(pids,res,a_r,c_n)
tau=[];height=[];dose=[];acl=[];duration=[];r2=[];
for i=1:length(pids)
    for r=1:length(res)
        if strcmp(res{r}.pid,pids{i})~=1, continue, end;
        if res{r}.a_r~=a_r, continue;end;
        if res{r}.c_n~=c_n, continue;end;
        if c_n==1 && res{r}.dose~=20 && res{r}.dose~=40 && res{r}.dose~=10, continue;end;
        tau=[tau res{r}.b.tau1];
        height=[height res{r}.height];
        dose=[dose res{r}.dose];
        duration=[duration res{r}.duration];
        acl=[acl mean(res{r}.acl.value)];
        r2=[r2 res{r}.g.rsquare];
    end
end
end
%{
figure;h(1)=plot(tnr*24*60,snr,'b.');legend_text{1}='Activity Recovery';
    hold on;h(2)=plot(tcr*24*60,scr,'r.');legend_text{2}='Cocaine Recovery';
    legend(h,legend_text,'Interpreter', 'none');
    title('Recovery Curve');
    set(gca,'FontSize',14);
    legend(h,legend_text,'Interpreter', 'none');
    xlabel('Time (Minute)','FontSize',14);
    ylabel('RR values','FontSize',14);

    figure;h(1)=plot(tna*24*60,sna,'b.');legend_text{1}='Activity Activation';
    hold on;h(2)=plot(tca*24*60,sca,'r.');legend_text{2}='Cocaine Activation';
    legend(h,legend_text,'Interpreter', 'none');
    title('Activation Curve');
    set(gca,'FontSize',14);
    legend(h,legend_text,'Interpreter', 'none');
    xlabel('Time (Minute)','FontSize',14);
    ylabel('RR values','FontSize',14);
    
    [bcr,gcr]=recovery(tcr*24*60,scr,1);
    [bnr,gnr]=recovery(tnr*24*60,snr,1);
    [bna,gna]=activation(tna*24*60,sna,1);
    [bca,gca]=activation(tca*24*60,sca,1);
    ca_tau=[];ca_b1=[];ca_height=[];ca_duration=[];
    na_tau=[];na_b1=[];na_height=[];na_duration=[];
    cr_tau=[];cr_b1=[];cr_height=[];cr_duration=[];
    nr_tau=[];nr_b1=[];nr_height=[];nr_duration=[];
    
    for i=1:length(CA)
        ca_tau=[ca_tau CA(i).b.tau1];
 %       ca_b1=[ca_b1 CA(i).b.b1];
        ca_height=[ca_height CA(i).height];
        ca_duration=[ca_duration CA(i).duration];
    end
    for i=1:length(NA)
        na_tau=[na_tau NA(i).b.tau1];
%        na_b1=[na_b1 NA(i).b.b1];
        na_height=[na_height NA(i).height];
        na_duration=[na_duration NA(i).duration];
    end
    for i=1:length(CR)
        cr_tau=[cr_tau CR(i).b.tau2];
%        cr_b1=[cr_b1 CR(i).b.b1];
        cr_height=[cr_height CR(i).height];
        cr_duration=[cr_duration CR(i).duration];
    end
    for i=1:length(NR)
        nr_tau=[nr_tau NR(i).b.tau2];
%        nr_b1=[nr_b1 NR(i).b.b1];
        nr_height=[nr_height NR(i).height];
        nr_duration=[nr_duration NR(i).duration];
    end
    
%    figure;plot(c_tau,ones(1,length(c_tau)),'ro');
%    hold on; plot(n_tau,2*ones(1,length(n_tau)),'bo');
%    ylim([0,4]);
    figure;plot(ca_tau,ones(1,length(ca_tau)),'ro');
    hold on;plot(na_tau,2*ones(1,length(na_tau)),'bo');
    hold on;plot(cr_tau,3*ones(1,length(cr_tau)),'go');
    hold on;plot(nr_tau,4*ones(1,length(nr_tau)),'ko');
    ylim([0,5]);
    figure;plot(ca_height,ca_tau,'ro');
    hold on;plot(na_height,na_tau,'bo');
    figure;plot(cr_height,cr_tau,'ro');
    hold on;plot(nr_height,nr_tau,'bo');
    
    figure;plot(c_duration,c_tau,'ro');
    hold on;plot(n_duration,n_tau,'bo');
    ylim([0,4]);
    
%    disp([' Cocaine Tau: ' median(C.tau1) 'Noncocaine Tau: ' median(N.tau1)]);
%    NN{str2num(pid(2:end))}=N.tau1;
%    CC{str2num(pid(2:end))}=C.tau1;
    disp('abc');

end
%}