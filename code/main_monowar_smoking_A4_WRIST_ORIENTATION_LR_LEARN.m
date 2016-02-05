function main_monowar_smoking_A4_WRIST_ORIENTATION_LR_LEARN()
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
PS_LIST=G.PS_LIST;
lr_id=fopen('C:\Users\smh\Desktop\smoking_fig\orientation_leftright\lr_svn.csv','w');
ci_id=fopen('C:\Users\smh\Desktop\smoking_fig\orientation_leftright\ci_svn.csv','w');

times=[0.5,1,5,10,15,20,30,60,90,120]*60*1000;
for i=1:2,for k=1:2, for j=1:length(times), Hands(i,k,j).roll=[];Hands(i,k,j).pitch=[];Hands(i,k,j).timestamp=[];Hands(i,k,j).valid=[];end;end;end
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='preprocess_wrist';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        for d=1:length(times)
            Hand=generate_orientation_data(G,P,times(d));
            Hands(1,1,d).roll=[Hands(1,1,d).roll,Hand(1,1).roll];Hands(1,1,d).pitch=[Hands(1,1,d).pitch,Hand(1,1).pitch];Hands(1,1,d).timestamp=[Hands(1,1,d).timestamp,Hand(1,1).timestamp];Hands(1,1,d).valid=[Hands(1,1,d).valid,Hand(1,1).valid];
            Hands(1,2,d).roll=[Hands(1,2,d).roll,Hand(1,2).roll];Hands(1,2,d).pitch=[Hands(1,2,d).pitch,Hand(1,2).pitch];Hands(1,2,d).timestamp=[Hands(1,2,d).timestamp,Hand(1,2).timestamp];Hands(1,2,d).valid=[Hands(1,2,d).valid,Hand(1,2).valid];
            Hands(2,1,d).roll=[Hands(2,1,d).roll,Hand(2,1).roll];Hands(2,1,d).pitch=[Hands(2,1,d).pitch,Hand(2,1).pitch];Hands(2,1,d).timestamp=[Hands(2,1,d).timestamp,Hand(2,1).timestamp];Hands(2,1,d).valid=[Hands(2,1,d).valid,Hand(2,1).valid];
            Hands(2,2,d).roll=[Hands(2,2,d).roll,Hand(2,2).roll];Hands(2,2,d).pitch=[Hands(2,2,d).pitch,Hand(2,2).pitch];Hands(2,2,d).timestamp=[Hands(2,2,d).timestamp,Hand(2,2).timestamp];Hands(2,2,d).valid=[Hands(2,2,d).valid,Hand(2,2).valid];            
        end
    end
end

for d=1:length(times)
    h=figure;hold on;
    title(['Window Size=' num2str(times(d)/(60*1000)) ' Minute']);
    xlabel('Roll (in degrees)');
    ylabel('Pitch (in degrees)');
    i11=find(Hands(1,1,d).valid==0);    i12=find(Hands(1,2,d).valid==0);
    i21=find(Hands(2,1,d).valid==0);    i22=find(Hands(2,2,d).valid==0);

    hold on;scatter(Hands(1,1,d).roll(i11),Hands(1,1,d).pitch(i11),'b.');
    hold on;scatter(Hands(1,2,d).roll(i12),Hands(1,2,d).pitch(i12),'r.');
    hold on;scatter(Hands(2,1,d).roll(i21),Hands(2,1,d).pitch(i21),'g.');
    hold on;scatter(Hands(2,2,d).roll(i22),Hands(2,2,d).pitch(i22),'m.');
    set(findall(gcf,'type','text'),'FontSize',20);
    set(gca,'FontSize',20);
    str={'LeftHand+CorrectOrientation';'LeftHand+IncorrectOrientation';'RightHand+CorrectOrientation';'RightHand+IncorrectOrientation'};
    legend(str,'FontSize',14);
    grid on;
    fname=['window_' num2str(times(d)/(60*1000))];
    print(h,'-depsc',['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' fname '.eps']);
    saveas(h,['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' fname '.jpg']);

    Roll=[Hands(1,1,d).roll(i11)';Hands(1,2,d).roll(i12)';Hands(2,1,d).roll(i21)';Hands(2,2,d).roll(i22)'];
    Pitch=[Hands(1,1,d).pitch(i11)';Hands(1,2,d).pitch(i12)';Hands(2,1,d).pitch(i21)';Hands(2,2,d).pitch(i22)'];
    RollLR=[Hands(1,1,d).roll(i11)';Hands(2,1,d).roll(i21)'];
    PitchLR=[Hands(1,1,d).pitch(i11)';Hands(2,1,d).pitch(i21)'];
    
    C=[Roll,Pitch];
    CLR=[RollLR,PitchLR];
    feature_names={'Roll','Pitch'};
    label_name={'LC','LI','RC','RI'};
    label_nameLR={'L','R'};
    
    lc=length(Hands(1,1,d).roll(i11));li=length(Hands(1,2,d).roll(i12));
    rc=length(Hands(2,1,d).roll(i21));ri=length(Hands(2,2,d).roll(i22));
    
    [labels{1:lc}]=deal('LC');
    [labels{lc+1:lc+li}]=deal('LI');
    [labels{lc+li+1:lc+li+rc}]=deal('RC');
    [labels{lc+li+rc+1:lc+li+rc+ri}]=deal('RI');
    [labelsLR{1:lc}]=deal('L');
    [labelsLR{lc+1:lc+rc}]=deal('R');
