function outlier=detect_outlier_v2(G,sample,timestamp,winlen)
outlier=[];
if isempty(timestamp), return;end;

    ind=find(sample>0.3 & sample<2);
    valid_rrInterval=sample(ind);
    valid_timestamp=timestamp(ind);
    
%     rrInterval=[standard_rrInterval sample(2:end)];
  
    diff_rrInterval=abs(diff(valid_rrInterval));
    MED=4.5*0.5*iqr(diff_rrInterval);
    MAD=(median(valid_rrInterval)-2.9*0.5*iqr(diff_rrInterval))/3;
    CBD=(MED+MAD)/2;
    if (CBD<0.2)
        CBD=0.2;
    end
    
    outlier=ones(1,size(sample,2))*G.QUALITY.BAD;
    outlier(1)=G.QUALITY.GOOD;
    standard_rrInterval=valid_rrInterval(1);
    prev_beat_bad=0;
    for i=2:length(valid_rrInterval)-1
        ref=valid_rrInterval(i);
        if (valid_rrInterval(i)>.3 && valid_rrInterval(i)<2)
%                            
%                
               beat_diff_prevGood=abs(standard_rrInterval-valid_rrInterval(i));
               beat_diff_pre=abs(valid_rrInterval(i-1)-valid_rrInterval(i));
               beat_diff_post=abs(valid_rrInterval(i)-valid_rrInterval(i+1));
           if(prev_beat_bad==1 && beat_diff_prevGood<CBD)
                 ind1=find(timestamp==valid_timestamp(i)); 
                 outlier(ind1)=G.QUALITY.GOOD;
                 prev_beat_bad=0;
                 standard_rrInterval=valid_rrInterval(i);
           elseif (prev_beat_bad==1 && beat_diff_prevGood>CBD && beat_diff_pre<=CBD && beat_diff_post<=CBD)
                 ind1=find(timestamp==valid_timestamp(i)); 
                 outlier(ind1)=G.QUALITY.GOOD;
                 prev_beat_bad=0;
                 standard_rrInterval=valid_rrInterval(i);
                      
            elseif (prev_beat_bad==1 && beat_diff_prevGood>CBD && (beat_diff_pre>CBD || beat_diff_post>CBD))
                 prev_beat_bad=1;          
                 
            elseif (prev_beat_bad==0 && beat_diff_pre<=CBD)
                    ind1=find(timestamp==valid_timestamp(i)); 
                    outlier(ind1)=G.QUALITY.GOOD;
                    prev_beat_bad=0;
                    standard_rrInterval=valid_rrInterval(i);
            elseif(prev_beat_bad==0 && beat_diff_pre>CBD)
                prev_beat_bad=1;
              
            end
       end
        
    end

% startT=timestamp(1);
% total=size(timestamp,2);
% while startT<=timestamp(end)
%     endT=startT+winlen;
%     indT=find(timestamp>=startT & timestamp<=endT);
%     samples=sample(indT);
    
    
    
%     u=median(diff_rrInterval)+ CBD;
%     l=median(diff_rrInterval)- CBD;
    
%     ind=(find(diff_rrInterval>l & diff_rrInterval<u));
%       outlier=ones(1,size(diff_rrInterval,2))*G.QUALITY.BAD;
%       outlier(ind)=G.QUALITY.GOOD;

%       ind_good=(find(diff_rrInterval<CBD));
%       outlier=ones(1,size(diff_rrInterval,2))*G.QUALITY.BAD;
%       outlier(ind_good)=G.QUALITY.GOOD;
      
%     outlier=[outlier out];
%     if indT(end)+1>total
%         break;
%     end
%     startT=timestamp(indT(end)+1);
% end
end
