function sequence = generateSequence_proportions(scale, proportions, totalSamples)
    % generateSequence Generate a random sequence containing different category samples, controlled by proportion distribution
    %
    % Input parameters:
    %   scale           - Rating/category label array (e.g., [1, 2, 3])
    %   proportions     - Proportion of each category (same length as scale, sum should be 1)
    %   totalSamples    - Total number of samples to generate
    %
    % Output:
    %   sequence        - Generated random sequence (row vector)

    
 
    if abs(sum(proportions) - 1) > 1e-10
        error('proportions vector probabilities must sum to 1.');
    end


   
    numSamplesPerClass = round(proportions * totalSamples);

   
    numSamplesPerClass(end) = totalSamples - sum(numSamplesPerClass(1:end-1));


    
    sequence = [];

 
    for i = 1:length(scale)
      
        sequence = [sequence, repmat(scale(i), 1, numSamplesPerClass(i))];
    end



    sequence = sequence(randperm(totalSamples));
end