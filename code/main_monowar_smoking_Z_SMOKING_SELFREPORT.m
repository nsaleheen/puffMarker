% Both for NIDA,NIDAc and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_smoking_9_SMOKING_SELFREPORT()
clear all
G=config();
G=config_run_monowar_Memphis_Smoking(G);

PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
%        read_selfreport_smokingposition(G,pid,sid,'raw','formattedraw');
%        read_selfreport_smokingposition(G,pid,sid,'raw','formatteddata');
%        read_selfreport_smokingposition(G,pid,sid,'raw','basicfeature');
        read_selfreport_smokingposition(G,pid,sid,'raw','preprocess');
    end
end
end
