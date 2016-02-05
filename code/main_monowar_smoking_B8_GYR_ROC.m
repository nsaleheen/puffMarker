close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
R{1}.pitch_mean=[];R{1}.pitch_median=[];R{1}.roll_mean=[];R{1}.roll_median=[];R{1}.valid=[];R{1}.puff=[];R{1}.episode=[];R{1}.missing=[];R{1}.pid=[];R{1}.sid=[];
R{2}.pitch_mean=[];R{2}.pitch_median=[];R{2}.roll_mean=[];R{2}.roll_median=[];R{2}.valid=[];R{2}.puff=[];R{2}.episode=[];R{2}.missing=[];R{2}.pid=[];R{2}.sid=[];
R{1}.pitch_mean_v2=[];R{1}.pitch_median_v2=[];R{1}.roll_mean_v2=[];R{1}.roll_median_v2=[];
R{2}.pitch_mean_v2=[];R{2}.pitch_median_v2=[];R{2}.roll_mean_v2=[];R{2}.roll_median_v2=[];

S.minute=0;S.episode=0;

PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    ppid=str2num(pid(2:end));
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
        fprintf('pid=%s sid=%s\n',pid,sid);
        %         plot_custom(G,pid,sid,'preprocess','handmark_acl_gyr',[G.SENSOR.R_RIPID],...
        %             'bar',[-600,0,600],'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','gyrmag',[2,1],'segment_acl_gyr');
        %
        %         plot_custom(G,pid,sid,'preprocess','handmark_acl_gyr',[G.SENSOR.R_RIPID],...
        %             'bar',[-600,0,600],'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','save',[0.5,0.5],'gyrmag',[2,1],'segment_acl_gyr');
        %         continue;
        INDIR='segment_gyr';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end
        load([indir G.DIR.SEP infile]);
        S.minute=S.minute+length(P.sensor{26}.sample)/(60*16);
        S.episode=S.episode+length(P.smoking_episode);
        for i=1:2
            segno=length(P.wrist{i}.gyr.segment.pitch_median);
            R{i}.pitch_mean=[R{i}.pitch_mean,P.wrist{i}.gyr.segment.pitch_mean];
            R{i}.pitch_median=[R{i}.pitch_median,P.wrist{i}.gyr.segment.pitch_median];
            R{i}.roll_mean=[R{i}.roll_mean,P.wrist{i}.gyr.segment.roll_mean];
            R{i}.roll_median=[R{i}.roll_median,P.wrist{i}.gyr.segment.roll_median];

            R{i}.pitch_mean_v2=[R{i}.pitch_mean_v2,P.wrist{i}.gyr.segment.pitch_mean_v2];
            R{i}.pitch_median_v2=[R{i}.pitch_median_v2,P.wrist{i}.gyr.segment.pitch_median_v2];
            R{i}.roll_mean_v2=[R{i}.roll_mean_v2,P.wrist{i}.gyr.segment.roll_mean_v2];
            R{i}.roll_median_v2=[R{i}.roll_median_v2,P.wrist{i}.gyr.segment.roll_median_v2];
            
            
            R{i}.valid=[R{i}.valid,P.wrist{i}.gyr.segment.valid_length+P.wrist{i}.gyr.segment.valid_height];
            R{i}.puff=[R{i}.puff,P.wrist{i}.gyr.segment.puff];
            R{i}.missing=[R{i}.missing,P.wrist{i}.gyr.segment.missing];
            R{i}.episode=[R{i}.episode,P.wrist{i}.gyr.segment.episode];
            R{i}.pid=[R{i}.pid,ones(1,segno)*ppid];
            R{i}.sid=[R{i}.sid,ones(1,segno)*ssid];
        end
    end
end
fprintf('Total Hour=%f\n',S.minute/60);
fprintf('# of episodes=%d\n',S.episode);
fprintf('Segment(L)=%d Segment(R)=%d\n',length(R{1}.valid),length(R{2}.valid));
fprintf('ValidSegment(L)=%d ValidSegment(R)=%d\n',length(find(R{1}.valid==0)),length(find(R{2}.valid==0)));


