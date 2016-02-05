function TestSVM_smoking(modelname,infile,outfile)

s=['java -cp "','C:\Program Files\Weka-3-6\weka.jar'...
    ,'" weka.classifiers.functions.SMO -l ' modelname ' -T ',infile,' -p 0 >' outfile];
dos(s);
