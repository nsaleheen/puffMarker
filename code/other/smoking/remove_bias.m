function P=remove_bias(G, P,pid)
fprintf('...remove_bias');
bias_wristsensor();
load('bias.mat');
for p=1:length(BIAS.PID)
    if strcmp(BIAS.PID{p},pid)==1, break;end;
end
LID=BIAS.LEFT(p);
RID=BIAS.RIGHT(p);
for i=1:length(BIAS.M)
    if BIAS.M{i}.id==LID,
        P.sensor{G.SENSOR.WL9_ACLXID}.sample=fix_bias(P.sensor{G.SENSOR.WL9_ACLXID}.sample,BIAS.M{i}.x(1),BIAS.M{i}.x(2));
        P.sensor{G.SENSOR.WL9_ACLYID}.sample=fix_bias(P.sensor{G.SENSOR.WL9_ACLYID}.sample,BIAS.M{i}.y(1),BIAS.M{i}.y(2));
        P.sensor{G.SENSOR.WL9_ACLZID}.sample=fix_bias(P.sensor{G.SENSOR.WL9_ACLZID}.sample,BIAS.M{i}.z(1),BIAS.M{i}.z(2));
        P.sensor{G.SENSOR.WL9_GYRXID}.sample=P.sensor{G.SENSOR.WL9_GYRXID}.sample-BIAS.M{i}.gx;
        P.sensor{G.SENSOR.WL9_GYRYID}.sample=P.sensor{G.SENSOR.WL9_GYRYID}.sample-BIAS.M{i}.gy;
        P.sensor{G.SENSOR.WL9_GYRZID}.sample=P.sensor{G.SENSOR.WL9_GYRZID}.sample-BIAS.M{i}.gz;
    end
    if BIAS.M{i}.id==RID,
        P.sensor{G.SENSOR.WR9_ACLXID}.sample=fix_bias(P.sensor{G.SENSOR.WR9_ACLXID}.sample,BIAS.M{i}.x(1),BIAS.M{i}.x(2));
        P.sensor{G.SENSOR.WR9_ACLYID}.sample=fix_bias(P.sensor{G.SENSOR.WR9_ACLYID}.sample,BIAS.M{i}.y(1),BIAS.M{i}.y(2));
        P.sensor{G.SENSOR.WR9_ACLZID}.sample=fix_bias(P.sensor{G.SENSOR.WR9_ACLZID}.sample,BIAS.M{i}.z(1),BIAS.M{i}.z(2));
        P.sensor{G.SENSOR.WR9_GYRXID}.sample=P.sensor{G.SENSOR.WR9_GYRXID}.sample-BIAS.M{i}.gx;
        P.sensor{G.SENSOR.WR9_GYRYID}.sample=P.sensor{G.SENSOR.WR9_GYRYID}.sample-BIAS.M{i}.gy;
        P.sensor{G.SENSOR.WR9_GYRZID}.sample=P.sensor{G.SENSOR.WR9_GYRZID}.sample-BIAS.M{i}.gz;
        
    end        
end

end
function g= fix_bias( x, nG, pG)
zG = (pG+nG)/2;
spanG = pG-nG;
g = ((x-zG)/spanG)*1000*2;
end

