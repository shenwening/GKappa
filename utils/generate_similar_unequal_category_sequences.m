function [sequence1, sequence2] = generate_similar_unequal_category_sequences(vectorLength, n, rho, s_tho)
% Generate two sequences, where one sequence has a specific category rho0 accounting for rho proportion, 
% and the other sequence has similarity s_tho with the first sequence
% vectorLength: Sequence length
% n: Category range
% rho: Proportion of specified category rho0
% s_tho: Similarity of the second sequence with the first sequence

  
    rho0 = randi([1, n]);
  
    rho0_count = round(rho * vectorLength);

    other_count = vectorLength - rho0_count;

    
    rho0_sequence = repmat(rho0, 1, rho0_count);

  
    other_categories = setdiff(1:n, rho0);
    other_sequence = datasample(other_categories, other_count, 'Replace', true);

   
    sequence1 = [rho0_sequence, other_sequence];

   
    sequence1 = sequence1(randperm(vectorLength));

  
    num_changes = round((1 - s_tho) * vectorLength);

  
    sequence2 = sequence1;

   
    indices_to_change = randperm(vectorLength, num_changes);

   
    for i = 1:num_changes
    
        new_category = datasample(setdiff(1:n, sequence2(indices_to_change(i))), 1);
        sequence2(indices_to_change(i)) = new_category;
    end
end

