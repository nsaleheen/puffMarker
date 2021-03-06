function [fitresult, gof] = activation(x, y,debug)
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

%  Auto-generated by MATLAB on 28-Sep-2013 23:08:57


%% Fit: 'activation'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'b0+b1*exp(-x/tau1)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf];
opts.StartPoint = [0.469390641058206 0.0119020695012414 0.337122644398882];
opts.Upper = [Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
if debug==1
% Plot fit with data.
figure( 'Name', 'activation' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', 'activation', 'Location', 'NorthEast' );
title(['Activation: tau=' num2str(fitresult.tau1) ' r2=' num2str(gof.rsquare) ]);

% Label axes
xlabel( 'x' );
ylabel( 'y' );
grid on
end

