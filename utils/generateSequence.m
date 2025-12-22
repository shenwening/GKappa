function sequence = generateSequence(startVal, endVal, numSamples)
    if startVal > endVal
        error('');
    end
    
    if ~(isscalar(startVal) && isscalar(endVal))
        error('');
    end

   
    sequence = randi([startVal, endVal], numSamples, 1);
end