function [ angleDeg ] = calculateAngle( p1,p2,p3,p4 )
    x1 = p1(1);
    x2 = p2(1);
    x3 = p3(1);
    x4 = p4(1);
    
    y1 = p1(2);
    y2 = p2(2);
    y3 = p3(2);
    y4 = p4(2);
    
	%angleDeg = mod( atan2( (x2-x1)*(y4-y3)-(y2-y1)*(x4-x3) , ...
    %               (x2-x1)*(x4-x3)+(y2-y1)*(y4-y3) ) , 2*pi);
    angleRad = atan2( (x2-x1)*(y4-y3)-(y2-y1)*(x4-x3) , ...
        (x2-x1)*(x4-x3)+(y2-y1)*(y4-y3) );
    angleDeg = angleRad*180/pi; %radtodeg(angleRad);
end

