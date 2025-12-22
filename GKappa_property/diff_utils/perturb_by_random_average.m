function perturbedArray = perturb_by_random_average(inputArray, perturbRatio, categoryRangeStart, categoryRangeEnd)
    %Perturb some elements in the array into the average of random numbers and original values
    %parameter:
    %inputArray - a one-dimensional array
    %perturbRatio - perturbation ratio (between 0 and 1)
    %categoryRangeStart - category starting range
    %categoryRangeEnd - Category end range
    %return:
    %perturbedArray - the perturbed array
    %
    %Perturbation rule: value after perturbation = (random number + original number) / 2
    %The random number is within the specified category range

    %Validate input parameters
    % if perturbRatio < 0 || perturbRatio > 1
    %error('Perturbation ratio must be between 0 and 1');
    % end

    if categoryRangeStart > categoryRangeEnd
        error('类别起始范围不能大于结束范围');
    end

    %Calculate the number of elements that need to be perturbed
    numElements = length(inputArray);
    numToPerturb = round(numElements * perturbRatio);

    %Randomly select the index to be perturbed
    perturbIndices = randperm(numElements, numToPerturb);

    %Create perturbed array
    perturbedArray = inputArray;

    %Perform perturbation operations on selected elements
    for i = 1:numToPerturb
        idx = perturbIndices(i);
        currentValue = inputArray(idx);

        %Only perturb values ​​within the specified range
        if currentValue >= categoryRangeStart && currentValue <= categoryRangeEnd
            %Generate random numbers within a category range
            randomValue = randi([categoryRangeStart, categoryRangeEnd]);

            %Calculate the average and round to the nearest whole number
            perturbedValue = round((randomValue + currentValue) / 2);

            %Make sure the results are still within the valid range
            perturbedValue = max(categoryRangeStart, min(categoryRangeEnd, perturbedValue));

            perturbedArray(idx) = perturbedValue;
        end
    end
end
