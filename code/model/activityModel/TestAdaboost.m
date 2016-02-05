function TestAdaboost(file)

s=['java -cp "','D:\Program Files\Weka-3-6\weka.jar'...
    ,'" weka.classifiers.meta.AdaBoostM1 -l N35_ADA.model -T ',file,'.arff -p 0 >,',file,'_output_ADA.txt'];

dos(s);
