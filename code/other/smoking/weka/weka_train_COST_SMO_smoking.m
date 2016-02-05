function weka_train_COST_SMO_smoking(wekafile,modelfile,outfile)

s=['java -cp "','C:\Program Files\Weka-3-6\weka.jar',...
'" weka.classifiers.meta.CostSensitiveClassifier -i -t ' wekafile,' -d ', modelfile, ' -cost-matrix "[0.0 8.0; 1.0 0.0]" -S 1 -W weka.classifiers.functions.SMO -- -C 1.0 -L 0.0010 -P 1.0E-12 -N 0 -M -V -1 -W 1 -K "weka.classifiers.functions.supportVector.Puk -C 250007 -O 1.0 -S 1.0" > ' ,outfile];

dos(s);
