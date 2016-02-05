function F=get_good_quality_data_map(inputfile_name)
%GET_GOOD_QUALITY_DATA_MAP Summary of this function goes here
%   Detailed explanation goes here

     F=cell(4);
    F{10,20,20,50}=0;
     
    files = dir('D:\smoking_memphis\data\Memphis_Smoking_Lab\plot\plot_puff_rip_groundtruth\*.png');
    
    for ii = 1:length(files)
       s=files(ii).name;
    [quality s] = strtok(s, '_');
    q_type = str2num(quality);
    [pid s] = strtok(s, '_');
    pid = [pid(2) pid(3)];
    p_id = str2num(pid);
    
    [sid s]=strtok(s, '_');
    sid = [sid(2) sid(3)];
    s_id = str2num(sid);
    
    [eid s]=strtok(s, '_');
    e_id = str2num(eid);
    
    [puffid s]=strtok(s, '_');
    puff_id = str2num(puffid);
    F{p_id,s_id,e_id,puff_id}=1;
    end
end

