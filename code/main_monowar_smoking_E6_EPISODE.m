close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
% G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
%        pid='p16';sid='s02';
        fprintf('pid=%s sid=%s\n',pid,sid);
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','map',[2,1],'selfreport','svm');
        INDIR='svm_output';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];load([indir G.DIR.SEP infile]);
        for i=1:2
            count=0;
            P.wrist{i}.gyr.segment.svm_episode=[];
            ind=find(P.wrist{i}.gyr.segment.svm_predict==1);
            for j=ind
                stime=P.wrist{i}.gyr.segment.starttimestamp(j);
                etime=stime+6*60*1000;
                x=find(P.wrist{i}.gyr.segment.starttimestamp>=stime & P.wrist{i}.gyr.segment.endtimestamp<=etime & P.wrist{i}.gyr.segment.svm_predict==1);
%                 x=find( (P.wrist{1}.gyr.segment.starttimestamp>=stime & P.wrist{1}.gyr.segment.endtimestamp<=etime  & P.wrist{1}.gyr.segment.svm_predict==1) | (P.wrist{2}.gyr.segment.starttimestamp>=stime  & P.wrist{2}.gyr.segment.endtimestamp<=etime  & P.wrist{2}.gyr.segment.svm_predict==1));

                if length(x)>=6,
                    dist=diff(P.wrist{i}.gyr.segment.endtimestamp(x))/1000;
%                    pos=find(dist>2*60);
%                    if ~isempty(pos), continue;end;
%                    if ~isempty(pos) && pos(1)<8, continue;end;
%                    if 
%                     if ~isempty(pos) 
%                         etime=P.wrist{i}.gyr.segment.endtimestamp(x(pos(1)+1));
%                     else etime=P.wrist{i}.gyr.segment.endtimestamp(x(end));
%                     end
                     count=count+1;
                    P.wrist{i}.gyr.segment.svm_episode.starttimestamp(count)=stime;
                    P.wrist{i}.gyr.segment.svm_episode.endtimestamp(count)=etime;
                    P.wrist{i}.gyr.segment.svm_episode.startmatlabtime(count)=convert_timestamp_matlabtimestamp(G,stime);
                    P.wrist{i}.gyr.segment.svm_episode.endmatlabtime(count)=convert_timestamp_matlabtimestamp(G,etime);
                end
            end
        end
        OUTDIR='svm_output';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'P');
        plot_custom(G,pid,sid,'svm_output','plot_svm_output_episode_new',[],'smokinglabel','segment_gyr','map',[2,1],'selfreport','svm','episode');
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output_episode',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm','episode');
        
        disp('abc');
    end
end
