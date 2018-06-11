function y=DOLPHIN_FLOW_MR
global DATA FLOW_ADJUST

a=GET_DOLPHIN_DATA;%picks up the data file with 1) time, 2)esophageal, 3) flow, 4) empty, 5) CO2 and 6)O2 in columns
b=GET_FLOW_ADJUST;%the number of known breath, compared with the number of breaths detected in breath detect
breaths=GET_BREATH_ROWS;
[baselinedriftcorrected]=ADJUST_BASELINE_DRIFT(breaths);


flow_rate=ADJUST_FLOW_RATE(baselinedriftcorrected, breaths);
vt = integrate_flow(flow_rate);
summary_data=GET_END_TIDAL(breaths, flow_rate, vt);%% returns end-tidal O2 end-tidal CO2 maximum flow minimum flow tidal volume]
mr=metabolic_rate(flow_rate, breaths); %returns an array with cumulative O2, CO2 and corrected flow rate


raw_data=[DATA(:,1) mr(:,3) DATA(:,3) DATA(:,4) DATA(:,5) DATA(:,6) vt mr(:,1) mr(:,2)];%time, flow_rate-corrected, airway pressure, esophageal pressure, CO2, O2, tidal volume-expired, tidal volume-inspired, cumulative O2, cumulative CO2 


saveraw(raw_data);%saves the corrected data, all data
savesummary(summary_data,breaths,mr); %saves a summary file with data for each breath 
save breaths breaths -ascii -tabs -double

y=1;
return

