function [ G ] = config_run_MinnesotaLab( G )
G.STUDYNAME='MinnesotaLab';
G.TIME.TIMEZONE=-6;
G.TIME.DAYLIGHTSAVING=1;
G.TIME.FORMAT='mm/dd/yyyy HH:MM:SS';

G.DIR.DATA=[G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP G.STUDYNAME];

G.PS_LIST= {
%    {'p01'},(cellstr(strcat('s',num2str((1:5)','%02d'))))';
%    {'p02'},(cellstr(strcat('s',num2str((1:5)','%02d'))))';
%    {'p03'},(cellstr(strcat('s',num2str((4:4)','%02d'))))';
%    {'p04'},(cellstr(strcat('s',num2str((4:4)','%02d'))))';
%    {'p05'},(cellstr(strcat('s',num2str((1:4)','%02d'))))';
%    {'p06'},(cellstr(strcat('s',num2str((1:4)','%02d'))))';
%    {'p07'},(cellstr(strcat('s',num2str((1:4)','%02d'))))';
%    {'p08'},(cellstr(strcat('s',num2str((1:4)','%02d'))))';
%    {'p09'},(cellstr(strcat('s',num2str((1:4)','%02d'))))';
%    {'p10'},(cellstr(strcat('s',num2str((1:4)','%02d'))))';
% {'p6000'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6001'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6002'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6007'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6010'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6012'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6013'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6014'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6015'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6016'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
% {'p6019'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
%    {'p6500'},(cellstr(strcat('s',num2str((1:4)','%02d'))))';
%    {'p6503'},(cellstr(strcat('s',num2str((1:10)','%02d'))))';
%    {'p6506'},(cellstr(strcat('s',num2str((1:10)','%02d'))))';
%    {'p6510'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
%    {'p6511'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
%    {'p6003'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
%    {'p6008'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
%    {'p6514'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
%    {'p6517'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';

%  {'p6500'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%,
%   {'p6501'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';
% {'p6502'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%,
% {'p6503'},(cellstr(strcat('s',num2str([01,02,11,12,13]','%02d'))))';
%  {'p6505'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%   {'p6506'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,
%      {'p6507'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%
%     {'p6510'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,,12,13,14,15
%     {'p6511'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,
%     {'p6000'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,
%     {'p6001'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,
%     {'p6002'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%,02,11,12,13,14
%     {'p6003'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%     {'p6008'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%     {'p6514'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%     {'p6517'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6007'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6010'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6012'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6013'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6014'},(cellstr(strcat('s',num2str([01,02,03,04,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6015'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6016'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6019'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14

%      {'p6000'},(cellstr(strcat('s',num2str([01,11,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6001'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6002'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6003'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6007'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6008'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6010'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6012'},(cellstr(strcat('s',num2str([11]','%02d'))))';%01,02,11,12,13,14
%      {'p6000'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6001'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6002'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6003'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6007'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6008'},(cellstr(strcat('s',num2str([02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6010'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6012'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% 
%      {'p6013'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6014'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6015'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6016'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6019'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6500'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6501'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6502'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6503'},(cellstr(strcat('s',num2str([01,02,11,12,13]','%02d'))))';%01,02,11,12,13
%      {'p6505'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6506'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6507'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% 
%      {'p6510'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6511'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6514'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6517'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
    
     % FALSE POS
%        {'p6001'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%        {'p6501'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%        {'p6502'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%        {'p6503'},(cellstr(strcat('s',num2str([11,12,13]','%02d'))))';%01,02,11,12,13,14
%        {'p6505'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%        {'p6506'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%        {'p6511'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%        {'p6514'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
  
%       % LAPSER 
%      {'p6000'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6001'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6002'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6003'},(cellstr(strcat('s',num2str([01,02,11,12]','%02d'))))';%01,02,11,12,13,14
%  
% {'p6007'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6008'},(cellstr(strcat('s',num2str([02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6010'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6012'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% 
%      {'p6013'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6014'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6015'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6016'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6019'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6500'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6507'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% 
%      {'p6510'},(cellstr(strcat('s',num2str([01,02,11,12,14]','%02d'))))';%01,02,11,12,13,14
%      {'p6517'},(cellstr(strcat('s',num2str([01,02,11,14]','%02d'))))';%01,02,11,12,13,14
   
%1st lapes
% {'p6000'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6007'},(cellstr(strcat('s',num2str(14))))';%01,02,11,12,13,14
% {'p6008'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6010'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6014'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6015'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% 
% {'p6500'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6503'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6510'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
%   

% ------------------------
% {'p6021'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14     1
% {'p6023'},(cellstr(strcat('s',num2str([11,12, 13]','%02d'))))';%01,02,11,12,13,14
% {'p6026'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% 
% {'p6530'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14     1
% {'p6531'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14     1
% {'p6535'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14     1
% {'p6537'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14     1

% {'p6025'},(cellstr(strcat('s',num2str([01,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6501'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6511'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6532'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6534'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% 
% %NOLAPSER
% {'p6540'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6541'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6542'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14

% {'p6023'},(cellstr(strcat('s',num2str([131,132,133,134]','%03d'))))';%

 %1st lapes
% {'p6000'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6007'},(cellstr(strcat('s',num2str([141,142,143,144]','%03d'))))';%01,02,11,12,13,14
% {'p6008'},(cellstr(strcat('s',num2str([111,112,113,114,121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6010'},(cellstr(strcat('s',num2str([121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str([111,112,113,114,121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6014'},(cellstr(strcat('s',num2str([121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6015'},(cellstr(strcat('s',num2str([121,122,123,124,131,132,133,134]','%03d'))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str([111,112,113,114,121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6021'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6023'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6025'},(cellstr(strcat('s',num2str([121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6026'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% % {'p6027'},(cellstr(strcat('s',num2str(13))))';%NEXT
% % {'p6030'},(cellstr(strcat('s',num2str(12))))';NEXT
% 
% {'p6500'},(cellstr(strcat('s',num2str([121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6501'},(cellstr(strcat('s',num2str([141,142,143,144]','%03d'))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6503'},(cellstr(strcat('s',num2str([121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str([111,112,113,114,121,122,123,124,131,132,133,134]','%03d'))))';%01,02,11,12,13,14
% {'p6510'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6511'},(cellstr(strcat('s',num2str([121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str([121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6530'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6531'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14
% {'p6532'},(cellstr(strcat('s',num2str([131,132,133,134]','%03d'))))';%01,02,11,12,13,14
% {'p6535'},(cellstr(strcat('s',num2str([121,122,123,124]','%03d'))))';%01,02,11,12,13,14
% {'p6537'},(cellstr(strcat('s',num2str([111,112,113,114]','%03d'))))';%01,02,11,12,13,14

% {'p6027'},(cellstr(strcat('s',num2str([01,02,11,12,13]','%02d'))))';%01,02,11,12,13,14
% {'p6023'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14

%.................FIRST LAPSE ALL DAY-------------------------
% {'p6000'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6007'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6008'},(cellstr(strcat('s',num2str([02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6010'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6014'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6015'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str([01,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6021'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6023'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6025'},(cellstr(strcat('s',num2str([01,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6026'},(cellstr(strcat('s',num2str([01,02,11,12,13]','%02d'))))';%01,02,11,12,13,14
% % {'p6027'},(cellstr(strcat('s',num2str(13))))';%NEXT
% % {'p6030'},(cellstr(strcat('s',num2str(12))))';NEXT
% 
% {'p6500'},(cellstr(strcat('s',num2str([01,02,11,12,13,14,15]','%02d'))))';%01,02,11,12,13,14
% {'p6501'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6503'},(cellstr(strcat('s',num2str([01,02,11,12,13]','%02d'))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6510'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14

% {'p6511'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6530'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6531'},(cellstr(strcat('s',num2str([01,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6532'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6535'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6537'},(cellstr(strcat('s',num2str([01,02,11,12,13,14]','%02d'))))';%01,02,11,12,13,14
%---------- FIRST LAPSE ALL DAY END------------------------------------------------


 %1st lapes
% {'p6000'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6007'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6008'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6010'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6014'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6015'},(cellstr(strcat('s',num2str([11,12,13]','%02d'))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6021'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6023'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6025'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6026'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6027'},(cellstr(strcat('s',num2str([11,12,13]','%02d'))))';%01,02,11,12,13,14
% {'p6030'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% 
% {'p6027'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6030'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6500'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6501'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6503'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str([11,12,13]','%02d'))))';%01,02,11,12,13,14
% {'p6510'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6511'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6530'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6531'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6532'},(cellstr(strcat('s',num2str([11,12,13]','%02d'))))';%01,02,11,12,13,14
% {'p6535'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6537'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14

%-------------------first day lapse day
%1st lapes
% {'p6000'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6007'},(cellstr(strcat('s',num2str(14))))';%01,02,11,12,13,14
% {'p6008'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6010'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6011'},(cellstr(strcat('s',num2str(15))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6014'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6015'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6021'},(cellstr(strcat('s',num2str(11))))';
% {'p6023'},(cellstr(strcat('s',num2str(11))))';
% {'p6025'},(cellstr(strcat('s',num2str(12))))';
% {'p6026'},(cellstr(strcat('s',num2str(11))))';
% {'p6027'},(cellstr(strcat('s',num2str(13))))';
% {'p6030'},(cellstr(strcat('s',num2str(12))))';
% 
% {'p6500'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6503'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6510'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6511'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6530'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6531'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6532'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6535'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6537'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14


 %day after  lapes day
% % NEXT DAY LAPSE
% {'p6000'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6008'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6010'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6014'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6015'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6021'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6023'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6025'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6026'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6030'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6500'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6503'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6510'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6511'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6530'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6531'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
% {'p6532'},(cellstr(strcat('s',num2str(13))))';%01,02,11,12,13,14
% {'p6537'},(cellstr(strcat('s',num2str(12))))';%01,02,11,12,13,14
 %---------------------
 % NEXT NEXT lapse
% {'p6000'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6021'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6023'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6026'},(cellstr(strcat('s',num2str([13]','%02d'))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str([13]','%02d'))))';%01,02,11,12,13,14
% % {'p6510'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% % {'p6517'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
 
% 
% {'p6510'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6530'},(cellstr(strcat('s',num2str([12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6535'},(cellstr(strcat('s',num2str([13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6537'},(cellstr(strcat('s',num2str([12,13,14]','%02d'))))';%01,02,11,12,13,14




% {'p6000'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6007'},(cellstr(strcat('s',num2str([11,12,13,14]','%02d'))))';%01,02,11,12,13,14
% {'p6008'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6010'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6011'},(cellstr(strcat('s',num2str([11,12,13,14,15]','%02d'))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6014'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6015'},(cellstr(strcat('s',num2str([11,12,13]','%02d'))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6021'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6023'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6025'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6026'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6027'},(cellstr(strcat('s',num2str([11,12,13]','%02d'))))';%01,02,11,12,13,14
% {'p6030'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
%  
% {'p6500'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6503'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str([11,12,13]','%02d'))))';%01,02,11,12,13,14
% {'p6510'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6511'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6530'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6531'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14
% {'p6532'},(cellstr(strcat('s',num2str([11,12,13]','%02d'))))';%01,02,11,12,13,14
% % {'p6535'},(cellstr(strcat('s',num2str([11,12]','%02d'))))';%01,02,11,12,13,14
% {'p6537'},(cellstr(strcat('s',num2str(11))))';%01,02,11,12,13,14


%---- PRE QUIT LAPSE
 % NEXT NEXT lapse
 %1st lapes
% {'p6000'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6007'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6008'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6010'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6014'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6015'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6021'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6023'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6025'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6026'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6027'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6030'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% 
% {'p6500'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6501'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6503'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6510'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6511'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6530'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6531'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6532'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6535'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14
% {'p6537'},(cellstr(strcat('s',num2str([01,02]','%02d'))))';%01,02,11,12,13,14

% %  
% {'p6000'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6002'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6003'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6007'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% % {'p6008'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6010'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6012'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6013'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6014'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6015'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6016'},(cellstr(strcat('s',num2str([011,012]','%03d'))))';%01,02,11,12,13,14
% {'p6019'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6021'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6023'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6025'},(cellstr(strcat('s',num2str([011,012]','%03d'))))';%01,02,11,12,13,14
% {'p6026'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6027'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6030'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
%  
% {'p6500'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6501'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6502'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6503'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6507'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6510'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6511'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6517'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6525'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6530'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6531'},(cellstr(strcat('s',num2str([011,012]','%03d'))))';%01,02,11,12,13,14
% {'p6532'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6535'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14
% {'p6537'},(cellstr(strcat('s',num2str([011,012,021,022]','%03d'))))';%01,02,11,12,13,14

{'p30'},(cellstr(strcat('s',num2str([02]','%02d'))))';%01,02,11,12,13,14


     };
%% Formatted Raw
%G.RUN.FRMTRAW.SENSORLIST_TOS=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,...
%    G.SENSOR.WL9_ACLYID,G.SENSOR.WR9_ACLYID];

G.RUN.FRMTRAW.SENSORLIST_TOS=[ ...
    G.SENSOR.R_RIPID,G.SENSOR.R_ECGID, ...
    G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
    G.SENSOR.A_ALCID,G.SENSOR.R_BAT_SKN_AMB_ID,G.SENSOR.R_BATID,G.SENSOR.R_SKINID,G.SENSOR.R_AMBID,G.SENSOR.A_GSRID,G.SENSOR.A_TEMPID ...
    G.SENSOR.WR9_ACLXID G.SENSOR.WR9_ACLYID G.SENSOR.WR9_ACLZID G.SENSOR.WR9_GYRXID G.SENSOR.WR9_GYRYID G.SENSOR.WR9_GYRZID G.SENSOR.WL9_NULLID ...
    G.SENSOR.WL9_ACLXID G.SENSOR.WL9_ACLYID G.SENSOR.WL9_ACLZID G.SENSOR.WL9_GYRXID G.SENSOR.WL9_GYRYID G.SENSOR.WL9_GYRZID G.SENSOR.WR9_NULLID ...
    ];

G.RUN.FRMTRAW.SENSORLIST_DB=[G.SENSOR.P_ACLXID, G.SENSOR.P_ACLYID, G.SENSOR.P_ACLZID];
G.RUN.FRMTRAW.SENSORLIST_GPS=[G.SENSOR.P_GPS_LATID, G.SENSOR.P_GPS_LONGID, G.SENSOR.P_GPS_ALTID, G.SENSOR.P_GPS_SPDID, G.SENSOR.P_GPS_BEAR, G.SENSOR.P_GPS_ACCURACYID];

G.RUN.EMA_METADATA_TABLE_LIST = {'EMA_metadata_default_questions', 'EMA_metadata_saliva_questions', 'EMA_metadata_saliva_ema_questions'};

G.SELFREPORT.SMKID=5; G.SELFREPORT.ID(G.SELFREPORT.SMKID).NAME='smoking';    G.SELFREPORT.ID(G.SELFREPORT.SMKID).DB_TABLE='model201';
G.SELFREPORT.CRAVING_ID=1; G.SELFREPORT.ID(G.SELFREPORT.CRAVING_ID).NAME='craving';    G.SELFREPORT.ID(G.SELFREPORT.CRAVING_ID).DB_TABLE='model202';
G.SELFREPORT.STRESS_ID=2; G.SELFREPORT.ID(G.SELFREPORT.STRESS_ID).NAME='stress';    G.SELFREPORT.ID(G.SELFREPORT.STRESS_ID).DB_TABLE='model203';
G.SELFREPORT.CONVERSATION_ID=3; G.SELFREPORT.ID(G.SELFREPORT.CONVERSATION_ID).NAME='conversation';    G.SELFREPORT.ID(G.SELFREPORT.CONVERSATION_ID).DB_TABLE='model204';
G.SELFREPORT.SALIVA_ID=4; G.SELFREPORT.ID(G.SELFREPORT.SALIVA_ID).NAME='saliva';    G.SELFREPORT.ID(G.SELFREPORT.SALIVA_ID).DB_TABLE='model205';
G.RUN.FRMTRAW.SELFREPORTLIST=[G.SELFREPORT.CRAVING_ID,G.SELFREPORT.STRESS_ID,G.SELFREPORT.CONVERSATION_ID,G.SELFREPORT.SALIVA_ID,G.SELFREPORT.SMKID];

G.RUN.FRMTRAW.LOADDATA=0;
G.RUN.FRMTRAW.TOS=1;
G.RUN.FRMTRAW.PHONESENSOR=0;
G.RUN.FRMTRAW.GPS=0;
G.RUN.FRMTRAW.SELFREPORT=1;
G.RUN.FRMTRAW.LABSTUDYMARK=0;
G.RUN.FRMTRAW.LABSTUDYLOG=0;
G.RUN.FRMTRAW.EMA=1; %0; % 1
G.RUN.FRMTRAW.CRESS=0;
G.RUN.FRMTRAW.DATALABEL=0;

%% Formatted Data
G.RUN.FRMTDATA.SENSORLIST_CORRECTTIMESTAMP=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
    G.SENSOR.A_ALCID,G.SENSOR.R_BAT_SKN_AMB_ID,G.SENSOR.A_GSRID,G.SENSOR.A_TEMPID];
G.RUN.FRMTDATA.SENSORLIST_INTERPOLATE=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_GSRID,G.SENSOR.R_ACLXID, G.SENSOR.R_ACLYID, G.SENSOR.R_ACLZID,...
    G.SENSOR.A_ALCID,G.SENSOR.R_BAT_SKN_AMB_ID,G.SENSOR.A_GSRID,G.SENSOR.A_TEMPID];
G.RUN.FRMTDATA.SENSORLIST_QUALITY=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];

G.RUN.FRMTDATA.LOADDATA=0;
G.RUN.FRMTDATA.EMA=0; %0; %1;
G.RUN.FRMTDATA.CORRECTTIMESTAMP=1;
G.RUN.FRMTDATA.INTERPOLATE=1;
G.RUN.FRMTDATA.QUALITY=1;

G.RUN.BASICFEATURE.LOADDATA=0;
G.RUN.BASICFEATURE.PEAKVALLEY=1;
G.RUN.BASICFEATURE.RR=1;

G.RUN.WINDOW.LOADDATA=0;
G.RUN.FEATURE.LOADDATA=0;
G.RUN.MODEL=G.MODEL.STRESS60;

G.BIAS(G.SENSOR.R_ACLXID)=1865;
G.BIAS(G.SENSOR.R_ACLYID)=1875;
G.BIAS(G.SENSOR.R_ACLZID)=1958;

end
