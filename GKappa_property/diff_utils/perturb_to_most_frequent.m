%1. Each time the perturbation goes to the category with the largest number of data samples
function perturbedArray = perturb_to_most_frequent(inputArray, perturbRatio)
    %Perturb some elements in the array to the most frequent numbers
    %parameter:
    %inputArray - a one-dimensional array
    %perturbRatio - perturbation ratio (between 0 and 1)
    %return:
    %perturbedArray - the perturbed array

    %Find the most frequent number in an array
    uniqueValues = unique(inputArray);
    counts = histc(inputArray, uniqueValues);
    [~, maxIndex] = max(counts);
    mostFrequentValue = uniqueValues(maxIndex);

    %Calculate the number of elements that need to be perturbed
    numElements = length(inputArray);
    numToPerturb = round(numElements * perturbRatio);

    %Randomly select the index to be perturbed
    perturbIndices = randperm(numElements, numToPerturb);

    %Create perturbed array
    perturbedArray = inputArray;
    perturbedArray(perturbIndices) = mostFrequentValue;
end
