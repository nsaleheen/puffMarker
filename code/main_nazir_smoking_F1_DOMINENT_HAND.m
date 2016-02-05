function main_nazir_smoking_F1_DOMINENT_HAND()
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
        % G=config_run_monowar_Memphis_Smoking_Lab(G);
    % G=config_run_monowar_Memphis_Smoking(G);
    %G=config_run_MinnesotaLab(G);

    PS_LIST=G.PS_LIST;
    for p=1:size(PS_LIST,1)
        pid=char(PS_LIST{p,1});
        slist=PS_LIST{p,2};
        for s=slist
            sid=char(s);
            fprintf('pid=%s sid=%s :: ',pid,sid);
            INDIR='preprocess_wrist3';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
            P=calculate_interpolate(G,P);

            [left_magnitude,left_timestamp] = find_magnitude(P,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID);
            [right_magnitude,right_timestamp] = find_magnitude(P,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID);

%             length(left_magnitude)
%             length(right_magnitude)
%             plot(left_magnitude);
          
            left_total_mag = mag_sum(left_magnitude);
            right_total_mag = mag_sum(right_magnitude);
    
            fprintf('left=%d right=%d diff: %d\n',left_total_mag,right_total_mag, left_total_mag-right_total_mag);
         end
        fprintf(') =>  done\n');
    end
end
function [mag,timestamp]=find_magnitude(P,IDS)
mag=zeros(1,length(P.sensor{IDS(1)}.sample_interpolate));
for id=IDS
    mag=mag+P.sensor{id}.sample_interpolate.*P.sensor{id}.sample_interpolate;
end
mag=sqrt(mag);
timestamp=P.sensor{IDS(1)}.timestamp_interpolate;
end

function total=mag_sum(sample)
total =0;
cnt=0;
for i=1:length(sample)
    if ~isnan(sample(i))
    total = total + (sample(i));
    cnt=cnt+1;
    end
    if cnt>0
        total = total;
    end   
end
end