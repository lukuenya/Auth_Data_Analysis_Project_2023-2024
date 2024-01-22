

%% Task 7 : Find the best regression model for the data

%% Dataset : Seoul Bike demand (SeoulBike.xlsx)

% Load the data
data = readtable('SeoulBike.xlsx');

% Get the data for the season and hour
selected_season = 1;
hours = 0:23;
season_data = data(data.Seasons == selected_season, :);

% Iterate over the hours
for h = 0:23
    % Get the data for the hour
    hour_data = season_data(season_data.Hour == h, :);
    
    % Get the data for the model
    x = hour_data.Temperature__C_;
    y = hour_data.RentedBikeCount;
    
    % Get the best model
    [model, r2] = get_best_model(x, y);
    
    % Print the results
    fprintf('Hour %d\n', h);
    fprintf('Model: %s\n', model);
    fprintf('R2: %f\n', r2);
    fprintf('\n');
end

function [bestModel, r2] = get_best_model(x, y)
    % Fit a linear model
    linearModel = fitlm(x, y);
    
    % Fit a non-linear model (e.g., a quadratic model)
    nonLinearModel = fitnlm(x, y, @(b,x)(b(1) + b(2)*x + b(3)*x.^2), [0 0 0]);
    
    % Compute the R-squared values for each model
    r2_linear = linearModel.Rsquared.Adjusted;
    r2_nonLinear = nonLinearModel.Rsquared.Adjusted;
    
    % Determine which model is better
    if r2_linear > r2_nonLinear
        bestModel = 'Linear';
        r2 = r2_linear;
    else
        bestModel = 'Non-linear';
        r2 = r2_nonLinear;
    end
end

%{
    Results:
        Hour 0
        Model: Linear
        R2: 0.309179

        Hour 1
        Model: Linear
        R2: 0.244738

        Hour 2
        Model: Linear
        R2: 0.217385

        Hour 3
        Model: Linear
        R2: 0.260511

        Hour 4
        Model: Linear
        R2: 0.289676

        Hour 5
        Model: Non-linear
        R2: 0.060352

        Hour 6
        Model: Linear
        R2: 0.005843

        Hour 7
        Model: Linear
        R2: 0.002421

        Hour 8
        Model: Linear
        R2: -0.004567

        Hour 9
        Model: Linear
        R2: 0.048054

        Hour 10
        Model: Linear
        R2: 0.205041

        Hour 11
        Model: Linear
        R2: 0.254818

        Hour 12
        Model: Linear
        R2: 0.346017

        Hour 13
        Model: Linear
        R2: 0.326911

        Hour 14
        Model: Non-linear
        R2: 0.403897

        Hour 15
        Model: Non-linear
        R2: 0.406616

        Hour 16
        Model: Non-linear
        R2: 0.404730

        Hour 17
        Model: Non-linear
        R2: 0.280657

        Hour 18
        Model: Linear
        R2: 0.052548

        Hour 19
        Model: Linear
        R2: 0.084675

        Hour 20
        Model: Linear
        R2: 0.161017

        Hour 21
        Model: Linear
        R2: 0.168792

        Hour 22
        Model: Linear
        R2: 0.203854

        Hour 23
        Model: Linear
        R2: 0.282134

    Comment:
        The season selected is Winter (1).
        Generally, there is a non-linear dependence of bicycle rental on temperature between 14h and 17h.
%}





