% comparative irradiance
% horizontal surface facing directly south

vancouver = [1.09	2.00	3.10	4.51	5.39	5.69 6.00	5.15	3.92	2.14	1.27	0.90];
aarhus = [0.55	1.24	2.47	4.00	5.42	5.70 5.52	4.51	2.86	1.51	0.72	0.44];
falmouth = [1.85 	2.65 	3.78 	4.69 	5.62 	6.04 5.88 	5.35 	4.30 	3.17 	2.02	1.59];
figure(1), clf, hold on, plot(aarhus), plot(falmouth), plot(vancouver), 
xlim([1 12])
legend('Aarhus','Falmouth','Vancouver')
set(gca,'xtick',1:12,'xticklabels',{'J','F','M','A','M','J','J','A','S','O','N','D'})
ylabel('Average Solar Insolation (kWh/m^2/day)')
adjustfigurefont