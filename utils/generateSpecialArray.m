function outputArray = generateSpecialArray(startVal, endVal)
    %startVal - the left interval of the sequence
    %endVal - the right interval of the sequence
    %Output: Array of length (endVal - startVal + 1)
    %Most of them are 0, only the sum of three consecutive elements is 1

    if startVal > endVal
        error('起始值必须小于等于结束值');
    end

    n = endVal - startVal + 1;

    if n < 3
        error('区间长度至少为3才能满足连续三个数之和为1');
    end

    %Initialized to all 0
    outputArray = zeros(1, n);

    %Randomly select a starting position (from 1 to n-2), ensuring that there are three consecutive numbers
    startIndex = randi([1, n - 2]);

    %Generate three random numbers at this location such that their sum is 1
    values = rand(1, 3);
    values = values / sum(values);  %Normalize so that the sum is 1

    %Assign these three values ​​to the corresponding positions in the array
    outputArray(startIndex:startIndex+2) = values;

end