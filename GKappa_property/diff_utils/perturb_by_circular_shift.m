function perturbedArray = perturb_by_circular_shift(inputArray, perturbRatio, categoryRangeStart, categoryRangeEnd, shiftPositions)
    %Perturb some elements in the array in a circular shift manner
    %parameter:
    %inputArray - a one-dimensional array
    %perturbRatio - perturbation ratio (between 0 and 1)
    %categoryRangeStart - category starting range
    %categoryRangeEnd - Category end range
    %shiftPositions - Number of positions to move (positive number means moving backward, negative number means moving forward)
    %return:
    %perturbedArray - the perturbed array
    %
    %Perturbation rule: The element moves cyclically n positions within the specified range
    %For example: when shiftPositions=2, 1->3, 2->4, 4->1, 5->2 (assuming the range is 1-5)

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

    %Calculate the length of a category range
    rangeLength = categoryRangeEnd - categoryRangeStart + 1;

    %Perform a circular shift operation on selected elements
    for i = 1:numToPerturb
        idx = perturbIndices(i);
        currentValue = inputArray(idx);

        %Only perturb values ​​within the specified range
        if currentValue >= categoryRangeStart && currentValue <= categoryRangeEnd
            %Calculate relative position (relative to starting position)
            relativePosition = currentValue - categoryRangeStart;

            %perform circular shift
            newPosition = mod(relativePosition + shiftPositions, rangeLength);

            %Make sure the result is non-negative
            if newPosition < 0
                newPosition = newPosition + rangeLength;
            end

            %Convert back to actual value
            perturbedArray(idx) = newPosition + categoryRangeStart;
        end
    end
end