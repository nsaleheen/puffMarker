function  plot_smoking_segment( G, pid,sid, INDIR,OUTDIR,time )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
now=0;
h=figure;title(['pid=' pid ' sid=' sid]);
offset = 0;

 plot(P.sensor{1}.matlabtime, P.sensor{1}.sample-4000, 'r--'); % RIP
 hold on;
 
 data=P;
 
 for i=1:2
         plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude+offset,'y-');hold on;
     plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude_800+offset,'c-');hold on;
    plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude_8000+offset,'k-');hold on;
    
    plot(xlim,[50,50]+offset,'k--');hold on;
    plot(xlim,[0,0]+offset,'k-');hold on;
     for s=1:length(P.wrist{i}.gyr.segment.starttimestamp)
            stime=data.wrist{i}.gyr.segment.startmatlabtime(s);
            etime=data.wrist{i}.gyr.segment.endmatlabtime(s);
            if data.wrist{i}.gyr.segment.valid_all(s)==0 
                plot([stime,etime],[offset-400,offset-400],'r-','linewidth',10);hold on;
            end
            if data.wrist{i}.gyr.segment.valid_acl_gyr(s)==0 
                plot([stime,etime],[offset-200,offset-200],'g-','linewidth',20);hold on;
            end
           
%             if data.wrist{i}.gyr.segment.valid_height(s)>0, 
%                 plot([stime,etime],[offset-400,offset-400],'m-','linewidth',2);hold on;
%             elseif data.wrist{i}.gyr.segment.valid_length(s)>0, 
%                 plot([stime,etime],[offset-500,offset-500],'g-','linewidth',2);hold on;
%             elseif data.wrist{i}.gyr.segment.valid_rp(s)>0, 
%                 plot([stime,etime],[offset-600,offset-600],'c-','linewidth',2);hold on;
%             elseif data.wrist{i}.gyr.segment.valid_all(s)==0
%                 plot([stime,etime],[offset-200,offset-200],'r-','linewidth',10);hold on;
%             end
            hold on;
              
     end
        if i==1
            hold on;
            plot(P.sensor{G.SENSOR.WL9_ACLYID}.matlabtime, P.sensor{G.SENSOR.WL9_ACLYID}.sample+offset+3000);
%             offset=offset+2000;
       hold on;
        end
        if i==2
              hold on;
              plot(P.sensor{G.SENSOR.WR9_ACLYID}.matlabtime, P.sensor{G.SENSOR.WR9_ACLYID}.sample+offset+3000);
%               offset=offset+2000;
        hold on;
        end
        
        offset=offset+5000;
 end
 
 
%G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID, 
% for s=[G.SENSOR.WR9_ACLYID, G.SENSOR.WR9_GYRXID, G.SENSOR.WR9_GYRZID]
%    hold on;
%    plot(B.sensor{s}.matlabtime, B.sensor{s}.sample+offset);
%    offset=offset+2000;
%  end
%for i=1:length(B.quality{1}.starttimestamp)
%    hold on; plot([B.quality{1}.startmatlabtime(i),B.quality{1}.endmatlabtime(i)],[1.5,1.5],'r-','linewidth',5);
%end
% dynamicDateTicks
plot_selfreport_smoking(G,P);hold on;
 plot_smokinglabel(G,P);hold on;
save_figure(G,P,pid,sid,OUTDIR,time(1),time(2),h);close();

end

