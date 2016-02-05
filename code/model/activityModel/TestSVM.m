function TestSVM(pid,file)

s=['java -cp "','C:\Program Files (x86)\Weka-3-6\weka.jar'...
    ,'" weka.classifiers.functions.SMO -l ' pid '_deepak_smo.model -T ',file,'.arff -p 0 >,',file,'_output_SMO.txt'];
s
dos(s);
