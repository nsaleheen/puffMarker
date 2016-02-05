function [ acclMps2, linearAccl, gravityCmp ] = convert_accl_linear(G, id, srcData, bias)

k=1;
for i=[G.SENSOR.ID(id).COMPONENTS]
	out(k).NAME=G.SENSOR.ID(i).NAME;
	out(k).METADATA=G.SENSOR.ID(i);
	out(k).timestamp=srcData.timestamp;
	out(k).matlabtime=srcData.matlabtime;
	k=k+1;
end

[ out(1).sample, out(2).sample, out(3).sample ] = accl_sep_linear_gravity( srcData.sample, bias );

acclMps2=out(1);
linearAccl=out(2);
gravityCmp=out(3);

end

