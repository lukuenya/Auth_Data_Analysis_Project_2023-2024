% Matthieu Ndumbi Lukuenya, 9217

%% Task 5

%% Dataset : Seoul Bike Demand (SeoulBike.xlsx)

%{
    - Select each season and Hour
    - Calculate the Pearson correlation coefficient for each combination of season and hour to measure the strength of the linear relationship between the Temperature and the Rented Bike Count
    - Statistical Significance: Perform a ttest to check the statistical significance of the correlation coefficient
    - Create a scatter of bike rentals againt temperature for different combinations, indicating the correlation coefficient and its statistical significance on each plot.
%}

% Load the data
data = readtable('SeoulBike.xlsx');

% Define seasons and hours
seasons = 1:4; % 1: Winter, 2: Spring, 3: Summer, 4: Autumn
hours = 0:23;

% Iterate over each season and hour
for s = seasons
    for h = hours
        % Extract bike rentals and temperature for the specific season and hour
        season_hour_data = data(data.Seasons == s & data.Hour == h, :);
        bike_rentals = season_hour_data.RentedBikeCount;
        temperatures = season_hour_data.Temperature__C_;

        % Calculate Pearson correlation coefficient
        [R, p] = corr(bike_rentals, temperatures, 'Rows', 'complete');

        % Visualization: Scatter plot
        figure;
        scatter(temperatures, bike_rentals);
        title(sprintf('Season %d, Hour %d - Correlation: %f, p-value: %f', s, h, R, p));
        xlabel('Temperature(°C)');
        ylabel('Bike Rentals');
    end
end