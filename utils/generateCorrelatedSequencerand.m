function newSequence = generateCorrelatedSequencerand(startVal, endVal, sequence, rho, maxPerturb)
    % startVal - Lower bound of sequence values
    % endVal - Upper bound of sequence values
    % sequence - Original sequence
    % rho - Correlation proportion with original sequence (0 <= rho <= 1)
    % maxPerturb - Maximum perturbation value, default is 1

    if iscolumn(sequence)
        sequence = sequence';
    end

    if ~(isscalar(startVal) && isscalar(endVal))
        error('Start and end values must be scalars');
    end

    if startVal >= endVal
        error('Start value must be less than end value');
    end

    if ~isvector(sequence)
        error('Input sequence must be a vector');
    end

    if rho < 0 || rho > 1
        error('Correlation coefficient rho must be within [0, 1]');
    end

    % Set default perturbation value
    if nargin < 5
        maxPerturb = 1;
    end

    if ~isscalar(maxPerturb) || maxPerturb < 0
        error('Maximum perturbation value must be a non-negative scalar');
    end

    n = length(sequence);
    numFixed = floor(rho * n);

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

    % Add perturbations to unfixed positions
    for i = 1:length(indicesToModify)
        idx = indicesToModify(i);
        originalVal = sequence(idx);
        perturbedVal = originalVal + randi([-maxPerturb, maxPerturb]);

        % If perturbed value equals original value or is not within (startVal, endVal) range, re-perturb
        while perturbedVal == originalVal || ...
              perturbedVal <= startVal || ...
              perturbedVal >= endVal

            perturbedVal = originalVal + randi([-maxPerturb, maxPerturb]);

            % Safety mechanism to prevent infinite loops
            retryCount = 0;
            maxRetries = 100;
            while (perturbedVal == originalVal || ...
                   perturbedVal <= startVal || ...
                   perturbedVal >= endVal) && retryCount < maxRetries
                perturbedVal = originalVal + randi([-maxPerturb, maxPerturb]);
                retryCount = retryCount + 1;
            end

            if retryCount >= maxRetries
                warning('Unable to find suitable perturbation value, restored to default random value within bounds');
                perturbedVal = randi([startVal + 1, endVal - 1]);  % Force assignment of a valid value
                break;
            end
        end

        newSequence(idx) = perturbedVal;
    end

    % Ensure final results fall within [startVal, endVal] range
    newSequence(newSequence < startVal) = startVal;
    newSequence(newSequence > endVal) = endVal;

end