%    label_name={'LC','LI','RC','RI'};
%    write_arff(['LRO_4class_' num2str(times(d))],feature_names,label_name,C,labels);
    
%    label1(strcmp('LC', labels))={'L'};label1(strcmp('LI', labels))={'L'};label1(strcmp('RC', labels))={'R'};label1(strcmp('RI', labels))={'R'};
%    label_name={'L','R'};
    fname=['LR_' num2str(times(d)/(60*1000))];
    [sample,name,accuracy,kappa]=create_run_weka_files(G,fname,feature_names,label_nameLR,CLR,labelsLR);
    fprintf(lr_id,'lr,time,%f minute,sample,%d,accuracy,%f,kappa,%f\n',times(d)/(60*1000),sample,accuracy,kappa);
    lr_accuracy(d)=accuracy;
    fprintf('lr,time,%f minute,sample,%d,accuracy,%f,kappa,%f\n',times(d)/(60*1000),sample,accuracy,kappa);
    
%    create_run_weka_files(G,fname,feature_names,label_name,C,label1);

    label1(strcmp('LC', labels))={'C'};label1(strcmp('LI', labels))={'I'};label1(strcmp('RC', labels))={'C'};label1(strcmp('RI', labels))={'I'};
    label_name={'C','I'};fname=['CI_' num2str(times(d)/(60*1000))];
    [sample,name,accuracy,kappa]=create_run_weka_files(G,fname,feature_names,label_name,C,label1);
    fprintf(ci_id,'ci,time,%f minute,sample,%d,accuracy,%f,kappa,%f\n',times(d)/(60*1000),sample,accuracy,kappa);
    fprintf('ci,time,%f minute,sample,%d,accuracy,%f,kappa,%f\n',times(d)/(60*1000),sample,accuracy,kappa);
    ci_accuracy(d)=accuracy;    
end
fclose(ci_id);
fclose(lr_id);
plot_accuracy(times/(60*1000),lr_accuracy,ci_accuracy);
disp('here');
end
function plot_accuracy(time,lr_acc,ci_acc)
    h=figure;hold on;
%    title(['Window Size=' num2str(times(d)/(60*1000)) ' Minute']);
    xlabel('Window Size (in minutes)');
    ylabel('Error (in %)');
    plot(time,100-lr_acc,'g-','linewidth',2);
    plot(time,100-ci_acc,'b-','linewidth',2);
    set(findall(gcf,'type','text'),'FontSize',20);
    set(gca,'FontSize',20);
    str={'Left hand vs. Right hand';'Correct vs. Incorrect Orientation'};
    legend(str);
    fname='accuracy_j48_orientation_leftright';
    print(h,'-depsc',['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' fname '.eps']);
    saveas(h,['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' fname '.jpg']);
end
function [sample,name,accuracy,kappa]=create_run_weka_files(G,fname,feature_names,label_name,C,label1)
wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'orientation' G.DIR.SEP 'train_' fname '.arff'];
outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'orientation' G.DIR.SEP 'train_' fname '_output.txt'];
modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP  'orientation' G.DIR.SEP 'train_' fname '_model.model'];
write_arff_smoking(wekafile,feature_names,label_name,C,label1);
weka_train_J48_smoking(wekafile,modelfile,outfile);
[result,acc,kappa,detail,conf]=get_weka_results_smoking_parts(outfile);
sample=length(label1);name=fname;accuracy=acc;
fprintf('sample=%d  name=%s     accuracy=%f     kappa=%f\n',length(label1),fname,acc,kappa);
%for i=1:length(result), fprintf('%s\n',result{i});end
end
