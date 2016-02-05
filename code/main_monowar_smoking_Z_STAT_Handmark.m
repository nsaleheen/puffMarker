close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);

PS_LIST=G.PS_LIST;
dist=[];mag=[];
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        INDIR='preprocess';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end
        load([indir G.DIR.SEP infile]);
        for e=1:length(P.smoking_episode)
            if isempty(P.smoking_episode{e}.puff), continue;end;
            if P.smoking_episode{e}.puff.acl.hand=='R', id=2;else id=1;end;
            for i=1:length(P.smoking_episode{e}.puff.acl.starttimestamp)
                if P.smoking_episode{e}.puff.acl.starttimestamp(i)==-1, continue;end;
                if P.smoking_episode{e}.puff.acl.missing(i)==1, continue;end;
                dist=[dist,P.smoking_episode{e}.puff.acl.endtimestamp(i)-P.smoking_episode{e}.puff.acl.starttimestamp(i)];
                stime=P.smoking_episode{e}.puff.acl.starttimestamp(i);
                etime=P.smoking_episode{e}.puff.acl.endtimestamp(i);
                ind=find(P.wrist{id}.magnitude.timestamp>=stime & P.wrist{id}.magnitude.timestamp<=etime);
                mag=[mag, P.wrist{id}.magnitude.sample(ind)];
            end
        end
    end
end
disp('abc');
figure;hist(dist);
figure; hist(mag);
