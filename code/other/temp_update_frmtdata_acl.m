function temp_update_frmtdata_acl(G,INDIR)
indir=[G.DIR.DATA G.DIR.SEP INDIR];

files=dir(indir);
for i=3:length(files)
    load([indir G.DIR.SEP files(i).name]);
    disp(files(i).name);
    for sensorid=[G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID]
        D.sensor{sensorid}.sample_all=D.sensor{sensorid}.sample;
        D.sensor{sensorid}.timestamp_all=D.sensor{sensorid}.timestamp;
        D.sensor{sensorid}.matlabtime_all=D.sensor{sensorid}.matlabtime;
        D.sensor{sensorid}.sample=remove_drift_accel(D.sensor{sensorid}.sample_all);
    end;
    save([indir G.DIR.SEP files(i).name],'D');
    clear D;
end
end
