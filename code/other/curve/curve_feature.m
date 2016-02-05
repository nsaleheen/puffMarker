function C=curve_feature(C,D)

if isfield(C,'peak_ind')==0
    return;
end
F=[];
r=[];
f=[];

for i=1:size(C.window,2)
    [fallrate,xf,yf,fallrate_sum]=largest_fallrate(C,i);
    f=[f;xf(1)*1000,yf(1)/1000,xf(2)*1000,yf(2)/1000];
    [riserate,xr,yr,riserate_sum]=largest_riserate(C,i);
    r=[r;xr(1)*1000,yr(1)./1000,xr(2)*1000,yr(2)./1000];
    
    feature(i,1)=fallrate;
    feature(i,2)=riserate;
    feature(i,3)=(C.timestamp(C.window(i).peak2_ind)-C.timestamp(C.window(i).peak1_ind))/(1000);
    feature(i,4)=(C.timestamp(C.window(i).valley_ind)-C.timestamp(C.window(i).peak1_ind))/(1000);
    feature(i,5)=(C.timestamp(C.window(i).peak2_ind)-C.timestamp(C.window(i).valley_ind))/(1000);
%    feature(i,6)=(((C.base-C.Q9_smooth(C.window(i).valley_ind)))/C.base)*1000;
    feature(i,6)=(((C.base-C.Q9_smooth(C.window(i).valley_ind))))*1000;

    feature(i,7)=(min(C.Q9_smooth(C.window(i).peak1_ind),C.Q9_smooth(C.window(i).peak2_ind))-C.Q9_smooth(C.window(i).valley_ind))*1000;
    feature(i,8)=(max(C.Q9_smooth(C.window(i).peak1_ind),C.Q9_smooth(C.window(i).peak2_ind))-C.Q9_smooth(C.window(i).valley_ind))*1000;
    feature(i,9)=calculate_left_area(C,i,xf,yf)/(1000*1000);
    feature(i,10)=calculate_right_area(C,i,xr,yr)/(1000*1000);
    
    %    feature(i,10)=area/(1000*1000);
    
    
    %    y2=C.Q9_smooth(C.window(i).peak2_ind)*1000;
    %    x2=(y2-y1)/fallrate;
    %    feature(i,9)=0.5*x2*(y2-y1)/1000;
    
    %    feature(i,9)=(feature(i,7)*feature(i,7)/fallrate)/1000;
    
%    x1=C.timestamp(C.window(i).valley_ind)/1000;
%    y1=C.Q9_smooth(C.window(i).valley_ind)*1000;
%    y2=C.Q9_smooth(C.window(i).peak2_ind)*1000;
%    x2=(y2-y1)/riserate;
    
    %   feature(i,10)=(feature(i,7)*feature(i,7)/riserate)/1000;
    
    %    feature(i,10)=0.5*x2*(feature(i,8))/1000;
    %    feature(i,10)=0.5*x2*(y2-y1)/1000;
    
    fallrate_min=fall_time_last_x_min(C,i,10);
    riserate_min=rise_time_last_x_min(C,i,10);
    
    feature(i,11)=fallrate_min;
    feature(i,12)=riserate_min;
    feature(i,13)=fallrate_sum;
    feature(i,14)=riserate_sum;
    feature(i,15)=rise_time_new_last_x_min(C,i,5);
    feature(i,16)=calculate_left_area_new(C,i);
    feature(i,17)=calculate_right_area_new(C,i);
    
end
C.feature=feature;
C.rise=r;
C.fall=f;
end

