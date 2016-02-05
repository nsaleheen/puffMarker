function weka_train_J48_smoking(wekafile,modelfile,outfile)

s=['java -cp "','C:\Program Files\Weka-3-6\weka.jar','" weka.classifiers.trees.J48 -i -C 0.25 -M 2 -t ',...
    wekafile,' -d ',modelfile, '> ',outfile];
dos(s);
