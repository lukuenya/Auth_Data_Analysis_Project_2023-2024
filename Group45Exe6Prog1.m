

%% Task 6 : Mutual Information I(X,Y)

%% Dataset : Seoul bike demand (SeoulBike.xlsx)

% Load the data
data = readtable('SeoulBike.xlsx');

% Define seasons
seasons = 1:4; % 1: Winter, 2: Spring, 3: Summer, 4: Autumn
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

% Iterate over each season
for s = 1:length(seasons)
    % Filter data for the current season
    season_data = data(data.Seasons == seasons(s), :);

    % Iterate over each hour
    for h = 0:23
        % Extract bike rentals and temperature for the specific hour
        hour_data = season_data(season_data.Hour == h, :);
        bike_rentals = hour_data.RentedBikeCount;
        temperatures = hour_data.Temperature__C_;

        k = 10; 

        % Calculate GMIC
        gmic = gaussianized_maximal_information_coefficient(temperatures, bike_rentals, k);
        mic = maximal_information_coefficient(temperatures, bike_rentals, k);

        % Perform significance tests for GMIC and MIC
        % Define the number of permutations
        n_permutations = 10;

        % Initialize arrays to store the permuted GMIC and MIC values
        permuted_GMIC = zeros(n_permutations, 1);
        permuted_MIC = zeros(n_permutations, 1);

        % Perform the permutations
        for i = 1:n_permutations
            % Randomly permute the values of bike_rentals
            bike_rentals_permuted = bike_rentals(randperm(length(bike_rentals)));
            
            % Calculate the GMIC and MIC for the permuted data
            permuted_GMIC(i) = gaussianized_maximal_information_coefficient(temperatures, bike_rentals_permuted, k);
            permuted_MIC(i) = maximal_information_coefficient(temperatures, bike_rentals_permuted, k);
        end

        % Calculate the p-values as the proportion of permuted GMIC/MIC values that are greater than or equal to the observed values
        p_value_GMIC = mean(permuted_GMIC >= gmic);
        p_value_MIC = mean(permuted_MIC >= mic);

        % Print the p-values
        fprintf('p-value for GMIC: %f\n', p_value_GMIC);
        fprintf('p-value for MIC: %f\n', p_value_MIC);

        % Create scatter plot for each hour
        figure;
        scatter(temperatures, bike_rentals);
        title(sprintf('Season: %s, Hour %d - GMIC: %.2f, MIC: %.2f', season_names{s}, h, gmic, mic));
        xlabel('Temperature (°C)');
        ylabel('Bike Rentals');

        % Annotate for significance
        if p_value_GMIC < 0.05
            sig_GMIC = '*';
        elseif p_value_GMIC < 0.01
            sig_GMIC = '**';
        else
            sig_GMIC = 'n.s.';
        end

        if p_value_MIC < 0.05
            sig_MIC = '*';
        elseif p_value_MIC < 0.01
            sig_MIC = '**';
        else
            sig_MIC = 'n.s.';
        end

        % Add text to the plot
        text(0.1, 0.9, ['GMIC p = ', num2str(p_value_GMIC), ', ', sig_GMIC], 'Units', 'normalized');
        text(0.1, 0.8, ['MIC p = ', num2str(p_value_MIC), ', ', sig_MIC], 'Units', 'normalized');
    end
end
% Functions to calculate GMIC and MIC

function H = entropy(X)
    % Calculate the entropy of a distribution for given probability values.
    p = histcounts(X, 'Normalization', 'probability');
    p = p(p>0); % Exclude zero probabilities
    H = -sum(p .* log2(p));
end

function H = joint_entropy(X, Y)
    % Calculate the joint entropy of two distributions for given probability values.
    p = histcounts2(X, Y, 'Normalization', 'probability');
    p = p(p>0); % Exclude zero probabilities
    H = -sum(p(:) .* log2(p(:)));
end

function I = mutual_information(X, Y)
    % Calculate the Mutual Information
    I = entropy(X) + entropy(Y) - joint_entropy(X, Y);
end

function I = gaussian_mutual_information(X, Y)
    % Calculate the Gaussian Mutual Information
    rho = corr(X, Y);
    I = -0.5 * log(1 - rho^2);
end

function MIC = maximal_information_coefficient(X, Y, k)
    % Calculate the Maximal Information Coefficient (MIC)
    MIC = mutual_information(X, Y) / log2(k);
end

function GMIC = gaussianized_maximal_information_coefficient(X, Y, k)
    % Calculate the Gaussianized Maximal Information Coefficient (GMIC)
    GMIC = gaussian_mutual_information(X, Y) / log2(k);
end



