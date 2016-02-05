function rr=main_basicfeature_ecg(G,sample,timestamp)

RR_OUTLIER_WINLEN=10*60*1000;

fprintf('...ECG');
fprintf('...detect_rr');rr=detect_RR(G,sample,timestamp);rr.matlabtime=convert_timestamp_matlabtimestamp(G,rr.timestamp);
fprintf('...outlier_rr');rr.quality=detect_outlier_v2(G,rr.sample,rr.timestamp,RR_OUTLIER_WINLEN);

%B = normalize_rrintervals(B);
end
