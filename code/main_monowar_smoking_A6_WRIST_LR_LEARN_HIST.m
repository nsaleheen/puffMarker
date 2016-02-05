function main_monowar_smoking_A6_WRIST_LR_LEARN_HIST()
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
PS_LIST=G.PS_LIST;
time=10*60*1000;
LR_I=0;LR_T=0;LR_INV=0;HLR_I=0;HLR_T=0;HLR_INV=0;
lr_id=fopen('C:\Users\smh\Desktop\smoking_fig\orientation_leftright\lr_smooth.csv','w');

for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s ',pid,sid);
        INDIR='preprocess_wrist';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        P=test_wrist_leftright(G,P,time,pid,sid);
        LR_I=LR_I+length(find(P.wrist{1}.LR.predict==1))+length(find(P.wrist{2}.LR.predict==0));
        LR_INV=LR_INV+length(find(P.wrist{1}.LR.valid==1))+length(find(P.wrist{2}.LR.valid==1));
        LR_T=LR_T+length(P.wrist{1}.LR.predict)+length(P.wrist{2}.LR.predict);
%                fprintf('(LR=(%d,%d)=%f HLR=(%d,%d)=%f(\n',LR_T-LR_I-INV,LR_I,(LR_T-LR_I-INV)*100/(LR_T-INV),HLR_T-HLR_I-HLR_INV,HLR_I,(HLR_T-HLR_I-HLR_INV)*100/(HLR_T-HLR_INV));%,LR_T-LR_I,LR_I,(LR_T-LR_I)*100/LR_T,HLR_T-HLR_I,HLR_I,(HLR_T-HLR_I)*100/HLR_T); 
        %P=correct_orientation(P);        
        P=correct_leftright_using_history(P);
        HLR_I=HLR_I+length(find(P.wrist{1}.LR.predict==1))+length(find(P.wrist{2}.LR.predict==0));
        HLR_INV=HLR_INV+length(find(P.wrist{1}.LR.valid==1))+length(find(P.wrist{2}.LR.valid==1));
        HLR_T=HLR_T+length(P.wrist{1}.LR.predict)+length(P.wrist{2}.LR.predict);
        LR_ACC=(LR_T-LR_I-LR_INV)*100/(LR_T-LR_INV);
        HLR_ACC=(HLR_T-HLR_I-HLR_INV)*100/(HLR_T-HLR_INV);

        fprintf(lr_id,'pid,%s,sid,%s,LR_T,%d,LR_I,%d,LR_INV,%d,LR_ACC,%f,HLR_T,%d,HLR_I,%d,HLR_INV,%d,HLR_ACC,%f\n', ...
            pid,sid,LR_T,LR_I,LR_INV,LR_ACC,HLR_T,HLR_I,HLR_INV,HLR_ACC);
        fprintf('pid,%s,sid,%s,LR_T,%d,LR_I,%d,LR_INV,%d,LR_ACC,%f,HLR_T,%d,HLR_I,%d,HLR_INV,%d,HLR_ACC,%f\n', ...
            pid,sid,LR_T,LR_I,LR_INV,LR_ACC,HLR_T,HLR_I,HLR_INV,HLR_ACC);
        
%        fprintf('(LR=(%d,%d)=%f HLR=(%d,%d)=%f(\n',LR_T-LR_I-INV,LR_I,(LR_T-LR_I-INV)*100/(LR_T-INV),HLR_T-HLR_I-HLR_INV,HLR_I,(HLR_T-HLR_I-HLR_INV)*100/(HLR_T-HLR_INV));%,LR_T-LR_I,LR_I,(LR_T-LR_I)*100/LR_T,HLR_T-HLR_I,HLR_I,(HLR_T-HLR_I)*100/HLR_T); 
%        fprintf('(CI=(%d,%d)=%f LR=(%d,%d)=%f HLR=(%d,%d)=%f\n',CI_T-CI_I,CI_I,(CI_T-CI_I)*100/CI_T);%,LR_T-LR_I,LR_I,(LR_T-LR_I)*100/LR_T,HLR_T-HLR_I,HLR_I,(HLR_T-HLR_I)*100/HLR_T); 
    end
end
fclose(lr_id);
end
