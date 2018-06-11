function y=breath_detect(flow, sample_rate)%flow=data for flow-rate
%this function searches the beginning and end of breaths using the
%assumption that exhalations are negative and goes from around 0
%flow-rate/volt to negative values rapidly and then hanges rapidly to
%positive values. It need to be adjusted if input changes, i.e. volt or
%flow-rate
global resp_timing

off_zero=0.4; % a value that is off the control baseline
breath_flag=0;% a flag to indicate a breath
flag_exh=0; %flag for exhalation
flag_inh=0; %flag for inhalation
av_min=0;


d_fr=flow(1:length(flow)-1)-flow(2:length(flow)); %the change in flow-rate from 1 to the end
%d_fr(length(flow)+11)=0; %pad a 0 at the end
breath=zeros(1,4); %initialize the breaths array which will hold row for, column 1:start of exhale, 2: end exhale 3: start inhale, same as 2 if no pause 4: end inhale
b_c=1; %breath counter 

low=-0.5;%low is low vlue for exhale detction, may need change if units are different, i.e. l/sec vs volt
high=0.5;%low is low vlue for inhale detction, may need change if units are different, i.e. l/sec vs volt
av_min=-0.5; % a value to look at an average over 100 samples as when exhale those should be less than -3
dt_max=0.01;
for i=2:length(flow)-300
   
    
    %Need a check to make sure there are no previous exhalations only
    %if flag_exh==0 && min(flow(i:i+300))<low && min(d_fr(i:i+10))<(low) && mean(flow(i:i+100))<av_min && flow(i-1)>=low/20 %checks that current, and next 5 rows are negative (assumes exhale is at least 100 msec) and that previous row was close to 
    if flag_exh==0 && flag_inh==0 && mean(d_fr(i:i+5))>(dt_max) && mean(d_fr(i:-1:i-5))<(high) && min(flow(i:i+300))<-3 %

        breath_flag=1; %start of a breath, begins with an exhale
        flag_exh=1;%start of exhale
        breath(b_c,1)=i; %breath array column 1 gets the row for start of the breath      
    elseif flag_exh==1 && flag_inh==0 && flow(i)<0 && min(flow(i+1:i+10))>=0  %end of exhalation
        flag_exh=0;%end of exhale
        breath(b_c,2)=i; %breath array column 1 gets the row for end of ehxale
        if flow(i+2:i+15)>high%start of inhalation
            flag_inh=1;
            breath(b_c,3)=i; %breath array column 3 gets the row for start of the inhalation
        end
    elseif flag_exh==0 && flag_inh==0 && flow(i)>high && flow(i+1)>high && flow(i+2)>high && flow(i+3)>high && flow(i+4)>high && flow(i+5)>high && flow(i-1)>0.1 %checks that current, and next 5 rows are negative (assumes exhale is at least 100 msec) and that previous row was close to 
        
        %this elseif statement captures those breaths with a short delay in
        %between exhale and inhale
        breath_flag=1; %make sure that breath_flag is still 1
        flag_inh=1;%start of exhale
        breath(b_c,3)=i; %breath array column 1 gets the row for start of the breath
    %elseif flag_exh==0 && flag_inh==1 && flow(i)>high && flow(i+1)<high && flow(i+2)<off_zero && flow(i+3)<off_zero && flow(i+4)<off_zero && flow(i+5)<off_zero %end of inhalation
    elseif flag_exh==0 && flag_inh==1 && flow(i)>=0 && flow(i-1)>0 && flow(i+1)<=0 %&& mean(d_fr(i:-1:i-5))<(-0.1) %end of inhalation
        flag_inh=0;%end inhalation
        breath_flag=0;
        breath(b_c,4)=i; %breath array column 1 gets the row for end of the breath
      
        b_c=b_c+1;
        
    end
end
%%%%% the below section removes "noise" or sections that are detected as
%%%%% inhalation only
%for i=1:length(breath)
%if breath(i,1)==0
%st=breath(i-1,4)+20;
%en=breath(i,4)+20;
%aa(st:en)=0.00001;
%end
%end


breath_dur=(breath(:,4)-breath(:,1)).*sample_rate;%calculates the duration of each breath
exhalation_dur=(breath(:,2)-breath(:,1)).*sample_rate;%calculates the duration of exhale
inhalation_dur=(breath(:,4)-breath(:,3)).*sample_rate;%calculates the duration of each inhale 

resp_timing=[breath breath_dur exhalation_dur inhalation_dur];
saveresptiming(resp_timing);
y=breath;

end

