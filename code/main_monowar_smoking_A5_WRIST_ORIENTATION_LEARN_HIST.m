function main_monowar_smoking_A5_WRIST_ORIENTATION_LEARN_HIST()
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
PS_LIST=G.PS_LIST;
time=10*60*1000;
CI_I=0;CI_T=0;HCI_I=0;HCI_T=0;CI_INV=0;HCI_INV=0;
ci_id=fopen('C:\Users\smh\Desktop\smoking_fig\orientation_leftright\ci_smooth.csv','w');

for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='preprocess_wrist';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        P=test_wrist_orientation(G,P,time,pid,sid);
        CI_I=CI_I+length(find(P.wrist{1}.CI.predict==1))+length(find(P.wrist{2}.CI.predict==1));
        CI_INV=CI_INV+length(find(P.wrist{1}.CI.valid==1))+length(find(P.wrist{2}.CI.valid==1));
        CI_T=CI_T+length(P.wrist{1}.CI.predict)+length(P.wrist{2}.CI.predict);
        %P=correct_orientation(P);        
        P=correct_orientation_using_history(P);
        HCI_I=HCI_I+length(find(P.wrist{1}.CI.predict==1))+length(find(P.wrist{2}.CI.predict==1));
        HCI_INV=HCI_INV+length(find(P.wrist{1}.CI.valid==1))+length(find(P.wrist{2}.CI.valid==1));
        HCI_T=HCI_T+length(P.wrist{1}.CI.predict)+length(P.wrist{2}.CI.predict);
        CI_ACC=(CI_T-CI_I-CI_INV)*100/(CI_T-CI_INV);
        HCI_ACC=(HCI_T-HCI_I-HCI_INV)*100/(HCI_T-HCI_INV);
        
        fprintf(ci_id,'pid,%s,sid,%s,CI_T,%d,CI_I,%d,CI_INV,%d,CI_ACC,%f,HCI_T,%d,HCI_I,%d,HCI_INV,%d,HCI_ACC,%f\n', ...
            pid,sid,CI_T,CI_I,CI_INV,CI_ACC,HCI_T,HCI_I,HCI_INV,HCI_ACC);
        fprintf('pid,%s,sid,%s,CI_T,%d,CI_I,%d,CI_INV,%d,CI_ACC,%f,HCI_T,%d,HCI_I,%d,HCI_INV,%d,HCI_ACC,%f\n', ...
            pid,sid,CI_T,CI_I,CI_INV,CI_ACC,HCI_T,HCI_I,HCI_INV,HCI_ACC);
        
        %(CI=(%d,%d)=%f HCI=(%d,%d)=%f(\n',CI_T-CI_I-INV,CI_I,(CI_T-CI_I-INV)*100/(CI_T-INV),HCI_T-HCI_I-HCI_INV,HCI_I,(HCI_T-HCI_I-HCI_INV)*100/(HCI_T-HCI_INV));%,LR_T-LR_I,LR_I,(LR_T-LR_I)*100/LR_T,HLR_T-HLR_I,HLR_I,(HLR_T-HLR_I)*100/HLR_T); 
%        fprintf('(CI=(%d,%d)=%f LR=(%d,%d)=%f HLR=(%d,%d)=%f\n',CI_T-CI_I,CI_I,(CI_T-CI_I)*100/CI_T);%,LR_T-LR_I,LR_I,(LR_T-LR_I)*100/LR_T,HLR_T-HLR_I,HLR_I,(HLR_T-HLR_I)*100/HLR_T); 
    end
end
fclose(ci_id);
end
