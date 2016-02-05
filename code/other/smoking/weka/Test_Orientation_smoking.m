function Test_Orientation_smoking(modelname,infile,outfile)

s=['java -cp "','C:\Program Files\Weka-3-6\weka.jar'...
    ,'" weka.classifiers.trees.J48 -l ' modelname ' -T ',infile,' -p 0 >' outfile];
dos(s);
