% plot time arcs
wake = [6 30; 8 00; 14 00];
sleep = [21 00; 23 00; 3 00];
rad = 1;

figure(1); clf; hold on

for i = 1:length(wake)
    timeClockPer(wake(i,:),sleep(i,:),rad)
end

