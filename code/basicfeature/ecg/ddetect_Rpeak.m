 function Rpeak_index = ddetect_Rpeak(sample,fs,fig_plot)
sample=sample'; 
window_l = ceil(fs/5);
thr1 = 0.5;
f=2/fs;
delp=0.02;
dels1=0.02;
dels2=0.02;
F = [0 4.5*f  5*f 20*f  20.5*f 1]; 
A = [0  0   1  1  0 0];
w=[500/dels1 1/delp 500/dels2];
fl = 256;
b = firls(fl,F,A,w);
y2 = conv(sample,b,'same');
% y2 = y(fl/2+1:end-fl/2);
% y2 = y2/max(abs(y2));
y2 = y2/prctile(y2,90);



h_D = [-1 -2 0 2 1]*1/8;
y3 = conv(y2, h_D,'same');
% y3 = y3(3:end-2);
% y3 = y3/max(abs(y3));
y3 = y3/prctile(y3,90);

y4 = y3.^2;
% y4 = y4/max(abs(y4));
y4 = y4/prctile(y4,90);

h_I = blackman(window_l);
y5 = conv (y4 ,h_I,'same');
% y5 = y5(floor(window_l/2)+1:end-floor(window_l/2));
% y5 = y5/max(abs(y5));
y5 = y5/prctile(y5,90);




%% -----------------------------------------------------------------------------------
count = 1;
 for i = 3:length(y5)-2
    if (y5(i-2) < y5(i-1)&& y5(i-1) < y5(i)&& y5(i)>= y5(i+1)&& y5(i+1) > y5(i+2)) 
				pkt(count) = i;
				valuepks(count) = y5(i);
				count = count+1;
    end
 end


rr_ave = sum(diff(pkt))/(length(pkt)-1);
thr2 = 0.5*thr1;
sig_lev = 4*thr1;
noise_lev = 0.1*sig_lev;
c1 = 1;
c2 = [];
i = 1;
thresholds = [];
Rpeak_temp1 = [];
% If CURRENTPEAK > THR_SIG, that location is identified as a “QRS complex
% candidate” and the signal level (SIG_LEV) is updated:
% SIG _ LEV = 0.125 ×CURRENTPEAK + 0.875× SIG _ LEV
% If THR_NOISE < CURRENTPEAK < THR_SIG, then that location is identified as a
% “noise peak” and the noise level (NOISE_LEV) is updated:
% NOISE _ LEV = 0.125×CURRENTPEAK + 0.875× NOISE _ LEV
% Based on new estimates of the signal and noise levels (SIG_LEV and NOISE_LEV,
% respectively) at that point in the ECG, the thresholds are adjusted as follows:
% THR _ SIG = NOISE _ LEV + 0.25 × (SIG _ LEV ? NOISE _ LEV )
% THR _ NOISE = 0.5× (THR _ SIG)
while i <= length(pkt);
    if isempty(Rpeak_temp1)
     if y5(pkt(i)) >= thr1 && y5(pkt(i)) < 3*sig_lev;
        Rpeak_temp1(c1) = pkt(i) ;
        sig_lev = 0.125*y5(pkt(i))+0.875*sig_lev;
        c2(c1) = i;
        c1 = c1+1;
     elseif y5(pkt(i)) < thr1 && y5(pkt(i))> thr2;
        noise_lev = 0.125*y5(pkt(i))+0.875*noise_lev;
    end
    thr1 = noise_lev+0.25*(sig_lev-noise_lev);
    thr2 = 0.5*thr1;
    i = i+1;
    rr_ave = rr_ave_update(Rpeak_temp1,rr_ave);
    else
         if (pkt(i)-pkt(c2(c1-1))>1.66*rr_ave) && (i-c2(c1-1)>1)
         searchback_array = valuepks(c2(c1-1)+1:i-1);
        searchback_array_inrange = searchback_array(find(searchback_array<3*sig_lev & searchback_array>thr2));
         if isempty(searchback_array_inrange)
         else
         searchback_array_inrange_index = find(searchback_array<3*sig_lev & searchback_array>thr2);
         [searchback_max, searchback_max_index] = max(searchback_array_inrange);
         Rpeak_temp1(c1) = pkt(c2(c1-1)+searchback_array_inrange_index(searchback_max_index));
         sig_lev = 0.125*y5(Rpeak_temp1(c1))+0.875*sig_lev;
         c2(c1) = c2(c1-1)+searchback_array_inrange_index(searchback_max_index);
         i = c2(c1)+1;
         c1 = c1+1;
         thr1 = noise_lev+0.25*(sig_lev-noise_lev);
        thr2 = 0.5*thr1;
        rr_ave = rr_ave_update(Rpeak_temp1,rr_ave);
         continue;
         end
         elseif y5(pkt(i)) >= thr1 && y5(pkt(i)) < 3*sig_lev;
        Rpeak_temp1(c1) = pkt(i) ;
        sig_lev = 0.125*y5(pkt(i))+0.875*sig_lev;
        c2(c1) = i;
        c1 = c1+1;
         elseif  y5(pkt(i)) < thr1 && y5(pkt(i))> thr2;
                 noise_lev = 0.125*y5(pkt(i))+0.875*noise_lev;
    end
    thr1 = noise_lev+0.25*(sig_lev-noise_lev);
    thr2 = 0.5*thr1;
    i = i+1;
    rr_ave = rr_ave_update(Rpeak_temp1,rr_ave);
    end
    thresholds(1,i-1) = thr1;
    thresholds(2,i-1) = thr2;
    thresholds(3,i-1) = 3*sig_lev;
