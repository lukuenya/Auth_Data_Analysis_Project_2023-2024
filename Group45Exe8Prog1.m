

%% Task 8

%% Dataset : Seoul Bike Demand (SeoulBike.xlsx)

%{
    Objective:
        - Explore if a linear regression model's fit (predicting bike rentals from temperature) varies significantly between two seasons at a particular hour
        - This involves comparing the goodness-of-fit statistics (like R-squared) of the linear regression models for these two seasons and testing if there's a significant difference between them.
%}

clear;
clc;
close all;

%% Import data
data = readtable('SeoulBike.xlsx');

% Define specific hour and season pairs.
specific_hour = 14;
season_pairs = nchoosek(1:4, 2);

% Iterate through each season pair.
for pair = 1:size(season_pairs, 1)
    season1 = season_pairs(pair, 1);
    season2 = season_pairs(pair, 2);

    % Filter data for the specific hour and season.
    data_season1 = data(data.Seasons == season1 & data.Hour == specific_hour, :);
    data_season2 = data(data.Seasons == season2 & data.Hour == specific_hour, :);

    % Fit linear regression models for each season.
    model_season1 = fitlm(data_season1, 'RentedBikeCount ~ Temperature__C_');
    model_season2 = fitlm(data_season2, 'RentedBikeCount ~ Temperature__C_');

    % Calculate R-squared for each model.
    Rsq1 = model_season1.Rsquared.Ordinary;
    Rsq2 = model_season2.Rsquared.Ordinary;

    % Bootstrap test to compare the R-squared values.

    % Number of bootstrap samples
    numBootstrap = 1000;

    % Initialize array to store differences in R-squared values
    rsq_diffs = zeros(numBootstrap, 1);

    % Bootstrap loop
    for i = 1:numBootstrap
        % Resample data with replacement for each season
        bs_data_season1 = datasample(data_season1, height(data_season1));
        bs_data_season2 = datasample(data_season2, height(data_season2));
        
        % Fit linear models on the resampled data
        bs_lm1 = fitlm(bs_data_season1.('Temperature__C_'), bs_data_season1.('RentedBikeCount'));
        bs_lm2 = fitlm(bs_data_season2.('Temperature__C_'), bs_data_season2.('RentedBikeCount'));

        % Calculate R-squared values for resampled data
        bs_Rsq1 = bs_lm1.Rsquared.Ordinary;
        bs_Rsq2 = bs_lm2.Rsquared.Ordinary;

        % Store the difference in R-squared values
        rsq_diffs(i) = bs_Rsq1 - bs_Rsq2;
    end

    % Calculate p-value (two-tailed test)
    p_value = mean(abs(rsq_diffs) >= abs(Rsq1 - Rsq2));

    % Output the p-value
    fprintf('Season pair %d-%d, Hour %d, P-value: %.4f\n', season1, season2, specific_hour, p_value);

end

%{
    Conclusion:
        - Generally The p-value is greater than 0.05 for all season pairs, This indicates that there is no statistically significant difference in the goodness-of-fit of the linear regression models between each pair of seasons. In other words, the linear model's ability to predict bike rentals from temperature is fairly consistent across these season pairs for this particular hour.
        - Since all the p-values are quite high, it implies that the influence of temperature on bike rentals, as captured by the linear models, does not vary significantly between these pairs of seasons at 2 PM.
        - This consistency suggests that the same linear model could reasonably be used to predict bike rentals from temperature across these different season pairs for this time of day.
%}




