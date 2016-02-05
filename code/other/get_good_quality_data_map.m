function F=get_good_quality_data_map(inputfile_name)
%GET_GOOD_QUALITY_DATA_MAP Summary of this function goes here
%   Detailed explanation goes here
a=5
F = dir('D:\smoking_memphis\data\Memphis_Smoking_Lab\plot\plot_puff_rip_groundtruth\*.png');
for ii = 1:length(F)
   F(ii).name
end

end

