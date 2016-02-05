function rpvIndVal = RipPVDetect(ripV)
RPV=RPVCalculation();
rpvIndVal=RPV.calculate(ripV);
rpvIndVal=rpvIndVal';
end

