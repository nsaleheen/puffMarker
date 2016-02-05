%% Data Processing Framework
% Overview: starting point of the framework.
close all
clear all
%% Basic Configureation files
%
G=config();
G=config_run_Minnesota(G);

PS_LIST=G.PS_LIST;

pno=size(PS_LIST);
for p=1:pno
    pid=char(PS_LIST{p,1});    
    slist=PS_LIST{p,2};
    main_rawinfo(G,pid,'raw');
    for s=slist
        sid=char(s);
%        main_formattedraw(G,pid,sid,'raw','formattedraw');
    end;
end
