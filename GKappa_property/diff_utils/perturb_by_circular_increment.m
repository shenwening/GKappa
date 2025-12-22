function perturbedArray = perturb_by_circular_increment(inputArray, perturbRatio, categoryRangeStart, categoryRangeEnd)
    %Perturb some elements in the array by adding 1 in a loop
    %parameter:
    %inputArray - a one-dimensional array
    %perturbRatio - perturbation ratio (between 0 and 1)
    %categoryRangeStart - category starting range
    %categoryRangeEnd - Category end range
    %return:
    %perturbedArray - the perturbed array
    %
    %Perturbation rules: 1->2, 2->3, ..., maximum value->minimum value (cyclic)

    %Validate input parameters
    if perturbRatio < 0 || perturbRatio > 1
        error('扰动比率必须在0到1之间');
    end

    if categoryRangeStart >= categoryRangeEnd
        error('类别起始范围必须小于结束范围');
    end

    %Calculate the number of elements that need to be perturbed
    numElements = length(inputArray);
    numToPerturb = round(numElements * perturbRatio);

    %Randomly select the index to be perturbed
    perturbIndices = randperm(numElements, numToPerturb);

    %Create perturbed array
    perturbedArray = inputArray;

    %Perform a cyclic increment operation on the selected element.
    for i = 1:numToPerturb
        idx = perturbIndices(i);
        currentValue = inputArray(idx);

        %Only perturb values ​​within the specified range
        if currentValue >= categoryRangeStart && currentValue <= categoryRangeEnd
            if currentValue == categoryRangeEnd
                perturbedArray(idx) = categoryRangeEnd-1;  %Loop back to starting value
            else
                perturbedArray(idx) = currentValue + 1;    %Normal plus 1
            end
        end
    end
end
