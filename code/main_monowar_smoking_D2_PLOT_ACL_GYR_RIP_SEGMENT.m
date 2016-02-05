close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);

PS_LIST=G.PS_LIST;
for i=1:2
    R(i).selfreport=[];R(i).ppid=[];R(i).ssid=[];R(i).rip=[];R(i).segment=[];
    R(i).valid_height=[];R(i).valid_length=[];R(i).valid_rp=[];
    R(i).hour=[];
end
IDS{1}=[1,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID];
IDS{2}=[1,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID];

for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
%        pid='p14';sid='s02';
        ppid=str2num(pid(2:end));     
        ssid=str2num(sid(2:end));
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='segment_rip';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        for i=1:2
            selfreport=length(P.selfreport{2}.timestamp);
            rip=floor(length(P.sensor{1}.peakvalley_new_3.sample)/2);
            segment=length(P.wrist{i}.gyr.segment.starttimestamp);
            valid_height=length(find(P.wrist{i}.gyr.segment.valid_height==0));
            valid_length=length(find(P.wrist{i}.gyr.segment.valid_height==0 & P.wrist{i}.gyr.segment.valid_length==0));
            valid_rp=length(find(P.wrist{i}.gyr.segment.valid_height==0 & P.wrist{i}.gyr.segment.valid_length==0 & P.wrist{i}.gyr.segment.valid_rp==0));
            hour=0;
            for id=IDS{i}
                hour=max(hour,(length(P.sensor{id}.sample)/G.SENSOR.ID(id).FREQ)/(60*60));
            end
            R(i).ppid(end+1)=ppid;R(i).ssid(end+1)=ssid;
            R(i).rip(end+1)=rip;R(i).segment(end+1)=segment;
            R(i).valid_height(end+1)=valid_height;R(i).valid_length(end+1)=valid_length;
            R(i).valid_rp(end+1)=valid_rp;
            R(i).selfreport(end+1)=selfreport;
            R(i).hour(end+1)=hour;
        end
%        plot_custom(G,pid,sid,'segment_rip','plot_rip',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','save',[15,5]);
        
%        plot_custom(G,pid,sid,'segment_rip','plot_rip',[],'peakvalley','smokinglabel','acl',[2,1],'segment_acl','handmark_acl','bar',[-600,0,600],'gyrmag',[2,1],'segment_gyr','save',[0.5,0.5]);
%        plot_custom(G,pid,sid,'segment_rip','field_selfreport',[],...
%                 'smokinglabel','gyrmag',[2,1],'segment_gyr','selfreport','bar',[0,250],'map',[2,1],'save',[10,2]);
        
    end
end
fprintf('Person=%d\n',length(unique((R(1).ppid))));
fprintf('Day=%d\n',length((R(1).ssid)));
fprintf('Total Hour=%f\n',max(sum(R(1).hour),sum(R(2).hour)));
fprintf('# of RIP cycle=%d\n',sum(R(2).rip));
fprintf('# of segment(L)=%d\t(R)=%d\n',sum(R(1).segment),sum(R(2).segment));
fprintf('# of segment_valid_height(L)=%d\t(R)=%d\n',sum(R(1).valid_height),sum(R(2).valid_height));
fprintf('# of segment_valid_length(L)=%d\t(R)=%d\n',sum(R(1).valid_length),sum(R(2).valid_length));
fprintf('# of segment_valid_rp(L)=%d\t(R)=%d\n',sum(R(1).valid_rp),sum(R(2).valid_rp));
fprintf(') =>  done\n');
