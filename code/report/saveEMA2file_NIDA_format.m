function saveEMA2file_NIDA_format(pid,sid)
global DIR FILE
infile = [ DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.FRMTDATA_MATNAME];
load ([DIR.FORMATTEDDATA DIR.SEP infile]);

load('C:\NIDA\NIDA_EMA_QuestionnaireWithPossibleAnsweres.mat');
[row col]=size(D.ema.data);
a=[1,2,4,8,16,32,64,128,256,512,1024,2048];
%fid=fopen(['C:\Users\mmrahman\Desktop\NIDA_Results\EMA\' pid '_' sid '_ema.csv'],'w'); 
fid=fopen('C:\EMA\NIDA_ema_data_all_subject_20130108.csv','a'); 
%create header of the file
%header='subject number,Date,Time,Weekday';
%nQ=length(EMAQuestionnaire.question);
%for i=1:nQ
%    header=[header ',' EMAQuestionnaire.question(i).text];
%end

%fprintf(fid,'%s\n',header);
for r=1:row  
    questions=1;
    %line=[num2str(r) ','];
    line=[pid ',' sid];; %subject number
    %time=convert_timestamp_time(str2num(char(D.ema.data(r,13)))); %timestamp of the first column of the EMA
    time=convert_timestamp_time(str2num(char(D.ema.data(r,13))));
    [n s]=weekday(time);
    line=[line ',' time(1:10) ',' time(12:19) ',' s ','];
    for c=14:2:col
        r;
        %questions
        %line=[line char(D.ema.data(r,c+1))];
        if questions==21 | questions==23 | questions==25
           line=[line  char(D.ema.data(r,c))];
        elseif ~isempty(str2num(char(D.ema.data(r,c)))) 
            val=str2num(char(D.ema.data(r,c)));
            text='';
            choices=[];
            for i=1:length(a) 
                if val>=a(i)
                    if bitand(a(i),val) 
                        if i<=length(EMAQuestionnaire.question(questions).answerChoice)
                            choices=[choices i];
                        else
                            disp(['participant = ' pid ' session = ' sid ' EMA number = ' num2str(r) ' question number = ' num2str(questions) ' answered option number = ' num2str(i) ' ,answer number exceeds available options']);
                        end
                        %line=[line text ':'];
                    end
                end
            end
            text=[text getAnswerChoices(questions,choices)];
            line=[line text];
        else
            %line=[line ',' char(D.ema.data(r,c))];
            %line=[line ',' char(D.ema.data(r,c))];
        end
        questions=questions+1;
        line=[line ','];
    end
    fprintf(fid,'%s\n',line);
end
fclose(fid);
end
function answerText=getAnswerChoices(questions,choices)
    answerText='';
    if length(choices)==0    
        return;
    end
    load('C:\NIDA\NIDA_EMA_QuestionnaireWithPossibleAnsweres.mat');
    if length(choices)>1
        for i=1:length(choices)-1
            answerText=[EMAQuestionnaire.question(questions).answerChoice(choices(i)).text ' & ' answerText];
        end
    end
    answerText=[answerText EMAQuestionnaire.question(questions).answerChoice(choices(1)).text];
end