function [angle,x,y,sum]=rate_of_change(t1,v1,t2,v2,len)
maxval=0;
angle=0;
sum=0;
for t=1:length(t1)
    ind=find(t2>t1(t));
    if isempty(ind)
        continue;
    end
    val=abs(v1(t)-v2(ind(1)));%pdist([t1(t),v1(t);t2(ind(1)),v2(ind(1))]);
    angle=(v2(ind(1))-v1(t))/(t2(ind(1))-t1(t));
    sum=sum+angle*(v2(ind(1))-v1(t))/len;
    
    if maxval<val
        maxval=val;
        x(1)=t2(ind(1));x(2)=t1(t);
        y(1)=v2(ind(1));y(2)=v1(t);
    end
end
%hold on, plot_x_time([convert_timestamp_matlabtimestamp(x(1)),convert_timestamp_matlabtimestamp(x(2))],[y(1),y(2)],'r-',2);

end
function fr_tot=fall_time_last_x_min(C,i,x)
fr_tot=0;
if C.window(i).valley_ind-x <0
    xx=1;
else
    xx=C.window(i).valley_ind-x;
end
for v=xx:C.window(i).valley_ind-1
    y1=C.Q9_smooth(v);
    y2=C.Q9_smooth(v+1);
    fr=(y2-y1)/y2;
    if fr<0
        fr_tot=fr_tot+fr;
    end
end
end

function area=calculate_right_area(C,i,xr,yr)
x1=C.timestamp(C.window(i).valley_ind);
y1=C.Q9_smooth(C.window(i).valley_ind);
x2=x1;
y2=mean([C.Q9_smooth(C.window(i).peak1_ind),C.Q9_smooth(C.window(i).peak2_ind)]);
y3=y2;
x3=x1+(y3-yr(1))*(xr(1)-xr(2))/(yr(1)-yr(2));
area=abs((y2-y1)*(x3-x2));

end
function area=calculate_left_area(C,i,xf,yf)
x1=C.timestamp(C.window(i).valley_ind);
y1=C.Q9_smooth(C.window(i).valley_ind);
x2=x1;
y2=mean([C.Q9_smooth(C.window(i).peak1_ind),C.Q9_smooth(C.window(i).peak2_ind)]);
y3=y2;
x3=xf(1)+(y3-yf(1))*(xf(1)-xf(2))/(yf(1)-yf(2));
area=abs((y2-y1)*(x3-x2));
end

function rr_tot=rise_time_new_last_x_min(C,i,x)
rr_tot=0;
vind=C.window(i).valley_ind;
valley_value=C.Q9_smooth(vind);
base=C.base;

for cur=C.window(i).valley_ind+1:C.window(i).valley_ind+50
    if cur>length(C.Q9_smooth)
        cur=cur-1;
        break;
    end
    cur_value=C.Q9_smooth(cur);
    if cur_value-valley_value>=(base-valley_value)*0.75
        break;        
    end
end
prev=max(cur-x,vind);
for now=prev:cur-1
    y1=C.Q9_smooth(now);
    y2=C.Q9_smooth(now+1);
    rr=(y2-y1)/y2;
    if rr>0
        rr_tot=rr_tot+rr;
    end
end
        
end

function rr_tot=rise_time_last_x_min(C,i,x)
rr_tot=0;

for v=C.window(i).valley_ind:C.window(i).valley_ind+x
    if length(C.Q9_smooth)<v+1
        continue;
    end
    y1=C.Q9_smooth(v);
    y2=C.Q9_smooth(v+1);
    rr=(y2-y1)/y2;
    if rr>0
        rr_tot=rr_tot+rr;
    end
end
end
function area=calculate_left_area_new(C,ind)
start=max(C.valley_ind(ind)-15,C.peak_ind(ind));
y=C.Q9_smooth(C.peak_ind(ind))-C.Q9_smooth(C.valley_ind(ind));
%y=C.base-C.Q9_smooth(C.valley_ind(i));

angle=[];
if start<1
    start=1;
end
for i=start:C.valley_ind(ind)-1
    y1=C.Q9_smooth(i);
    y2=C.Q9_smooth(i+1);
    if y2-y1<0
        angle=[angle,y2-y1];
    end
    if y2>=C.base*0.75 || y2>=C.Q9_smooth(C.peak_ind(ind))*0.75
        break;
    end
