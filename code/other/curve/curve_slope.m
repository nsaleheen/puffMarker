function C=curve_slope(C)
if isempty(C), return;end;
for p=1:size(C.timestamp,2)-1
    x1=C.timestamp(p);
    x2=C.timestamp(p+1);
    y1=C.Q9_smooth(p);
    y2=C.Q9_smooth(p+1);
    C.slope(p)=(y2-y1)/y1;
end
end
