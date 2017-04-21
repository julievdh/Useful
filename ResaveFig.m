% To import old figure (.jpg, .tiff, anything) and convert to high
% resolution EPS file for publication

% load in old figure

img = MMSCI3581_Fig6_vanderHoop_r600.eps;
imagesc(img);                     %# Plot the image
set(gca,'Units','normalized',...  %# Set some axes properties
        'Visible','off');
set(gcf,'Units','pixels',...      %# Set some figure properties
    'Position',[760 -20 285 700]);
    
%        'Position',[100 100 size(img,2) size(img,1)]);
    print(gcf,'new_Figure6.eps','-depsc2','-r600');  %# Print the figure
