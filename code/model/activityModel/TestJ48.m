function TestJ48(file)

s=['java -cp "','D:\Program Files\Weka-3-6\weka.jar'...
    ,'" weka.classifiers.trees.J48 -l N35_J48.model -T ',file,'.arff -p 0 > ',file,'_output_J48.txt'];

dos(s);
