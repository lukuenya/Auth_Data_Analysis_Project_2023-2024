% Matthieu Ndumbi Lukuenya, 9217

%% TASK 3

%% Dataset: SeoulBike.xlsx (Seoul Bike Sharing Demand)

%{
    - Choose a specific season for the analysis
    - Choose randomly two different Hours of the day
    - Calculate the difference in bike rentals between the two hours
    - Do a statistical test for Mean Difference
    - Repeat for all Hour pairs (276 pairs in total)
    - Present the results : 24x24 colormap, showing the mean-differences and the results of the statistical test for each pair of hours.
    - Comparative analysis between the seasons and comment on whether the patterns are similar or if there significant differences in certain seasons.
%}


%% Load the data
data = readtable('SeoulBike.xlsx');

%% Choose a specific season for the analysis
seasons = [1, 2, 3, 4];
season_names = {'Winter', 'Spring', 'Summer', 'Autumn'};

% Iterate over all the seasons
for s = 1:length(seasons)
    selected_season = seasons(s);
    season_data = data(data.Seasons == selected_season, :);


    %% Initialize matrices for sorting the results
    mean_diff_matrix = zeros(24, 24);
    p_value_matrix = zeros(24, 24);

    % Group data by date and hour, and calculate mean bike counts
    grouped_data = varfun(@mean, season_data, 'GroupingVariables', {'Date', 'Hour'}, 'InputVariables', 'RentedBikeCount');

    %% Itirate over all the pairs of hours
    for hour1 = 0:23
        for hour2 = 0:23
            if hour1 ~= hour2
                % Extract bike counts for each hour
                bikes_hour1 = grouped_data.mean_RentedBikeCount(grouped_data.Hour == hour1);

                bikes_hour2 = grouped_data.mean_RentedBikeCount(grouped_data.Hour == hour2);

                % Ensure arrays are same size
                min_length = min(length(bikes_hour1), length(bikes_hour2));
                bikes_hour1 = bikes_hour1(1:min_length);
                bikes_hour2 = bikes_hour2(1:min_length);

                % Calculate the difference in bike rentals between the two hours
                differences = bikes_hour1 - bikes_hour2;

                % Do a statistical test for Mean Difference
                [h, p, ci, stats] = ttest(differences);

                % Store the results
                mean_diff_matrix(hour1 + 1, hour2 + 1) = mean(differences);

                p_value_matrix(hour1 + 1, hour2 + 1) = p;

            end
        end
    end

    %% Plot the results
    figure()
    imagesc(mean_diff_matrix);
    colorbar;
    title('Mean difference in bike rentals between hours in ', season_names{s});
    xlabel('Hour 1 (0-23)');
    ylabel('Hour 2 (0-23)');

    % %% Plot the results
    % imagesc(p_value_matrix);
    % colorbar;
    % title('p-value of the statistical test for mean difference in bike rentals between hours in Summer' , season_names{s});
    % xlabel('Hour 1');
    % ylabel('Hour 2');

end

%{
    Results :
    - The Summer season has the highest mean difference in bike rentals between hours.
    - The other seasons have similar patterns.
%}



