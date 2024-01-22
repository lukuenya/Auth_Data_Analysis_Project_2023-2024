% Matthieu Ndumbi Lukuenya, 9217

%% Task 4

%{
    - Select two seasons and an Hour
    - Bootstrap analysis: For each hour, calculate the difference in median in bike rentals between the two seasons
    - Determine the Statistical significance of the difference in median that do not include zero
    - Repeat for each hour and each pair of seasons (6 pairs)
    - Plot the results and interpret.

%}

% Load the data
data = readtable('SeoulBike.xlsx');

% Define season pairs and hours and season names
season_pairs = nchoosek(1:4, 2);
hours = 0:23;
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

% Initialize result matrix
results = zeros(length(hours), size(season_pairs, 1));

% Bootstrap analysis
for hour = hours
    for pair = 1:size(season_pairs, 1)
        season1_data = data.RentedBikeCount(data.Hour == hour & data.Seasons == season_pairs(pair, 1));
        season2_data = data.RentedBikeCount(data.Hour == hour & data.Seasons == season_pairs(pair, 2));

        % Perform bootstrap
        med_diffs = bootstrap_median_diff(season1_data, season2_data, 1000);

        % Calculate the percentage of intervals not including zero
        results(hour + 1, pair) = mean(med_diffs ~= 0) * 100;
    end
end

% Create a figure for line plots
figure;
hold on;

% Iterate through each season pair
for i = 1:size(season_pairs, 1)
    season_pair = season_pairs(i, :);
    plot(0:23, results(:, i), 'DisplayName', ...
         [season_names{season_pair(1)} '-' season_names{season_pair(2)}]);
end

% Customize the plot
xlabel('Hour of the Day');
ylabel('Percentage of Confidence Intervals Not Including Zero');
title('Significant Differences in Bike Rentals Between Seasons');
legend('Location', 'best');
grid on;

hold off;

% Function to perform bootstrap analysis
function med_diffs = bootstrap_median_diff(data1, data2, num_samples)
    med_diffs = zeros(num_samples, 1);
    for i = 1:num_samples
        sample1 = datasample(data1, length(data1));
        sample2 = datasample(data2, length(data2));
        med_diffs(i) = median(sample1) - median(sample2);
    end
end

%{
    - Generally, there are high significant differences in bike rentals between seasons. 
    - However, it can be noted that bike rentals between seasons(Summer-Autumn) and between hours 6:00 - 10:00, there is a big drop in significant differences that could indicate a weak seasonal effect.
%}


