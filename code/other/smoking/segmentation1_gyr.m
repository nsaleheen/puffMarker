function P=segmentation1_gyr(G, P)

for i=1:2
    sample_800=P.wrist{i}.magnitude_800;
    sample_8000=P.wrist{i}.magnitude_8000;
    
    [sind,eind]=calculate_segment_gyr(sample_800,sample_8000);
       
    fprintf('hand=%d segment=%d ',i,length(sind));
    P.wrist{i}.gyr.segment.starttimestamp=P.wrist{i}.timestamp(sind);
    P.wrist{i}.gyr.segment.endtimestamp=P.wrist{i}.timestamp(eind);
    P.wrist{i}.gyr.segment.startmatlabtime=P.wrist{i}.matlabtime(sind);
    P.wrist{i}.gyr.segment.endmatlabtime=P.wrist{i}.matlabtime(eind);
end
end

