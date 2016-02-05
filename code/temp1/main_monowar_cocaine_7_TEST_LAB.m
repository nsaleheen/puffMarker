function [TOT,C_PASS,A_PASS,C_FAIL,A_FAIL,MA,MC,D,O]=main_monowar_cocaine_7_TEST_LAB(G,fig)
PS_LIST=G.PS_LIST;
main_monowar_cocaine_5_TEST_PREP(G,PS_LIST);

load([G.STUDYNAME '_test.mat']);
load([G.STUDYNAME '_tau.mat']);
TOT=0;C_PASS=0;A_PASS=0;MA=[];MC=[];D=[];O=[];A_FAIL=0;C_FAIL=0;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    [tot,c_pass,a_pass,c_fail,a_fail,ma,mc,d,o]=main_monowar_cocaine_7_TEST_PID(G,pid,E,result,fig);
    TOT=TOT+tot;
    C_PASS=C_PASS+c_pass;C_FAIL=C_FAIL+c_fail;
    A_PASS=A_PASS+a_pass;A_FAIL=A_FAIL+a_fail;
    MA=[MA ma];MC=[MC mc];D=[D d]; O=[O o];
end
end