function [fitresult, gof] = activation(x, y, b0, debug)
%CREATEFIT(X,Y)
%  Create a fit.
%
%  Data for 'activation' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 30-Sep-2013 20:01:18


%% Fit: 'activation'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( [num2str(b0) '*exp(-x/tau1)'], 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = -Inf;
opts.StartPoint = 0.05;
opts.Upper = 1000000;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
if debug==1
figure( 'Name', 'activation' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', 'activation', 'Location', 'NorthEast' );
title(['Activation: tau=' num2str(fitresult.tau1) ' r2=' num2str(gof.rsquare) ]);

% Label axes
xlabel( 'x' );
ylabel( 'y' );
grid on
end