end;

%Elimination
difference = 0;
Rpeak_temp2 = Rpeak_temp1;
while difference~=1
    length_Rpeak_temp2 = length(Rpeak_temp2);
    comp_index1 = Rpeak_temp2(find(diff(Rpeak_temp2)<0.5*fs));
    comp_index2 = Rpeak_temp2(find(diff(Rpeak_temp2)<0.5*fs)+1);
    comp1 = sample(comp_index1)';
    comp2 = sample(comp_index2)';
    [eli_valie,eli_index] = min([comp1;comp2]);
    Rpeak_temp2(find(diff(Rpeak_temp2)<0.5*fs)-1+eli_index) = []; 
    difference = isequal(length_Rpeak_temp2, length(Rpeak_temp2));
end

%T wave discrimination
% T_wave_temp1_index = find(diff(Rpeak_temp2)>=0.2*fs & diff(Rpeak_temp2)<=0.36*fs)+1;
% if isempty(T_wave_temp1_index)
%     Rpeak_temp3 = Rpeak_temp2;
%     T_wave_temp = [];
% else
% for i = 1:length(T_wave_temp1_index)
%     slope1 = y5(Rpeak_temp2(T_wave_temp1_index(i))) - y5(Rpeak_temp2(T_wave_temp1_index(i))-1);
%     slope2 = y5(Rpeak_temp2(T_wave_temp1_index(i))-1) - y5(Rpeak_temp2(T_wave_temp1_index(i)-1)-1);
%     if slope1 < slope2
%         T_wave_index(i) = 1;
%     else
%         T_wave_index(i) = 0;
%     end
% end
% Rpeak_temp3 = Rpeak_temp2(find(T_wave_index == 0));
% T_wave_temp = Rpeak_temp2(find(T_wave_index == 1));
% end
%     
% for   i = 2:length(Rpeak_temp1);
%     rr = Rpeak_temp1(i)- Rpeak_temp1(i-1);
%     if rr > rr_avg
%         [v,l] = max(y5(Rpeak_temp1(i-1)+1:Rpeak_temp1(i)-1))
%         Rpeak_temp2(c2) = find()


%% -----------------------------------------------------------------------------------------------
for i=2:length(Rpeak_temp2)-1
    [v,l] = max(sample(Rpeak_temp2(i)-ceil(fs/10):Rpeak_temp2(i)+ceil(fs/10)));
    Rpeak_temp3(i) = Rpeak_temp2(i)-ceil(fs/10)+l-1;
end
Rpeak_temp3(1) = Rpeak_temp2(1);
Rpeak_index = sort(Rpeak_temp3);



%% -----------------------------------------------------------------------------------------------
if fig_plot == 1; 
    figure;
    plot(sample);
    title('raw signal');
    figure;
    plot(y2);
    title('bandpass');
    figure;
    plot(y3);
    title('diff');
    figure;
    plot(y4);
    title('square');
    figure;
    plot(y5);
    title('integral');
end










