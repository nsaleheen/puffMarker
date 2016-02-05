function createtestparam(pid,sid,WINDOW)
global DIR FILE

dirname=WINDOW.TESTDIR;
filename=[DIR.STUDYNAME '_' DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' WINDOW.NAME '_'];
%datafilename=[DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.LIBSVM_NAME];

fp=fopen([dirname DIR.SEP filename FILE.LIBSVM_PARAM],'w');

fprintf(fp,'doscale = True\n');
fprintf(fp,'dopca = False\n');
fprintf(fp,'outputlog = ''%s''\n',strrep([WINDOW.TESTDIR DIR.SEP filename FILE.LIBSVM_RESULT],'\','/'));
fprintf(fp,'choose_specific_features = False\n');
fprintf(fp,'specific_selected_features = []\n');
fprintf(fp,'testdatafilename = ''%s''\n',strrep([WINDOW.TESTDIR DIR.SEP filename FILE.LIBSVM_NAME],'\','/'));
fprintf(fp,'modelfilename = ''%s''\n',strrep(WINDOW.MODELNAME,'\','/'));
fprintf(fp,'scaledatafilename = ''%s''\n',strrep(WINDOW.SCALENAME,'\','/'));
fprintf(fp,'useprob = False\n');
fprintf(fp,'outputpredictions = True\n');
fprintf(fp,'testlabelspresent = False\n');
fprintf(fp,'predictionslog = ''%s''\n',strrep([WINDOW.TESTDIR DIR.SEP filename 'labels'],'\','/'));
fclose(fp);
