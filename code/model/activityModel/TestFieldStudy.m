%function TestFieldStudy()
file='si4day1_test';
TestJ48(file);
TestAdaboost(file);
TestSVM(file);
[b1,c1,res1]=Results('si4day1_test_output_ADA');
[b2,c2,res2]=Results('si4day1_test_output_J48');
[b3,c3,res3]=Results('si4day1_test_output_SMO');

%sget_weka_results('si4day1_test_output_ADA.txt');