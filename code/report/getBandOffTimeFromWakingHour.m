function [duration offStart offEnd] =getBandOffTimeFromWakingHour(R,starttime,endtime)
        if ~isfield(R,'wakeUpTime') && ~isfield(R,'sleepTime')
            duration=(endtime-starttime)/1000;
            offStart=starttime;
            offEnd=endtime;
        elseif isfield(R,'wakeUpTime') && ~isfield(R,'sleepTime')
            if starttime<=R.wakeUpTime && endtime>=R.wakeUpTime
                offStart=R.wakeUpTime;
                offEnd=endtime;
                duration=(endtime-R.wakeUpTime)/1000;
            elseif starttime<=R.wakeUpTime && endtime<=R.wakeUpTime
                duration=0;
                offStart=R.wakeUpTime;
                offEnd=R.wakeUpTime;
            else
                duration=(endtime-starttime)/1000;
                offStart=starttime;
                offEnd=endtime;
            end
        elseif ~isfield(R,'wakeUpTime') && isfield(R,'sleepTime')
            if starttime<=R.sleepTime && endtime>=R.sleepTime
                duration=(R.sleeptTime-starttime)/1000;
                offStart=starttime;
                offEnd=R.sleeptTime;
            elseif starttime>=R.sleepTime && endtime>=R.sleepTime
                duration=0;
                offStart=R.sleepTime;
                offEnd=R.sleeptTime;
            else
                duration=(endtime-starttime)/1000;
                offStart=starttime;
                offEnd=endtime;
             end            
        elseif isfield(R,'wakeUpTime') && isfield(R,'sleepTime')          
            if starttime>=R.wakeUpTime && endtime<=R.sleepTime
                duration=(endtime-starttime)/1000;
                offStart=starttime;
                offEnd=endtime;
            elseif starttime>=R.sleepTime && endtime>=R.sleepTime
                offStart=R.sleepTime;
                offEnd=R.sleepTime;
                duration=0;
            elseif starttime<=R.wakeUpTime && endtime<=R.wakeUpTime
                offStart=R.wakeUpTime;
                offEnd=R.wakeUpTime;
                duration=0;
            elseif starttime<=R.wakeUpTime && endtime>=R.wakeUpTime
                offStart=R.wakeUpTime;
                offEnd=endtime;
                duration=(endtime-R.wakeUpTime)/1000;
            elseif starttime<=R.wakeUpTime && endtime>=R.sleepTime
                offStart=R.wakeUpTime;
                offEnd=R.sleepTime;
                duration=(R.sleepTime-R.wakeUpTime)/1000;
            elseif starttime<=R.sleepTime && endtime>=R.sleepTime
                offStart=R.sleepTime;
                offEnd=starttime;
                duration=(R.sleepTime-starttime)/1000;
            end         
        end       
end