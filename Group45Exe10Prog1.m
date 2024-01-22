

%% Task 10

% Load the data
data = readtable('SeoulBike.xlsx');

% Select a season and remove holiday data
selected_season = 3; % Summer
data = data(data.Seasons == selected_season & data.Holiday == 0, :);

% Define the maximum lag p
max_lag = 3; % 3 hours

% Initialize results table
results = table('Size', [24 2], 'VariableTypes', {'double', 'double'}, 'VariableNames', {'Model1_Rsq', 'Model2_Rsq'});

% Iterate over each hour
for h = 0:23
    % Prepare data with lagged indicators
    laggedData = prepareLaggedData(data, max_lag, h);

    % Define response and predictors
    response = laggedData.RentedBikeCount;
    predictors = laggedData(:, 4:end); 

    % Model 1: Linear model with dimension reduction (PCA)
    [model1, ~] = fitLinearModel(predictors, response, 'PCA');

    % Model 2: Another linear model with different dimension reduction
    [model2, ~] = fitLinearModel(predictors, response, 'OtherMethod');

    % Store results
    results.Model1_Rsq(h+1) = model1.Rsquared.Adjusted;
    results.Model2_Rsq(h+1) = model2.Rsquared.Adjusted;
end

% Visualization of results
figure;
plot(0:23, results.Model1_Rsq, 'b-o', 'DisplayName', 'Model 1');
hold on;
plot(0:23, results.Model2_Rsq, 'r-s', 'DisplayName', 'Model 2');
xlabel('Hour of the Day');
ylabel('Adjusted R-squared');
title('Comparison of Model Performance Across Hours');
legend('Location', 'best');
grid on;
hold off;


% Functions to prepare lagged data and fit linear models
function laggedData = prepareLaggedData(data, max_lag, hour)
    % Filter data for the specific hour
    hourData = data(data.Hour == hour, :);

    % Initialize laggedData with original data
    laggedData = hourData;

    % Number of columns to lag (excluding non-predictor columns)
    numPredictorCols = width(hourData) - 3; % Adjust this based on your data

    % Add lagged columns for each meteorological indicator
    for lag = 1:max_lag
        % Shift data matrix down by 'lag' rows
        laggedValues = [nan(lag, numPredictorCols); hourData{1:end-lag, 4:end}];

        % Create new variable names for lagged columns
        laggedVarNames = strcat(hourData.Properties.VariableNames(4:end), '_lag', string(lag));

        % Add lagged columns to laggedData
        laggedData = [laggedData, array2table(laggedValues, 'VariableNames', laggedVarNames)];
    end

    % Remove rows with NaN (due to lagging)
    laggedData = rmmissing(laggedData);
end




function [model, predictors] = fitLinearModel(predictors, response, method)
    % Convert predictors to a numeric matrix 
    if istable(predictors)
        predictors = table2array(predictors);
    end

    % Apply dimension reduction technique
    if strcmp(method, 'PCA')
        [~, score, ~, ~, explained] = pca(predictors);
        % Use components explaining a certain percentage of variance
        cumExplained = cumsum(explained);
        numComponents = find(cumExplained >= 95, 1); % 95% variance explained
        predictors = score(:, 1:numComponents);
    %elseif strcmp(method, 'FactorAnalysis')
    end

    % Fit linear model
    model = fitlm(predictors, response);
end

%{
    - Model2 is better than Model1 because it has a higher adjusted R-squared
    value for all hours of the day.
    - At the lag 11 - 17 hours where we have a better fit, indicates the optimal time frame of past weather data for predicting the number of rented bikes.
    

%}