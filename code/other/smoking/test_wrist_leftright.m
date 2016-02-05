function P=test_wrist_leftright(G,P,time,pid,sid)
%fprintf('...correct_orientation');
Hand=generate_orientation_data(G,P,time);
for i=1:2
    len=length(Hand(i,1).valid);
    if i==1
          P.wrist{i}.LR.valid=Hand(i,1).valid;P.wrist{i}.LR.timestamp=Hand(i,1).timestamp;
          P.wrist{i}.LR.actual=zeros(1,len);P.wrist{i}.LR.predict=zeros(1,len)-1;
    else P.wrist{i}.LR.valid=Hand(i,1).valid;P.wrist{i}.LR.timestamp=Hand(i,1).timestamp;
        P.wrist{i}.LR.actual=ones(1,len);P.wrist{i}.LR.predict=zeros(1,len)-1;
    end
        
    [ac,pr,prob]=run_orientation_model(G,Hand,time,'LR',i,pid,sid);
    i1=find(Hand(i,1).valid==0);P.wrist{i}.LR.predict(i1)=pr;    
end
end
function [AC,PR,PROB]=run_orientation_model(G,Hand,time,type,i,pid,sid)
    i1=find(Hand(i,1).valid==0);
    roll=Hand(i,1).roll(i1);
    pitch=Hand(i,1).pitch(i1);
    features=[roll',pitch'];
    feature_names={'Roll','Pitch'};
    categorynames={type(1),type(2)};
    categories=(cellstr(char((zeros(1,size(features,1))+'?')')));
    fname=[type '_' num2str(time/(60*1000))];
    wekafile=[G.DIR.DATA G.DIR.SEP 'weka\orientation' G.DIR.SEP fname '_' pid '_' sid '_' num2str(i) '.arff'];
    outfile=[G.DIR.DATA G.DIR.SEP 'weka\orientation' G.DIR.SEP fname '_' pid '_' sid '_' num2str(i) '_output.txt'];
    modelfile=[G.DIR.ROOT G.DIR.SEP 'weka\orientation' G.DIR.SEP 'train_' type '_' num2str(time/(60*1000)) '_model.model'];
    write_arff_smoking(wekafile,feature_names,categorynames,features,categories);
    
    Test_Orientation_smoking(modelfile,wekafile,outfile);
    [actual,predict,prob]=TestSVM_parse_results_smoking(outfile);
    PROB=prob;
    AC=zeros(1,length(actual))-1;PR=zeros(1,length(predict));
    AC(strcmp(actual(:),type(1))==1)=0;
    AC(strcmp(actual(:),type(2))==1)=1;
    
    PR(strcmp(predict(:),type(1))==1)=0;
    PR(strcmp(predict(:),type(2))==1)=1;
    
    x=find(PR==0);
    PROB(x)=1-PROB(x);
end
