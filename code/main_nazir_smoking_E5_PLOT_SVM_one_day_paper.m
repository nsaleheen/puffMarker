close all
clear all
G=config();
% G=config_run_monowar_Memphis_Smoking_Lab(G);
% G=config_run_monowar_Memphis_Smoking(G);
G=config_run_MinnesotaLab(G);

plot_custom_nazir_gyrMag_aclY_rip(G,'p6020','s01','svm_output_w','plot_results',[],'smokinglabel','gyrmag',[1],'segment_gyr','map',[1],'selfreport','svm');
