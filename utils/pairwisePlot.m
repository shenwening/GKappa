function pairwisePlot(data1, data2)
    %PAIRWISEPLOT draws a scatter plot of two data series and adds a 45-degree reference line
    %
    %How to use:
    %      pairwisePlot(data1, data2)
    %parameter:
    %data1 - the first data sequence, vector, or column array
    %data2 - the second data sequence, the same length as data1
    
    %Create graphics window
    figure;
    
    %Draw a scatter plot
    scatter(data1, data2, 'filled');
    
    %Set graph title and axis labels
    title('Pairwise Plot with 45-degree Line');
    xlabel('Measurement 1');
    ylabel('Measurement 2');
    
    %Add 45 degree guide line
    hold on;
    min_val = min([min(data1), min(data2)]);
    max_val = max([max(data1), max(data2)]);
    plot([min_val, max_val], [min_val, max_val], 'r--'); %The red dotted line represents the 45 degree line
    legend('Data Points', '45-degree Line');
    
    %Keep proportions consistent to accurately display the 45 degree line
    axis equal;
    
    %show grid
    grid on;
end