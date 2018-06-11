function y=ADJUST_BASELINE_DRIFT(breaths) %breaths is the matrix of row for start and end of breath and the exhale adjustm for flow
global DATA BASELINE_ADJ AV_O2 AV_CO2
%Adjusts baseline drift and then returns the flow file
c=0;%keeps track of which row to look at
cc=1; %keep tracks of the number of summed values for average
baseline=zeros(length(breaths)+1,1);%holder for average value between breaths
flag=0; %change from 0 to 1 when a breath is detected 
length(DATA);
lb=size(breaths);
rr=lb(1,1); %gets the number of data points in breaths, length does not work if rows < 4 

breaths=round(breaths);%converts breaths to integer
baselajn(1,1)=mean(DATA(1:breaths(1,1),3));%for flow, get average diff pressure from first row until first breath
baselajn(1,2)=mean(DATA(1:breaths(1,1),5));%for CO2, get average CO2% from first row until first breath
baselajn(1,3)=mean(DATA(1:breaths(1,1),6));%for O2, get average O2 % from first row until first breath
for uu=2:rr%now use counter and get average values in between breaths
    baselajn(uu,1)=mean(DATA(breaths(uu-1,2):breaths(uu,1),3));%for flow, get average diff pressure btween breaths
    baselajn(uu,2)=mean(DATA(breaths(uu-1,2):breaths(uu,1),5));%for CO2, get average CO2% between breaths
    baselajn(uu,3)=mean(DATA(breaths(uu-1,2):breaths(uu,1),6));%for O2, get average O2 between breaths
    if uu==rr
       %Get average after last breath
       baselajn(uu+1,1)=mean(DATA(breaths(uu,2):length(DATA),3));%for flow, get average diff pressure from first row until first breath
       baselajn(uu+1,2)=mean(DATA(breaths(uu,2):length(DATA),5));%for CO2, get average CO2% from first row until first breath
       baselajn(uu+1,3)=mean(DATA(breaths(uu,2):length(DATA),6));%for O2, get average O2 % from first row until first breath
    end    
end   


AV_O2=baselajn(:,3);%average O2 xonxwntration between breaths, used to get VO2 in mwtabolic_rate
AV_CO2=baselajn(:,2); %average O2 xonxwntration between breaths, used to get VCO2 in mwtabolic_rate

adj_data=DATA; %make sure that DATA is not adjusted until we know it is correct
%Create column 7 that holds 0=no breath, 1=in breath
for i=1:length(breaths)
    if i==1
        adj_data(1:breaths(i,1),7)=0; %zero is no breath
        adj_data(breaths(i,1):breaths(i,2),7)=1;%first breath
    elseif i==length(breaths)
        adj_data(breaths(i,1):breaths(i,2),7)=1;
    else
        adj_data(breaths(i-1,2):breaths(i,1),7)=0; %previous end of breath
        adj_data(breaths(i,1):breaths(i,2),7)=1;%start of breath
    end
end

%baseline correct pressure
y=1;
for i=1:length(DATA)-5 %for each data point, base line correct with the correct value
    adj_data(i,3)=adj_data(i,3)-baselajn(y,1);%adjust pressure
    if adj_data(i,7)==1 && adj_data(i+1,7)==0 %end of breath and update to next baseline adjust
        y=y+1;
    end
end
BASELINE_ADJ=baselajn(:,1);%baseline is the average drift between breaths.baseline; 
DATA(:,7)=adj_data(:,7); %add colume 7 to DATA
y=adj_data;%baseline adjusted data

%%%%%%%Zero the baseline between breaths for flow
aa=DATA(:,3);
%%%%adjusts the start and end of the breath so zeros are slightly before
%%%%and after
dummy=breaths;
dummy(:,1)=dummy(:,1)-10; 
dummy(:,2)=dummy(:,2)+10;
%%%
for i=1:length(dummy)
if i==1
aa(1:dummy(1,1))=0;
elseif i==length(dummy)
aa(dummy(length(dummy),2):length(aa))=0;
else
aa(dummy(i-1,2):dummy(i,1))=0;
end
end

return


