function [b,c]=binarysearch(x,A,B)
a=1;
b=numel(x);
c=1;
d=numel(x);
while (a+1<b||c+1<d)
    lw=(floor((a+b)/2));
    if (x(lw)<A)
        a=lw;
    else
        b=lw;
    end
    lw=(floor((c+d)/2));
    if (x(lw)<=B)
        c=lw;
    else
        d=lw;
    end
end
end
