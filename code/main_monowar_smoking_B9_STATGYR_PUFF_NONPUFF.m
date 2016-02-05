close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
R{1}=[];R{2}=[];
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    ppid=str2num(pid(2:end));
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
        fprintf('pid=%s sid=%s\n',pid,sid);
%        plot_custom(G,pid,sid,'segment_gyr','plot_gyr',[],'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','bar',[-600,0,600],'gyrmag',[2,1],'segment_gyr','save',[0.5,0.5]);
%        plot_custom(G,pid,sid,'segment_gyr','plot_gyr',[],'smokinglabel','selfreport','cress','acl',[2,1],'gyrmag',[2,1],'segment_gyr','save',[15,5]);
        
        INDIR='segment_gyr';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);

        for i=1:2
            if isempty(R{i}), R{i}.puff=[];R{i}.missing=[];R{i}.valid_length=[];R{i}.valid_rp=[];R{i}.valid_height=[];end;
            R{i}.puff=[R{i}.puff, P.wrist{i}.gyr.segment.puff];
            R{i}.missing=[R{i}.missing, P.wrist{i}.gyr.segment.missing];
            R{i}.valid_length=[R{i}.valid_length, P.wrist{i}.gyr.segment.valid_length];
            R{i}.valid_rp=[R{i}.valid_rp, P.wrist{i}.gyr.segment.valid_rp];
            R{i}.valid_height=[R{i}.valid_height,P.wrist{i}.gyr.segment.valid_height];
        end
    end
end
for i=1:2
    fprintf('Hand=%d (All        )   TotalSegment=%d TotalPuff=%d\n',i,length(R{i}.puff),length(find(R{i}.puff==1)));
    nmiss=find(R{i}.missing<=0.33);
    fprintf('Hand=%d (NotMissing )   TotalSegment=%d TotalPuff=%d\n',i,length(R{i}.puff(nmiss)),length(find(R{i}.puff(nmiss)==1)));
    hvalid=find(R{i}.valid_height(nmiss)==0);hvalid=nmiss(hvalid);
    fprintf('Hand=%d (Validheight)   TotalSegment=%d TotalPuff=%d\n',i,length(R{i}.puff(hvalid)),length(find(R{i}.puff(hvalid)==1)));

    nvalid=find(R{i}.valid_length(hvalid)==0);nvalid=hvalid(nvalid);
    fprintf('Hand=%d (ValidLength)   TotalSegment=%d TotalPuff=%d\n',i,length(R{i}.puff(nvalid)),length(find(R{i}.puff(nvalid)==1)));
    rpvalid=find(R{i}.valid_rp(nvalid)==0);rpvalid=nvalid(rpvalid);
    fprintf('Hand=%d (ValidRP    )   TotalSegment=%d TotalPuff=%d\n',i,length(R{i}.puff(rpvalid)),length(find(R{i}.puff(rpvalid)==1)));
end
