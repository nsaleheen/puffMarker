function h=plot_signal(timestamp,sample,color,linestyle,linewidth,offset,scale,markercolor)
if ~exist('offset','var'), offset=0;end
if ~exist('scale','var'), scale=1;end
if ~exist('markercolor','var')
    h=plot(timestamp,offset+scale*sample,'color',color,'linestyle',linestyle,'LineWidth',linewidth);
else
    h=plot(timestamp,offset+scale*sample,'color',color,'linestyle',linestyle,'LineWidth',linewidth,'MarkerFaceColor',markercolor);
    
end
dynamicDateTicks
end
