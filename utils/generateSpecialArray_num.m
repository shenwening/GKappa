function outputArray = generateSpecialArray_num(startVal, endVal, num)
    % startVal - Left interval of sequence
    % endVal   - Right interval of sequence
    % num      - Number of consecutive non-zero elements (default value is 3)
    % Output: Array of length (endVal - startVal + 1)
    %         Mostly zeros, only sum of consecutive num elements is 1

    if startVal > endVal
        error('Start value must be less than or equal to end value');
    end

    n = endVal - startVal + 1;

    % Set default value of num to 3
    if nargin < 3
        num = 3;
    end

    if num < 1 || num > n
        error(['num must be within [1, ', num2str(n), ']']);
    end

    % Initialize all zeros
    outputArray = zeros(1, n);

    % Randomly select a starting position (from 1 to n-num+1)
    startIndex = randi([1, n - num + 1]);

    % Generate num random numbers at that position, making their sum equal to 1
    values = rand(1, num);
    values = values / sum(values);  % Normalize to make the sum equal to 1

    % Assign these values to the corresponding positions in the array
    outputArray(startIndex:startIndex + num - 1) = values;

end