RA.pitch_median=[];RA.roll_median=[];RA.valid=[];RA.puff=[];RA.episode=[];RA.missing=[];
for i=1:2
    ind=find(R{i}.missing<=0.33 & R{i}.valid==0);
%    RA{i}.pitch_mean=R{i}.pitch_mean(ind);
    RA.pitch_median=[RA.pitch_median,R{i}.pitch_median(ind)];
%    RA{i}.roll_mean=R{i}.roll_mean(ind);
    RA.roll_median=[RA.roll_median,R{i}.roll_median(ind)];
    RA.valid=[RA.valid, R{i}.valid(ind)];
    RA.puff=[RA.puff, R{i}.puff(ind)];
    RA.episode=[RA.episode,R{i}.episode(ind)];
    RA.missing=[RA.missing, RA.missing,R{i}.missing(ind)];
end;
ind=find(RA.puff==1);
[a,b]=max(RA.pitch_median(ind));
RA.puff(ind(b))=0;
plot_hist_roll_pitch_emre_v2(RA);
%A=find_error_roll_pitch_emre(RA);
A=find_error_roll_pitch_emre_oneclass_v3_LRcombine(RA);
RP.TH(1)=A.puff_nonpuff{1}.th_100;
RP.TH(2)=A.puff_nonpuff{2}.th_100;
RP.TH(3)=A.puff_nonpuff{3}.th_100;
RP.TH(4)=A.puff_nonpuff{4}.th_100;
RP.ROLL_MEAN=A.rp{1}.p_mean;
RP.PITCH_MEAN=A.rp{2}.p_mean;
RP.ROLL_STD=A.rp{1}.p_std;
RP.PITCH_STD=A.rp{2}.p_std;
RP.SIGMA=A.puff_nonpuff{4}.SIGMA;
RP.MEAN=A.puff_nonpuff{4}.MEAN;
save('A.mat','A');
save('RP.mat','RP');


%{
RA=[];
for i=1:2
    ind=find(R{i}.missing<=0.33 & R{i}.valid==0);
%    RA{i}.pitch_mean=R{i}.pitch_mean(ind);
    RA{i}.pitch_median=R{i}.pitch_median(ind);
%    RA{i}.roll_mean=R{i}.roll_mean(ind);
    RA{i}.roll_median=R{i}.roll_median(ind);
    RA{i}.valid=R{i}.valid(ind);RA{i}.puff=R{i}.puff(ind);RA{i}.episode=R{i}.episode(ind);RA{i}.missing=R{i}.missing(ind);
end;
ind=find(RA{2}.puff==1);
[a,b]=min(RA{2}.pitch_median(ind));
RA{2}.puff(ind(b))=0;
%plot_hist_roll_pitch_emre(RA);
%A=find_error_roll_pitch_emre(RA);
A=find_error_roll_pitch_emre_oneclass_v2(RA);
RP.TH(1)=A{1}.puff_nonpuff{2}.th_100;RP.TH(2)=A{2}.puff_nonpuff{2}.th_100;
RP.ROLL_MEAN(1)=A{1}.rp{1}.p_mean;RP.ROLL_MEAN(2)=A{2}.rp{1}.p_mean;
RP.PITCH_MEAN(1)=A{1}.rp{2}.p_mean;RP.PITCH_MEAN(2)=A{2}.rp{2}.p_mean;
RP.ROLL_STD(1)=A{1}.rp{1}.p_std;RP.ROLL_STD(2)=A{2}.rp{1}.p_std;
RP.PITCH_STD(1)=A{1}.rp{2}.p_std;RP.PITCH_STD(2)=A{2}.rp{2}.p_std;
%save('A.mat','A');
%save('RP.mat','RP');

%}
