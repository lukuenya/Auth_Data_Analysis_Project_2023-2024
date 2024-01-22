

%% Task 5

%% Dataset : Seoul Bike Demand (SeoulBike.xlsx)

%{
    - Select each season and Hour
    - Calculate the Pearson correlation coefficient for each combination of season and hour to measure the strength of the linear relationship between the Temperature and the Rented Bike Count
    - Statistical Significance: Perform a ttest to check the statistical significance of the correlation coefficient
    - Create a scatter of bike rentals againt temperature for different combinations, indicating the correlation coefficient and its statistical significance on each plot.
    - Identify the strongest correlations and comment on whether they appear to be at the same time(s) in each season
%}

% Load the data
data = readtable('SeoulBike.xlsx');

% Define seasons and hours
seasons = 1:4; % 1: Winter, 2: Spring, 3: Summer, 4: Autumn
hours = 0:23;
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

% Create a figure for subplots
figure;

% Iterate over each season
for s = 1:length(seasons)
    % Initialize arrays for storing correlation results
    R_values = zeros(length(hours), 1);
    p_values = zeros(length(hours), 1);

    % Iterate over each hour
    for h = 1:length(hours)
        % Extract bike rentals and temperature for the specific season and hour
        season_hour_data = data(data.Seasons == seasons(s) & data.Hour == hours(h), :);
        bike_rentals = season_hour_data.RentedBikeCount;
        temperatures = season_hour_data.Temperature__C_;

        % Calculate Pearson correlation coefficient
        [R, p] = corr(bike_rentals, temperatures, 'Rows', 'complete');
        
        % Store the correlation values
        R_values(h) = R;
        p_values(h) = p;
    end
    
    % Plot the results in a subplot
    subplot(2, 2, s);
    plot(hours, R_values, 'b', hours, p_values, 'r');
    title(['Correlation by Hour - ' season_names{s}]);
    xlabel('Hour of the Day');
    ylabel('Correlation/P-value');
    legend('Correlation', 'P-value');
    grid on;
end

%{
    - We oberve strong correlations between the temperature and the bike rentals between 5am and 10am (or to be precise around 8am) in Winter, Spring and Autumn.
%}


