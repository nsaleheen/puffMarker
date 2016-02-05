function C=curve_smooth(C)
%if size(C.timestamp,2)<10
%	return;
%end
if isempty(C), return;end;
if isempty(C.Q9), return;end;
Q9_smooth=smoothn(C.Q9,300);
%[high,low]=envelope(C.timestamp,C.Q9,'spline');
%C.Q9_envelope_high=high;
%C.Q9_envelope_low=low;
C.Q9_smooth=Q9_smooth;
end
