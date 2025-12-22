%2. Each time the disturbance is put into a random category in the data sample
function perturbedArray = perturb_to_random_category(inputArray, perturbRatio, categoryRangeStart, categoryRangeEnd)
    %Perturb some elements in an array to random categories within a specified range
    %parameter:
    %inputArray - a one-dimensional array
    %perturbRatio - perturbation ratio (between 0 and 1)
    %categoryRangeStart - category starting range
    %categoryRangeEnd - Category end range
    %return:
    %perturbedArray - the perturbed array

    %Validate input parameters
    if perturbRatio < 0 || perturbRatio > 1
        error('扰动比率必须在0到1之间');
    end

    if categoryRangeStart > categoryRangeEnd
        error('类别起始范围不能大于结束范围');
    end

    %Generate random categorical values ​​within a specified range
    categoryRange = categoryRangeStart:categoryRangeEnd;
    randomCategory = categoryRange(randi(length(categoryRange)));

    %Calculate the number of elements that need to be perturbed
    numElements = length(inputArray);
    numToPerturb = round(numElements * perturbRatio);

    %Randomly select the index to be perturbed
    perturbIndices = randperm(numElements, numToPerturb);

    %Create perturbed array
    perturbedArray = inputArray;
    perturbedArray(perturbIndices) = randomCategory;
end