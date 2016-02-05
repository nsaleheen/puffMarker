clear all
%% Basic Configureation files
%
G=config();
%  G=config_run_monowar_Memphis_Smoking_Lab(G);
G=config_run_MinnesotaLab(G);
PS_LIST=G.PS_LIST;
pno=size(PS_LIST);

for p=1:pno
	pid=char(PS_LIST{p,1});
    main_rawinfo(G,pid,'raw');
end
