Y = [];

for i = 1:(size(dat_testing,2))
    x = dat_testing(:, i);
        for j = 1:(size(dat_testing,1))
            Y(j, i) = dat_testing(j, i) / norm(x);
        end
end

Y1 = normc(dat_testing);