function h=plot_signal(timestamp,sample,linetype,linewidth,offset,scale,markercolor)
h=0;
if isempty(timestamp), return ; end;
if ~exist('offset','var'), offset=0;end
if ~exist('scale','var'), scale=1;end
if ~exist('markercolor','var')
    h=plot(timestamp,offset+scale*sample,linetype,'LineWidth',linewidth);
else
    h=plot(timestamp,offset+scale*sample,linetype,'LineWidth',linewidth,'MarkerFaceColor',markercolor);
    
end
dynamicDateTicks
end
