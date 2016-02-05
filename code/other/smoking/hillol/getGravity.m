function g= getGravity( x, nG, pG) %bias )

%http://wiki.orbswarm.com/index.php?title=IMU
%corrected by emre: (N-bias)/4096 * 3V * (9.8 m/s^2)/(0.300 V/g) 

%g = (x-bias)/(4096*3.0*9.8/0.3);

%g = (x-bias)/4096*3.0*9.8/0.3;
zG = (pG+nG)/2;
spanG = pG-nG;
g = ((x-zG)/spanG)*9.8*2;

end

