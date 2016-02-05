close all
clear all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);time=[0.5,0.5];
%G=config_run_monowar_Memphis_Smoking(G);time=[15,5];
G=config_run_MinnesotaLab(G);time=[0.5,0.5];

PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        plot_smoking_nazir(G,pid,sid,'basicfeature','plot_smoking_nazir_right_test',time);

        %missing_RIP_cycle(G,pid,sid,'preprocess');
        %        calculate_acl_features(G,pid,sid,'preprocess','preprocess');
        
%        report_smoking(G,pid,sid,'formatteddata');
        disp('abc');

    end
    disp('def');
end
fprintf(') =>  done\n');
