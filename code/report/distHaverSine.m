function [D]=distHaverSine(i,x)

% function: [D]=dist(i,x)
%
% Aim: 
% Calculates the Euclidean distances between the i-th object and all objects in x	 
%								    
% Input: 
% i - an object (1,n)
% x - data matrix (m,n); m-objects, n-variables	    
%                                                                 
% Output: 
% D - Haversine distance (m,1)


D=[];
[m,n]=size(x);
for j=1:m
    D=[D abs(calculateHaversineDistance( i(1), i(2), x(j,1), x(j,2)))];
end

end

function distance = calculateHaversineDistance( lat1, long1, lat2, long2 )
    radian = 57.2958;
    distance = 6371*acos(cos(long1/radian-long2/radian)*cos(lat1/radian)*cos(lat2/radian)+sin(lat1/radian)*sin(lat2/radian));
    distance = distance * 1000; % meter
end