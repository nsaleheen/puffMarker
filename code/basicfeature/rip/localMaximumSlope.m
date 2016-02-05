function [MaxSlope,MaxSlopeIndex]=localMaximumSlope(x,t);
d=diff(x)./diff(t);
[MaxSlope,MaxSlopeIndex]=max(d); %Find maximum of the slope and index where the slope is
plot(t,x);
hold on;
plot(t(1:end-1),d,'r');
legend('signal','slope');
end
