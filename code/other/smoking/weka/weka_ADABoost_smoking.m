function result=weka_ADABoost_smoking(file)
%s=['java -cp "','D:\Program Files\Weka-3-6\weka.jar','" weka.classifiers.meta.AdaBoostM1 -P 100 -S 1 -I 10 -W weka.classifiers.trees.J48 -- -C 0.25 -M 2 -t ',file,'.arff>,',file,'.txt'];
%weka.classifiers.meta.AdaBoostM1 -P 100 -S 1 -I 10 -W weka.classifiers.trees.J48 -- -C 0.25 -M 2
s=['java -cp "','C:\Program Files\Weka-3-6\weka.jar','" weka.classifiers.meta.AdaBoostM1 -P 100 -S 1 -I 10 -W weka.classifiers.trees.J48 -t ',file,'.arff -d ',file,'_ADA.model >',file,'_ADA.txt'];

%s=['java -cp "',wekadir{1},'" weka.classifiers.trees.J48 -t ',file,'.arff>,',file,'.txt'];
dos(s);

result=get_weka_results_smoking([file '_ADA']);
