function plot_custom(varargin)
G=varargin{1};pid=varargin{2};sid=varargin{3};INDIR=varargin{4};OUTDIR=varargin{5};SENSORIDS=varargin{6};
indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end; 
data=load([indir G.DIR.SEP infile]);name=fieldnames(data);data=data.(name{1});
%ymax=find_ymax(data,SENSORIDS);
svm=isvalid(varargin,'svm');

h=figure('units','normalized','outerposition',[0 0 1 1]);title(['pid=' pid ' sid=' sid]);xlabel('Time');ylabel('Magnitude');
plot_sensor(G,data,SENSORIDS);
index=isvalid(varargin,'map');
if index~=0, IDS=varargin{index+1};
    plot_rip_peakvalley_nazir(G,data,IDS,svm);
end
index=isvalid(varargin,'gyrmag');
if index~=0, IDS=varargin{index+1};
    hand_gyr=0;if isvalid(varargin,'handmark_gyr')~=0, hand_gyr=1;end;
    segment_gyr=0;if isvalid(varargin,'segment_gyr')~=0, segment_gyr=1;end;
    segment_acl_gyr=0;if isvalid(varargin,'segment_acl_gyr')~=0, segment_acl_gyr=1;end;
    plot_gyr_magnitude(G,data,IDS,hand_gyr,segment_gyr,segment_acl_gyr);
end
index=isvalid(varargin,'acl');
if index~=0, IDS=varargin{index+1};
    hand_acl=0;if isvalid(varargin,'handmark_acl')~=0, hand_acl=1;end;
    segment_acl=0;if isvalid(varargin,'segment_acl')~=0, segment_acl=1;end;
    segment_gyr_acl=0;if isvalid(varargin,'segment_gyr_acl')~=0, segment_gyr_acl=1;end;    
    plot_acl(G,data,IDS,hand_acl,segment_acl,segment_gyr_acl);
end

%if isvalid(varargin,'segment')~=0, plot_segment(G,data,SENSORIDS);end;
index=isvalid(varargin,'roll');if index~=0, IDS=varargin{index+1};plot_roll(G,data,IDS);end
index=isvalid(varargin,'pitch');if index~=0, IDS=varargin{index+1};plot_pitch(G,data,IDS);end

index=isvalid(varargin,'bar');if index~=0, barvalue=varargin{index+1};plot_bar(G,data,SENSORIDS,barvalue);end;

if isvalid(varargin,'smooth')~=0, plot_filtered(G,data,SENSORIDS);end
if isvalid(varargin,'episode')~=0, plot_episode(G,data,SENSORIDS);end
if isvalid(varargin,'orientation')~=0, plot_orientation(G,data);end

if isvalid(varargin,'cress')~=0,plot_cress(G,data);end;
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
