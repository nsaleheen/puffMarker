function plot_custom_nazir_gyrMag_aclY_rip(varargin)
G=varargin{1};pid=varargin{2};sid=varargin{3};INDIR=varargin{4};OUTDIR=varargin{5};SENSORIDS=varargin{6};
indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end; 
data=load([indir G.DIR.SEP infile]);name=fieldnames(data);data=data.(name{1});
%ymax=find_ymax(data,SENSORIDS);
svm=isvalid(varargin,'svm');

h=figure('units','normalized','outerposition',[0 0 1 1]);title(['pid=' pid ' sid=' sid]);xlabel('Time');ylabel('Magnitude');
  
index=isvalid(varargin,'map');
if index~=0, IDS=varargin{index+1};
%     plot_rip_peakvalley_nazir(G,data,IDS,svm);
    
    for i=IDS
    hold on;
    maxv=prctile(data.sensor{1}.sample_new,99);
    data.sensor{1}.sample_new(data.sensor{1}.sample_new>maxv)=maxv;
    y=ylim;
    offset=0;
    plot(data.sensor{1}.matlabtime,data.sensor{1}.sample_new/2+offset,'g-');
    
    plot(xlim,[0,0]+offset,'k-');
    ind=find(data.wrist{i}.gyr.segment.valid_all==0);
    pind=data.wrist{i}.gyr.segment.peak_ind(ind);pind(pind==0)=[];
    len=length(data.sensor{1}.peakvalley_new_3.sample);
    pind(pind>len)=[];
    
    if svm~=0,
        rind=find(data.wrist{i}.gyr.segment.svm_predict(ind)==1);
        rind=ind(rind);
        
        pind=data.wrist{i}.gyr.segment.peak_ind(rind);pind(pind==0)=[];
        len=length(data.sensor{1}.peakvalley_new_3.sample);
        pind(pind>len)=[];
        
        puff_times = data.sensor{1}.peakvalley_new_3.matlabtime(pind);
		cnt=length(puff_times);
              plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind),data.sensor{1}.peakvalley_new_3.sample(pind)/2+offset,'ro');
      
        if cnt>1
                diff_time = (puff_times(2) - puff_times(1))*24*60*60;
                if diff_time < 100
                    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind(1)),data.sensor{1}.peakvalley_new_3.sample(pind(1))/2+offset,'mo','markerfacecolor','m');            
                    hold on;
                end
                diff_time = (puff_times(length(puff_times)) - puff_times(length(puff_times)-1))*24*60*60;
                if  diff_time < 100
                    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind(length(puff_times))),data.sensor{1}.peakvalley_new_3.sample(pind(length(puff_times)))/2+offset,'mo','markerfacecolor','m');            
                    hold on;
                end			
                for j=2:length(puff_times)-1
                    diff_time1 = (puff_times(j) - puff_times(j-1))*24*60*60;
                    diff_time2 = (puff_times(j+1) - puff_times(j))*24*60*60;
%                   fprintf('dif: %d, ', puff_times(j));
                    if diff_time1 < 100  | diff_time2 < 100 
                        plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind(j)),data.sensor{1}.peakvalley_new_3.sample(pind(j))/2+offset,'mo','markerfacecolor','m');            
                        hold on;
                    end
                end          
               
            end
        end
    
    if i==1,ids=G.SENSOR.WL9_ACLYID;else ids=G.SENSOR.WR9_ACLYID;end
    maxv=prctile(data.sensor{ids}.sample,80);
    y=ylim;
%     offset=y(1)-maxv;
    offset=-7000;
    plot(data.sensor{ids}.matlabtime,data.sensor{ids}.sample+offset,'b-');
    plot(xlim,[0,0]+offset,'k-');
    plot(xlim,[-500,-500]+offset,'k--');
    plot(xlim,[+500,+500]+offset,'k--');
    ind=find(data.wrist{i}.gyr.segment.valid_all==0);
    
    %    plot(xlim,[data.wrist{i}.magnitude.threshold,data.wrist{i}.magnitude.threshold]+offset,'k-');
end
    
    
    
    
    %--------------------------------------------
end
index=isvalid(varargin,'gyrmag');
if index~=0, IDS=varargin{index+1};
    hand_gyr=0;%if isvalid(varargin,'handmark_gyr')~=0, hand_gyr=1;end;
    segment_gyr=0;%if isvalid(varargin,'segment_gyr')~=0, segment_gyr=1;end;
    segment_acl_gyr=0;%if isvalid(varargin,'segment_acl_gyr')~=0, segment_acl_gyr=1;end;
%     plot_gyr_magnitude(G,data,IDS,hand_gyr,segment_gyr,segment_acl_gyr);
    
i=2;    
        hold on;
    maxv=prctile(data.wrist{i}.magnitude,80);
    y=ylim;
    offset=-14000;
   
    plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude+offset,'g-');
    plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude_800+offset,'b-');
    plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude_8000+offset,'r-');
    
    plot(xlim,[50,50]+offset,'k--');
    plot(xlim,[0,0]+offset,'k-');
    
    
end


%if isvalid(varargin,'segment')~=0, plot_segment(G,data,SENSORIDS);end;

if isvalid(varargin,'selfreport')~=0, plot_selfreport_smoking(G,data);end;
if isvalid(varargin,'peakvalley')~=0, plot_peakvalley(G,data,SENSORIDS);end;
%if isvalid(varargin,'datalabel')~=0, plot_datalabel(G,data);end
if isvalid(varargin,'smokinglabel')~=0,plot_smokinglabel(G,data);end; 
if isvalid(varargin,'handmark_ACLY')~=0, plot_handmark_ACLY(G,data,SENSORIDS);end
if isvalid(varargin,'handmark_RIP')~=0, plot_handmark_RIP(G,data,SENSORIDS);end
dynamicDateTicks;
y=ylim;
%ylim([y(1)+2000,y(2)-2000]);

if ~isempty(OUTDIR),
    index=isvalid(varargin,'save');
    if index~=0, shift=varargin{index+1};save_figure(G,data,pid,sid,OUTDIR,shift(1),shift(2),h);close();end
end
filename=[G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP pid '_' sid '.png'];
saveas(h,[filename '.fig']);
print('-dpng','-r100',filename);
close(h);
end

function res=isvalid(variables,text)
res=0;
for i=1:length(variables)
    if strcmpi(variables{i},text)==1, res=i;break;end
end
end
function ymax=find_ymax(data,SENSORIDS)
ymax=0;
for s=SENSORIDS
    ymax=ymax+max(data.sensor{s}.sample)+abs(min(data.sensor{s}.sample));
end
end