end
final_angle=median(angle);
%final_angle=mean(angle);
area=(y/final_angle)*y*60;
end

function area=calculate_right_area_new(C,ind)
y=C.Q9_smooth(C.peak_ind(ind+1))-C.Q9_smooth(C.valley_ind(ind));
%y=C.base-C.Q9_smooth(C.valley_ind(i));

endd=min(C.valley_ind(ind)+15,C.peak_ind(ind+1));
angle=[];
if endd>length(C.Q9_smooth)-1
    endd=length(C.Q9_smooth)-1;
end
for i=C.valley_ind(ind):endd
    y1=C.Q9_smooth(i);
    y2=C.Q9_smooth(i+1);
    if y2-y1>0
        angle=[angle,y2-y1];
    end
    if y2>=C.base*0.75 || y2>=C.Q9_smooth(C.peak_ind(ind+1))*0.75
        break;
    end 
end

final_angle=median(angle);

%final_angle=mean(angle);
area=(y/final_angle)*y*60;
end

function [fallrate,xf,yf,fallrate_sum]=largest_fallrate(C,i)
vlen=(1000*(C.Q9_smooth(C.window(i).valley_ind)-C.Q9_smooth(C.window(i).peak1_ind)));
p=C.window(i).peak_ind_all(find(C.window(i).peak_ind_all<C.window(i).valley_ind));
v=C.window(i).valley_ind_all(find(C.window(i).valley_ind_all<=C.window(i).valley_ind));
tp=C.timestamp(p)./(1000);          tv=C.timestamp(v)./(1000);
vp=C.Q9_smooth(p)*1000;   vv=C.Q9_smooth(v)*1000;
[fallrate,xf,yf,fallrate_sum]=rate_of_change(tp,vp,tv,vv,vlen);

end

function [riserate,xr,yr,riserate_sum]=largest_riserate(C,i)
vlen=(1000*(C.Q9_smooth(C.window(i).valley_ind)-C.Q9_smooth(C.window(i).peak2_ind)));
p=C.window(i).peak_ind_all(find(C.window(i).peak_ind_all>C.window(i).valley_ind));
v=C.window(i).valley_ind_all(find(C.window(i).valley_ind_all>=C.window(i).valley_ind));
tp=C.timestamp(p)./(1000);          tv=C.timestamp(v)./(1000);
vp=C.Q9_smooth(p)*1000;   vv=C.Q9_smooth(v)*1000;
[riserate,xr,yr,riserate_sum]=rate_of_change(tv,vv,tp,vp,vlen);

end


%{
    s=C.timestamp(C.window(i).peak1_ind);
    e=C.timestamp(C.window(i).valley_ind);
    s25=s+(e-s)*0.25;
    s75=s+(e-s)*0.75;
    timestamp=C.timestamp(find(C.timestamp>=s25 & C.timestamp<=s75));
    if length(timestamp)<2
        falltime=(C.timestamp(C.window(i).valley_ind)-C.timestamp(C.window(i).peak1_ind))/(60*1000);
    else
        falltime=(timestamp(end)-timestamp(1))/(60*1000);
    end
    
    e=C.timestamp(C.window(i).peak2_ind);
    s=C.timestamp(C.window(i).valley_ind);
    s25=s+(e-s)*0.25;
    s75=s+(e-s)*0.75;
    timestamp=C.timestamp(find(C.timestamp>=s25 & C.timestamp<=s75));

    if length(timestamp)<2
        risetime=(C.timestamp(C.window(i).peak2_ind)-C.timestamp(C.window(i).valley_ind))/(60*1000);
    else
        risetime=(timestamp(end)-timestamp(1))/(60*1000);
    end
    
%    risetime=(timestamp(end)-timestamp(1))/(60*1000);
    
%}
