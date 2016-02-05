function B=main_basicfeature_rip_updated(G,B)
B.sensor{G.SENSOR.R_RIPID}.sample_new=RIP_recover_9_2(B.sensor{G.SENSOR.R_RIPID}.sample,B.sensor{G.SENSOR.R_RIPID}.timestamp);
[B.sensor{G.SENSOR.R_RIPID}.peakvalley_new_1,B.sensor{G.FEATURE.R_RIPID}.peakvalley_new_2]=main_basicfeature_rip(G,B.sensor{G.SENSOR.R_RIPID}.sample_new,B.sensor{G.SENSOR.R_RIPID}.timestamp);

end

