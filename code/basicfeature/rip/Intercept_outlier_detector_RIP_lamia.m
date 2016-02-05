function [Up_intercept2,Down_intercept2]=Intercept_outlier_detector_RIP_lamia(upInterceptIndex,DownInterceptIndex,sample,timestamp,T)

count=[];
UI=[];
DI=[];
D=DownInterceptIndex;
U=upInterceptIndex;
% Making U and D of equal length
minimumLength=min(length(U),length(D));
D=DownInterceptIndex(1:minimumLength);
U=upInterceptIndex(1:minimumLength);

% Removal of  2 or more consecutive Up intercepts or consecutive Down Intercept
i=1;j=1;
while(i<length(U)-1)
    while(j<length(D)-1)
        
        ind=[];
        if U(1)<D(1)
            if U(i)<D(j)<U(i+1)
                UI=[UI U(i)];
                ind=find(D>D(j) & D<U(i+1));
                if isempty(ind)
                    DI=[DI D(j)];
                    j=j+1;
                else
                    DI=[DI D(j+ind(end))];
                    j=j+length(ind)+1;
                end
                i=i+1;
            elseif  U(i)<D(j)>U(i+1)
                ind=find(U>U(i) & U<D(j))
                count=count+1;
                if isempty(ind)
                    UI=[UI U(i)];
                    i=i+1;
                else
                    UI=[UI U(i+ind(end))];
                    i=i+length(i)+1;
                end
                DI=[DI D(j)];
                j=j+1;
            end
        elseif D(1)<U(1)
            
            if D(i)<U(j)<D(i+1)
                DI=[DI D(i)];
                ind=find(U>U(j) & U<D(i+1));
                if isempty(ind);
                    UI=[UI U(j)];
                    j=j+1;
                else UI=[UI U(j+ind(end))];
                    j=j+length(ind)+1;
                end
                i=i+1;
            elseif D(i)<U(j)>D(i+1)
                UI=[UI U(j)];
                ind=find(D>D(i) & D<U(j));
                if isempty(ind)
                    DI=[DI D(i)];
                    i=i+1;
                else DI=[DI D(i+ind(end))];
                    i=i+length(ind)+1;
                end
                j=j+1;
                
            end
            
        end
    end
end
if UI(1)<DI(1)  % To start calculation from Down Intercept
    UI=UI(2:end);
end

minLength=min(length(UI),length(DI)); % make UI and DI equal length
UI=UI(1:minLength);
DI=DI(1:minLength);

% Keep intercept pair (consecutive down and up) if brething frequency is
% within range of: 8 breathe/min <fr< 65 breathe/min
fr=[];
Down_intercept=[];
Up_intercept=[];
for i=1:length(DI)-1
    fr=60/(timestamp(DI(i+1))-timestamp(DI(i)));
    if 8<=fr<=65
        Down_intercept=[Down_intercept DI(i)];
        Up_intercept=[Up_intercept UI(i)];
    end
end

% If two Intercepts (consecutive up and down)come within T/20 second time gap, remove those
% intercept pair

Up_intercept2=[];
Down_intercept2=[];
Down_intercept2=[Down_intercept2 Down_intercept(1)];

equivalent_sample_points=(T/20)*21.33;
upTOdown_distance=[];
for i=1:length(Down_intercept)-1
    upTOdown_distance=Down_intercept(i+1)-Up_intercept(i)+1;

    if upTOdown_distance>equivalent_sample_points
        Up_intercept2=[Up_intercept2 Up_intercept(i)];
        Down_intercept2=[Down_intercept2 Down_intercept(i+1)];
        
    end
end
end
