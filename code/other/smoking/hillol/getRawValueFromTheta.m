function rawData = getRawValueFromTheta(theta, nG, pG)

gComponent = 9.8*cosd(theta);
rawData = interp1([-9.8 9.8], [nG pG], gComponent);

end
