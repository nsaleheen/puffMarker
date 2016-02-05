clear all
close all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);

PS_LIST=G.PS_LIST;
R.puff=[];
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    ppid=str2num(pid(2:end));
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
        fprintf('pid=%s sid=%s ',pid,sid);
        INDIR='segment_rip';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if isempty([indir G.DIR.SEP infile]),    disp(['FILE NOT FOUND' indir G.DIR.SEP infile]);return;end; load([indir G.DIR.SEP infile]);
        for e=1:length(P.smoking_episode)
            if isfield(P.smoking_episode{e},'puff')==0, continue;end
            if isempty(P.smoking_episode{e}.puff), continue;end;
           
            for pp=2:length(P.smoking_episode{e}.puff.gyr.peak_ind)
                if P.smoking_episode{e}.puff.gyr.peak_ind(pp-1)==-1, continue;end;
                if P.smoking_episode{e}.puff.gyr.peak_ind(pp)==-1, continue;end;
                x=P.smoking_episode{e}.puff.gyr.peak_ind(pp)-P.smoking_episode{e}.puff.gyr.peak_ind(pp-1);
                
                R.puff=[R.puff,x/2];
            end
        end
        disp('abc');
    end
end
min(R.puff):max(R.puff)
hist(R.puff,min(R.puff):max(R.puff));
xlabel('Number of Respiration Cycle');
ylabel('Frequency');
title('Number of Respiration Cycle between Two Puffs');
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');
