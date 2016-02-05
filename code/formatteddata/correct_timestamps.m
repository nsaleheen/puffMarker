function [sample,timestamp] = correct_timestamps(G,sample_i,timestamp_i,segment,freq)

sample_interval = 1000/freq;
packet_interval = sample_interval*G.SAMPLE_TOS;


timestamp = [];
for i=1:size(segment,1)
    times = timestamp_i(segment(i,1):segment(i,2));
    [timestamp_oneseg] = correct_timestamps_onesegment(G,times,sample_interval,packet_interval);
    timestamp = [timestamp timestamp_oneseg'];
end

[sample,timestamp] = remove_overlaps(sample_i,timestamp);

end
function [data,timestamp] = remove_overlaps(data,timestamp)
ind=find(timestamp~=0);
timestamp=timestamp(ind);
data=data(ind);
while true
    ind=find(diff(timestamp)<=0)+1;
    if isempty(ind)==1
        break;
    end
    timestamp(ind)=[];
    data(ind)=[];
end
end


function timestamp = correct_timestamps_onesegment(G,times,sample_interval,packet_interval)
COST.COST_POSITIVE = 1;
COST.COST_NEGATIVE = 10000000;

times = times(times ~= 0);
ideal = times(1):packet_interval:times(end)+packet_interval;

if ideal(end-1) == times(end)
    ideal = ideal(1:end-1);
end

Nideal = length(ideal);
Nreal = length(times);
Nrealorigin = Nreal;
shifted_start_ind = 1;  %new starting ind, because for inds less than this ind, the time alignment would lead to incorrect alignment

while Nideal < Nreal
    shifted_start_ind = shifted_start_ind + 1;
    times1 = times(shifted_start_ind:end);
    ideal = times(1):packet_interval:times1(end)+packet_interval;
    if ideal(end-1) == times1(end)
        ideal = ideal(1:end-1);
    end
    Nideal = length(ideal);
    Nreal = length(times1);
end

num_of_table_rows = Nideal - Nreal + 1;

table = zeros(num_of_table_rows,Nreal);
path = zeros(num_of_table_rows,Nreal);

for i=2:num_of_table_rows
    path(i,1) = 2;
end

for i=2:Nreal
    table(1,i) = table(1,i-1) + diag_dist(times(i),ideal(i),COST.COST_NEGATIVE,COST.COST_POSITIVE);
end

for i=2:Nreal
    for j=2:num_of_table_rows
        ddiag = table(j,i-1) + diag_dist(times(i),ideal(i-1+j),COST.COST_NEGATIVE,COST.COST_POSITIVE);
        dvert = table(j-1,i);
        if dvert >= ddiag
            table(j,i) = ddiag;
        else
            table(j,i) = dvert;
            path(j,i) = 2;
        end
    end
end


table = [];

chosen_col = Nreal;
chosen_row = num_of_table_rows;
connectors = zeros(Nreal,1);
while chosen_row+chosen_col > 2
    if path(chosen_row,chosen_col) == 0
        connectors(chosen_col) = chosen_col+chosen_row-1;
        chosen_col = chosen_col-1;
    else
        chosen_row = chosen_row-1;
    end
end
connectors(1) = 1;
path = [];

timestamp = zeros(Nrealorigin*G.SAMPLE_TOS,1);

for i=1:G.SAMPLE_TOS
    %	temp = times(1)-sample_interval*(i-1);
    %	if temp > previous_last_timestamp
    %		startingind = shifted_start_ind*G.SAMPLE_TOS+1+G.SAMPLE_TOS-i;
    %		timestamp(startingind) = temp;
    %   end
    timestamp((shifted_start_ind-1)*G.SAMPLE_TOS+1+G.SAMPLE_TOS-i) = times(1)-sample_interval*(i-1);
end

%length(timestamp)
%connectors
%shifted_start_ind
for i=2:length(connectors)
    step = (ideal(connectors(i))-ideal(connectors(i)-1))*1.0/G.SAMPLE_TOS;
    %    [(shifted_start_ind-1)*G.SAMPLE_TOS+(i-1)*G.SAMPLE_TOS+1,(shifted_start_ind-1)*G.SAMPLE_TOS+i*G.SAMPLE_TOS]
    %    (ideal(connectors(i)-1)+step):step:ideal(connectors(i))
    timestamp((shifted_start_ind-1)*G.SAMPLE_TOS+(i-1)*G.SAMPLE_TOS+1:(shifted_start_ind-1)*G.SAMPLE_TOS+i*G.SAMPLE_TOS) = (ideal(connectors(i)-1)+step):step:ideal(connectors(i));
end

k = 1;
for i=1:shifted_start_ind-1
    for j=1:G.SAMPLE_TOS
        %		temp = timestamp(shifted_start_ind*G.SAMPLE_TOS+1)-k*sample_interval;
        
        %		if temp > previous_last_timestamp
        %			startingind = shifted_start_ind*G.SAMPLE_TOS+1-k;
        %			timestamp(startingind)=temp;
        %       end
        timestamp((shifted_start_ind-1)*G.SAMPLE_TOS+1-k)=timestamp((shifted_start_ind-1)*G.SAMPLE_TOS+1)-k*sample_interval;
        k = k + 1;
    end
end
%length(timestamp)
%pause
%timestamp = timestamp(startingind:end);



end



function d = diag_dist(real,ideal,cost_neg,cost_pos)

temp = real - ideal;
if temp < 0
    d = -cost_neg*temp;
else
    d = cost_pos*temp;
end

end
