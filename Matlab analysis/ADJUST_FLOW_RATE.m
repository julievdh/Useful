function y=ADJUST_FLOW_RATE(datamatrix, breaths) %ddd-is the base line adjusted data file, breaths is the matrix of row for start and end of breath and the exhale adjustm for flow
global DATA
CAL_FACTOR_EXP=1.1;%11.625; %Coverts differential pressure to flow, from 46 l/sec per volt from the calibration we did and there is 2.5 V for 10CmH2O 
CAL_FACTOR_INSP=1;
y=1;

N=length(DATA);

for i=1:N %for each data point, base line correct with the correct value
    
    %if datamatrix(i,7)==0 %if between breaths, colume 7 gets 1 as we do not multiply cal factor and it is 1
     %   datamatrix(i,7)=1;
    %else
     %   datamatrix(i,7)=breaths(y,3);% add adjustment to column 7 his is the cal factor for this breath
    %end
    
    if datamatrix(i,3)<0 && DATA(i,7)==1%if exhalation, NOT SURE WHY I NEED THE ABOVE IF I HAVE THIS??? TRY REMOVE ABOVE AND HAVE =datamatrix(i,3).*breaths(y,3).*CAL_FACTOR; if exhale and 
       
        datamatrix(i,8)=datamatrix(i,3).*breaths(y,3).*CAL_FACTOR_EXP;%datamatrix(i,3).*datamatrix(i,7).*CAL_FACTOR;
    
    else
       datamatrix(i,8)=datamatrix(i,3).*CAL_FACTOR_INSP;
    end
    if DATA(i,7)==1 && DATA(i+1,7)==0 %end of breath and update to next baseline adjust
        
        y=y+1;
    end
end
flow_rate=datamatrix(:,8);

y=datamatrix(:,8);%baseline adjusted data

return

