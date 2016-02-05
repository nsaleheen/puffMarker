function weka_train_smoking(trainfile,testfile)
result=weka_SMO(trainfile,testfile);
disp('------------------SMO---------------');
for i=1:length(result)
    disp(result(i));
end
disp('------------------J48---------------');

result=weka_J48(trainfile,testfile);
for i=1:length(result)
    disp(result(i));
end

disp('---------------ADABOOST---------------');
result=weka_ADABoost(trainfile,testfile);
for i=1:length(result)
    disp(result(i));
end

end
function result=weka_SMO(trainfile, testfile)

s=['java -cp "','D:\Program Files\Weka-3-6\weka.jar','" weka.classifiers.functions.SMO -C 1.0 -L 0.0010 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0" -t ',trainfile,'.arff -T ',testfile,'.arff -d ',trainfile,'_SMO.model> ',trainfile,'_SMO.txt'];
dos(s);
result=get_weka_results([trainfile '_SMO']);
end

function result=weka_ADABoost(file,test)
%s=['java -cp "','D:\Program Files\Weka-3-6\weka.jar','" weka.classifiers.meta.AdaBoostM1 -P 100 -S 1 -I 10 -W weka.classifiers.trees.J48 -- -C 0.25 -M 2 -t ',file,'.arff>,',file,'.txt'];
%weka.classifiers.meta.AdaBoostM1 -P 100 -S 1 -I 10 -W weka.classifiers.trees.J48 -- -C 0.25 -M 2
s=['java -cp "','D:\Program Files\Weka-3-6\weka.jar','" weka.classifiers.meta.AdaBoostM1 -P 100 -S 1 -I 10 -W weka.classifiers.trees.J48 -t ',file,'.arff -T ',test,'.arff -d ',file,'_ADA.model >',file,'_ADA.txt'];

%s=['java -cp "',wekadir{1},'" weka.classifiers.trees.J48 -t ',file,'.arff>,',file,'.txt'];
dos(s);

result=get_weka_results([file '_ADA']);
end
function result=weka_J48(file,test)

%wekadir=findfiles('D:\Program Files\Weka-3-6','weka.jar');
s=['java -cp "','D:\Program Files\Weka-3-6\weka.jar','" weka.classifiers.trees.J48 -C 0.25 -M 2 -t ',file,'.arff -T ',test,'.arff -d ',file,'_J48.model > ',file,'_J48.txt'];
%weka.classifiers.meta.AdaBoostM1 -P 100 -S 1 -I 10 -W weka.classifiers.trees.J48 -- -C 0.25 -M 2

%s=['java -cp "',wekadir{1},'" weka.classifiers.trees.J48 -t ',file,'.arff>,',file,'.txt'];
dos(s);

result=get_weka_results([file '_J48']);
end