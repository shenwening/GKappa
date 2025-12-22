
function newSequence = generateCorrelatedSequence(startVal, endVal, sequence, rho)
    % startVal - Lower bound of sequence values
    % endVal - Upper bound of sequence values
    % sequence - Original sequence
    % rho - Correlation proportion with original sequence (0 <= rho <= 1)

    if iscolumn(sequence)
        sequence = sequence';
    end

    if ~(isscalar(startVal) && isscalar(endVal))
        error('Start and end values must be scalars');
    end

    if startVal > endVal
        error('Start value must be less than or equal to end value');
    end

    if ~isvector(sequence)
        error('Input sequence must be a vector');
    end

    if rho < 0 || rho > 1
        error('Correlation coefficient rho must be within [0, 1]');
    end

    n = length(sequence);
    numFixed = floor(rho * n);  % Determine number of elements to fix

    if numFixed > n || numFixed < 0
        error('Invalid rho, please ensure 0 <= rho <= 1');
    end

    % Randomly select indices to fix
    indicesToFix = randperm(n, numFixed);

    % Initialize new sequence as original sequence
    newSequence = double(sequence);  % Convert to double to support arithmetic operations

    % Get indices that are not selected
    allIndices = 1:n;
    indicesToModify = setdiff(allIndices, indicesToFix);

    % Add small perturbations to unfixed positions (e.g., ±1), ensuring they don't equal original values
    for i = 1:length(indicesToModify)
        idx = indicesToModify(i);
        originalVal = sequence(idx);
        perturbedVal = originalVal + randi([-1, 1]);

        % If perturbed value equals original value, perturb again
        while perturbedVal == originalVal
            perturbedVal = originalVal + randi([-1, 1]);
        end

        newSequence(idx) = perturbedVal;
    end

    % Ensure new sequence remains within [startVal, endVal] range
    newSequence(newSequence < startVal) = startVal;
    newSequence(newSequence > endVal) = endVal;

    % Verify consistency (for debugging)
    numMatched = sum(newSequence == sequence);
    % assert(numMatched == numFixed, 'Actual matched count should strictly equal specified fixed count');
endfunction newSequence = generateCorrelatedSequence(startVal, endVal, sequence, rho)
    %startVal - the lower limit of the sequence value
    %endVal - upper limit of sequence value
    %sequence - the original sequence
    %rho - correlation ratio to the original sequence (0 <= rho <= 1)

    if iscolumn(sequence)
        sequence = sequence';
    end

    if ~(isscalar(startVal) && isscalar(endVal))
        error('起始值和结束值必须为标量');
    end

    if startVal > endVal
        error('起始值必须小于等于结束值');
    end

    if ~isvector(sequence)
        error('输入序列必须为向量');
    end

    if rho < 0 || rho > 1
        error('相关系数 rho 必须在 [0, 1] 范围内');
    end

    n = length(sequence);
    numFixed = floor(rho * n);  %Determine the number of elements that need to be fixed

    if numFixed > n || numFixed < 0
        error('rho 不合法，请确保 0 <= rho <= 1');
    end

    %Randomly select a fixed position index
    indicesToFix = randperm(n, numFixed);

    %Initialize the new sequence to the original sequence
    newSequence = double(sequence);  %Convert to double to support addition and subtraction operations

    %Get the unselected position
    allIndices = 1:n;
    indicesToModify = setdiff(allIndices, indicesToFix);

    %Add a small perturbation (e.g. ±1) to the unfixed position and make sure it does not equal the original value
    for i = 1:length(indicesToModify)
        idx = indicesToModify(i);
        originalVal = sequence(idx);
        perturbedVal = originalVal + randi([-1, 1]);

        %If the perturbation is equal to the original value, perturb it again.
        while perturbedVal == originalVal
            perturbedVal = originalVal + randi([-1, 1]);
        end

        newSequence(idx) = perturbedVal;
    end

    %Make sure the new sequence is still in the range [startVal, endVal]
    newSequence(newSequence < startVal) = startVal;
    newSequence(newSequence > endVal) = endVal;

    %Verify consistency (for debugging)
    numMatched = sum(newSequence == sequence);
    %assert(numMatched == numFixed, 'The actual number of matches should be strictly equal to the specified fixed number');
end