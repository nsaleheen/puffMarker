close all
clear all
G=config();
if strcmp(G.DATASET_NAME, 'minnesota_lab')==1
    G=config_run_MinnesotaLab(G);
elseif strcmp(G.DATASET_NAME, 'memphis_lab')==1
    G=config_run_monowar_Memphis_Smoking_Lab(G);
elseif strcmp( G.DATASET_NAME, 'memphis_field')==1
    G=config_run_monowar_Memphis_Smoking(G);
end
PS_LIST=G.PS_LIST;
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
       % fprintf('pid=%s sid=%s\n',pid,sid);
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','map',[2,1],'selfreport','svm');        
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm','save',[15,5]);

%plot_custom(G,pid,sid,'svm_output','plot_svm_output_episode',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm','episode');
% 		plot_custom(G,pid,sid,'svm_output','plot_svm_output_episode',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm');
		indir=[G.DIR.DATA G.DIR.SEP 'svm_output_w'];infile=[pid '_' sid '_svm_output_w.mat'];
		if exist([indir G.DIR.SEP infile],'file')~=2,return;end; 
		data=load([indir G.DIR.SEP infile]);name=fieldnames(data);data=data.(name{1});
		
		total_res_cycle=0;
		total_res_cycle_seg=0;
		total_mpuff = 0;
		total_mpuff_after_del=0;
        total_hand_pref=0;
		for i=1:2
			total_res_cycle = total_res_cycle + length(data.sensor{1}.peakvalley_new_3.sample);			
			
			ind=find(data.wrist{i}.gyr.segment.valid_all==0);
			pind=data.wrist{i}.gyr.segment.peak_ind(ind);pind(pind==0)=[];
			len=length(data.sensor{1}.peakvalley_new_3.sample);
			pind(pind>len)=[];			
			total_res_cycle_seg = total_res_cycle_seg + length(pind);
			
			rind=find(data.wrist{i}.gyr.segment.svm_predict(ind)==1);
			rind=ind(rind);        
			pind=data.wrist{i}.gyr.segment.peak_ind(rind);pind(pind==0)=[];
			len=length(data.sensor{1}.peakvalley_new_3.sample);
			pind(pind>len)=[];
			total_mpuff = total_mpuff+length(pind);
			
			puff_times = data.sensor{1}.peakvalley_new_3.matlabtime(pind);
			cnt=length(puff_times);
            if cnt>1
                diff=(puff_times(2) - puff_times(1))*24*60*60;
                if diff > 100
                    cnt = cnt -1;
                end
                diff=(puff_times(length(puff_times)) - puff_times(length(puff_times)-1))*24*60*60;
                if  diff> 100
                    cnt = cnt -1;
                end			
                for j=2:length(puff_times)-1
                    diff1=(puff_times(j) - puff_times(j-1))*24*60*60;
                    diff2=(puff_times(j+1) - puff_times(j))*24*60*60;
                    if diff1 > 100 & diff2 > 100
                        cnt = cnt -1;
                    end
                end
            else
                cnt=0;
            end
			total_mpuff_after_del = total_mpuff_after_del+ cnt;
            total_hand_pref=max(total_hand_pref, cnt);

			
        end
        fprintf('%s,%s,%d,%s,%d,%d,%d,%d\n', pid, sid, i,num2str(total_res_cycle/4), total_res_cycle_seg, total_mpuff, total_mpuff_after_del, total_hand_pref);
			
        %disp('abc');
    end
end
