function varargout = macd(data,p1,p2,p3)
% [mavg1,mavg2] = macd(data,p1,p2,p3)
% Function to calculate the moving average convergence/divergence of a data set
% 'data' is the vector to operate on.  The first element is assumed to be
% the oldest data.
%
% p1 and p2 are the number of periods over which to calculate the moving
% averages that are subtracted from each other.
% p3 is the period of the indicator moving average
%
% If called with one output then it will be a two column matrix containing
% both calculated series.
% If called with two outputs then the first will contain the macd series
% and the second will contain the indicator series.
%
% Example:
% mavg1 = macd(data,p1,p2,p3);
% [mavg1,mavg2] = macd(data,p1,p2,p3);

% Error check
if (nargin < 1) || (nargin >4)
    error([mfilename,' requires between 1 and 4 inputs.']);
end
[m,n]=size(data);
if ~(m==1 || n==1)
    error(['The data input to ',mfilename,' must be a vector.']);
end

% set some defaults
switch nargin
    case 1
        p1 = 26;
        p2 = 12;
        p3 = 9;
    case 2
        p2 = 12;
        p3 = 9;
    case 3
        p3 = 9;
end

if (numel(p1) ~= 1) || (numel(p2) ~= 1) || (numel(p3) ~= 1)
    error('The period must be a scalar.');
end

% calculate the MACD
mavg1 = ema(data,p2)-ema(data,p1);
% Need to be careful with handling NaN's in the second calculation
idx = isnan(mavg1);
mavg2 = [mavg1(idx); ema(mavg1(~idx),p3)];
switch nargout
    case {0,1}
        varargout{1} = [mavg1 mavg2];
    case 2
        varargout{1} = mavg1;
        varargout{2} = mavg2;
    otherwise
        error('Too many outputs have been requested.');
end
end

function out = ema(data,period)
% Function to calculate the exponential moving average of a data set
% 'data' is the vector to operate on.  The first element is assumed to be
% the oldest data.
% 'period' is the number of periods over which to calculate the average
%
% Example:
% out = ema(data,period)
%
% Error check
if nargin ~= 2
    error([mfilename,' requires 2 inputs.']);
end
[m,n]=size(data);
if ~(m==1 || n==1)
    error(['The data input to ',mfilename,' must be a vector.']);
end
if (numel(period) ~= 1)
    error('The period must be a scalar.');
end

% convert the period to an exponential percentage
ep = 2/(period+1);
% calculate the EMA
out = filter(ep,[1 -(1-ep)],data,data(1)*(1-ep));
%out(1:period-1)=nan;
end
