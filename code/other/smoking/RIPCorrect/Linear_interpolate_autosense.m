
function [A_new, interp_idx] = Linear_interpolate_autosense(A,T)

idx = find(T>=2*mode(T));
idx_number = T(idx)./mode(T)-1;
m = [];
m(1,:) = [1,idx(1)];
for i = 2:length(idx)
    m(i,:) = [idx(i-1)+1,idx(i)];
end
m(length(idx)+1,:) = [idx(end)+1,length(A)];
A_new = [];
for i = 1:size(m,1)-1
    i
    temp = 1:idx_number(i);
    add_v = A(m(i,2)).*ones(1,idx_number(i))+(A(m(i+1,1))-A(m(i,2)))/idx_number(i).*temp;
    A_new = [A_new,A(m(i,1):m(i,2)),add_v];
end
A_new = [A_new,A(m(size(m,1),1):m(size(m,1),2))];

interp_idx = [];
acc = 0;
for k = 2:length(idx)
    acc = acc+idx_number(k-1);
    interp_idx = [interp_idx,(idx(k)+acc+1):(idx(k)+acc+idx_number(k))];
end

interp_idx = [idx(1)+1:idx(1)+idx_number(1), interp_idx];