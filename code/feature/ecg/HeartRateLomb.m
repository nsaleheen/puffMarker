% Computes energy spectrum
function [P,f] = lomb(x,t,varargin)
%% Inputs check and initialization
fig = 0;   % set default value for hifac
if ~isvector(x) ||~isvector(t),
    error('%s: inputs x and t must be vectors',mfilename);
else
    x = x(:);
    t = t(:);
    nt = length(t);
    if length(x)~=nt
        error('%s: Inputs x and t must have the same length',mfilename);
    end
end
T = t(end) - t(1);
nf = round(0.5*4*1*nt);
f = (1:nf)'/(T*4);
nf = length(f);
mx = mean(x);
x  = x-mx;
vx = var(x);
% if vx==0, error('%s: x has zero variance',upper(mfilename)); P=0; f=0;end


%% Main
P = zeros(nf,1);
for i=1:nf
    wt  = 2*pi*f(i)*t;  % \omega t
    swt = sin(wt);
    cwt = cos(wt);

    %% Calculate \omega\tau and related quantities
    % I use some trigonometric identities to reduce the computations
    Ss2wt = 2*cwt.'*swt;            % \sum_t \sin(2\omega\t)
    Sc2wt = (cwt-swt).'*(cwt+swt);  % \sum_t \cos(2\omega\t)
    wtau  = 0.5*atan2(Ss2wt,Sc2wt);  %\omega\tau

    swtau = sin(wtau);
    cwtau = cos(wtau);

    % I use some trigonometric identities to reduce the computations
    swttau = swt*cwtau - cwt*swtau;  % \sin\omega(t-\tau))
    cwttau = cwt*cwtau + swt*swtau;  % \cos\omega(t-\tau))

    P(i) = ((x.'*cwttau)^2)/(cwttau.'*cwttau) + ((x.'*swttau)^2)/(swttau.'*swttau);
end
P = P/(2*vx);

%% Figure
if fig
    figure
    plot(f,P,'k');
    title('Lomb-Scargle normalized periodogram')
    xlabel('f (Hz)'); ylabel('P(f)');

end
end