function Lo=findfiles(varargin)

% findfiles returns a list of all the files in current tree
% findfiles(D) returns files in tree rooted at D
% findfiles(D,R) returns files whose complete name contains regular expression R
% findfiles(L,R) where L is a structure containing a list of files,
% produces a list of the files that contain regular expression R

negate=0;

if nargin==0
    Lo=findfiles(pwd,'.',[]);
    return;
end;

if nargin==1
    Lo=findfiles(varargin{1},'.',[]);
    return;
end;

if nargin==2
    if ~iscell(varargin{1})
        Lo=findfiles(varargin{1},varargin{2},[]);
    else
        L=varargin{1};
        R=varargin{2};
        if iscell(R)
            negate=R{2};
            R=R{1};
        end;
        Lo=[];
        k=0;
        for i=1:length(L)
            if xor(~isempty(regexp(L{i},R)),negate)
                k=k+1;
                Lo{k}=L{i};
            end;
        end;
    end;
    return;
end;

D=varargin{1};
R=varargin{2};
        if iscell(R)
            negate=R{2};
            R=R{1};
        end;
Lo=varargin{3};
d=dir(D);
for i=3:length(d)
    if d(i).isdir
        newdir=[D,'\',d(i).name];
        Lo=findfiles(newdir,R,Lo);
    else
        newfile=[D,'\',d(i).name];
        if xor(~isempty(regexp(newfile,R)),negate);
            Lo{length(Lo)+1}=newfile;
        end;
    end;
end;

