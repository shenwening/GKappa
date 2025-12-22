function [ tau_b ] = MS_tb( a,b )
%  Kendall's Tau-b
n = length(a);
c = 0;
d = 0;
ties1 = 0;
ties2 = 0;

for i = 1:n-1
    for j = i+1:n
        if a(i) < a(j) && b(i) < b(j)
            c = c + 1;
        elseif a(i) > a(j) && b(i) > b(j)
            c = c + 1;
        elseif a(i) < a(j) && b(i) > b(j)
            d = d + 1;
        elseif a(i) > a(j) && b(i) < b(j)
            d = d + 1;
        elseif a(i) == a(j) && b(i) ~= b(j)
            ties1 = ties1 + 1;
        elseif a(i) ~= a(j) && b(i) == b(j)
            ties2 = ties2 + 1;
        end
    end
end

tau_b = (c - d) / sqrt((c + d + ties1) * (c + d + ties2));

end

