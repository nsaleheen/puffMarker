function main_nazir_smoking_F_ROC_usingpostprocessing()
close all
clear all
G=config();

    G=config_run_monowar_Memphis_Smoking_Lab(G);

PS_LIST=G.PS_LIST;

TPRR=[];
FPRR=[];
THH=[];
A=[];
Prob=[];
MatlabTime=[];
    for pp=1:size(PS_LIST,1)
        pid=char(PS_LIST{pp,1});
        slist=PS_LIST{pp,2};
        
        for s=slist
            sid=char(s);
             indir=[G.DIR.DATA G.DIR.SEP 'svm_output'];infile=[pid '_' sid '_svm_output.mat'];
            if exist([indir G.DIR.SEP infile],'file')~=2,return;end; 
            data=load([indir G.DIR.SEP infile]);name=fieldnames(data);data=data.(name{1});

            for i=2:2
                actual=data.wrist{i}.gyr.segment.svm_actual;
				A=[A actual];                
                probability=data.wrist{i}.gyr.segment.svm_probability;
				Prob=[Prob probability];
                MatlabTime=[MatlabTime data.wrist{i}.gyr.segment.startmatlabtime];
			end
		end
	end
	size(A)
    size(Prob)
length(find(Prob>0))
for TH=0.001:0.001:1
    F=0;
    TN=0;
    TP=0;
    FN=0;
    FP=0;
    
   
                actual=A;
                probability=Prob;

                  predict = zeros(1, length(actual));
                   for l=1:length(actual)
                       if probability(l) >= TH
                           predict(l)=1;
                       end
                   end
                   smatlabtimes = MatlabTime;
                   p1pre=length(find(predict==1));
                    predict=post_process(predict, smatlabtimes);

                   F=length(find(actual==0));
                   
                   a0=length(find(actual==0));
                   p0=length(find(predict==0));
                   a1=length(find(actual==1));
                   p1=length(find(predict==1));
                    fprintf('%d %d p0=%d p1=%d p1pre=%d\n', a0, a1, p0, p1, p1pre);
                   if a0 >0 & p0>0
                        TN=TN+length(find(actual==0 & predict==0));
                        FP=FP+length(find(actual==0 & predict==1));
                    end
                    if a1>0 & p1>0
                        TP=TP+length(find(actual==1 & predict==1));    
                        FN=FN+length(find(actual==1 & predict==0));
                    end        
   
    ACC=(TP+TN)/(TP+TN+FP+FN);
    TPR=TP/(TP+FN);
    FPR=FP;%FP/(FP+TN);
    PRC=TP/(TP+FP);
    
    TPRR(end+1)=TPR;
    FPRR(end+1)=FPR;
    THH(end+1)=TH;
%      fprintf('TPR=%f FPR=%f TH=%f \n', TPR, TPR, TH);
end
plot(FPRR/40,TPRR,'g--','linewidth',2);
end

function predict=post_process(predict, smatlabtimes)

    inds=find(predict==1);
    len=length(inds);
    
    diff=(smatlabtimes(inds(2)) - smatlabtimes(inds(1)))*24*60*60;
    if diff > 120
        predict(inds(1))=0;
    end
    diff=(smatlabtimes(inds(len)) - smatlabtimes(inds(len-1)))*24*60*60;
    if diff > 120
        predict(inds(len))=0;
    end
    for j=2:length(inds)-1
        diff1=(smatlabtimes(inds(j)) - smatlabtimes(inds(j-1)))*24*60*60;
        diff2=(smatlabtimes(inds(j+1)) - smatlabtimes(inds(j)))*24*60*60;
        if diff1 > 120 & diff2 > 120
            predict(inds(j))=0;
        end
    end

end