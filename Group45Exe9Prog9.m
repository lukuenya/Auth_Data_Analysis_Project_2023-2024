

%% Task 9


% Load the data
data = readtable('SeoulBike.xlsx');

% Filter data for a specific non-holiday season
selected_season = 1; % Winter
data = data(data.Seasons == selected_season & data.Holiday == 0, :);

% predictors and response
predictors = data(:, {'Temperature__C_', 'Humidity___', 'DewPointTemperature__C_', 'Rainfall_mm_', 'Snowfall_cm_'});

response = data.('RentedBikeCount');

% Extract the numeric predictors and response
numericData = data(:, {'Temperature__C_', 'Humidity___', 'WindSpeed_m_s_', 'Visibility_10m_', 'DewPointTemperature__C_', 'Rainfall_mm_', 'Snowfall_cm_', 'RentedBikeCount'});


% Define training and test sets
last20days = max(data.Date) - 20; % Calculate the date 20 days before the last date in the dataset
trainData = data(data.Date < last20days, :);
testData = data(data.Date >= last20days, :);

% Model 1a: Full multiple regression - specific hour
hour = 14; %  2 PM
model1a = fitlm(trainData(trainData.Hour == hour, :), 'ResponseVar', 'RentedBikeCount');

% Model 2a: Full multiple regression - all hours
model2a = fitlm(trainData, 'ResponseVar', 'RentedBikeCount');

% Model 1b: Stepwise regression - specific hour
model1b = stepwiselm(trainData(trainData.Hour == hour, :), 'ResponseVar', 'RentedBikeCount');

% Model 2b: Stepwise regression - all hours
model2b = stepwiselm(trainData, 'ResponseVar', 'RentedBikeCount');

% Predictions for the last 20 days using all models
preds1a = predict(model1a, testData(testData.Hour == hour, :));
preds2a = predict(model2a, testData);
preds1b = predict(model1b, testData(testData.Hour == hour, :));
preds2b = predict(model2b, testData);

% Evaluation of the predictions
% Actual values
actual1 = testData.RentedBikeCount(testData.Hour == hour);
actual2 = testData.RentedBikeCount;

% Evaluation metrics (Mean Squared Error)
mse1a = mean((preds1a - actual1).^2);
mse2a = mean((preds2a - actual2).^2);
mse1b = mean((preds1b - actual1).^2);
mse2b = mean((preds2b - actual2).^2);

% Visualization and comparison of models
figure;
plot(actual1, 'b');
hold on;
plot(preds1a, 'r');
title('Actual vs Predicted Bike Rentals - Model 1a');
legend('Actual', 'Predicted');
xlabel('Day');
ylabel('Rented Bike Count');
hold off;


figure;
plot(actual2, 'b');
hold on;
plot(preds2a, 'r');
title('Actual vs Predicted Bike Rentals - Model 2a');
legend('Actual', 'Predicted');
xlabel('Day');
ylabel('Rented Bike Count');
hold off;

figure;
plot(actual1, 'b');
hold on;
plot(preds1b, 'r');
title('Actual vs Predicted Bike Rentals - Model 1b');
legend('Actual', 'Predicted');
xlabel('Day');
ylabel('Rented Bike Count');
hold off;

figure;
plot(actual2, 'b');
hold on;
plot(preds2b, 'r');
title('Actual vs Predicted Bike Rentals - Model 2b');
legend('Actual', 'Predicted');
xlabel('Day');
ylabel('Rented Bike Count');
hold off;

% Comparison of models
figure;
plot(actual1, 'b');
hold on;
plot(preds1a, 'r');
plot(preds1b, 'g');
title('Actual vs Predicted Bike Rentals - Model 1a vs Model 1b');
legend('Actual', 'Predicted - Model 1a', 'Predicted - Model 1b');
xlabel('Day');
ylabel('Rented Bike Count');
hold off;

% Repeat for other models
figure;
plot(actual2, 'b');
hold on;
plot(preds2a, 'r');
plot(preds2b, 'g');
title('Actual vs Predicted Bike Rentals - Model 2a vs Model 2b');
legend('Actual', 'Predicted - Model 2a', 'Predicted - Model 2b');
xlabel('Day');
ylabel('Rented Bike Count');
hold off;


