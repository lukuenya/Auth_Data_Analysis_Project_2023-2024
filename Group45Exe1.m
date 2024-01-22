% Matthieu Ndumbi Lukuenya, 9217 

%% Dataset : Seoul Bike Sharing Demand 'https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand' : SeoulBike.xlsx

%% Task 1
%{
    - Data Preprocessing : We will separate the data into 'Seasons' columns. 
        Winter -> 1, Spring -> 2, Summer -> 3, Autumn -> 4
    - Fit Distribution : For each season , we will fit different probability to the data. Common distributions to try :
        - Normal Distribution
        - Exponential Distribution
        - Poisson Distribution
    - Evaluate the fit : We will usenthe Chi-Squared test to evaluate the fit of the distribution to the data.
    - Compare across seasons : We observe if the optimal distribution differs across seasons.
    
%}

% Load the data
data = readtable('SeoulBike.xlsx');

% Separate the data into seasons
winter = data(data.Seasons == 1,:);
spring = data(data.Seasons == 2,:);
summer = data(data.Seasons == 3,:);
autumn = data(data.Seasons == 4,:);

% Fit the distribution for the whole dataset
data_normal = fitdist(data.RentedBikeCount, 'Normal');
data_exp = fitdist(data.RentedBikeCount, 'Exponential');
data_poisson = fitdist(data.RentedBikeCount, 'Poisson');


% Fit the distributions : Normal
winter_normal = fitdist(winter.RentedBikeCount,'Normal');
spring_normal = fitdist(spring.RentedBikeCount,'Normal');
summer_normal = fitdist(summer.RentedBikeCount,'Normal');
autumn_normal = fitdist(autumn.RentedBikeCount,'Normal');

% Fit the distributions : Exponential
winter_exp = fitdist(winter.RentedBikeCount,'Exponential');
spring_exp = fitdist(spring.RentedBikeCount,'Exponential');
summer_exp = fitdist(summer.RentedBikeCount,'Exponential');
autumn_exp = fitdist(autumn.RentedBikeCount,'Exponential');

% Fit the distributions : Poisson
winter_poisson = fitdist(winter.RentedBikeCount,'Poisson');
spring_poisson = fitdist(spring.RentedBikeCount,'Poisson');
summer_poisson = fitdist(summer.RentedBikeCount,'Poisson');
autumn_poisson = fitdist(autumn.RentedBikeCount,'Poisson');

% Evaluate the fit : Chi-Squared test -> Whole dataset
[h_normal, p_normal] = chi2gof(data.RentedBikeCount, 'CDF', data_normal);
disp(['Normal distribution for entire data - p-value: ', num2str(p_normal), ', Test Statistic: ', num2str(h_normal)]);

[h_exp, p_exp] = chi2gof(data.RentedBikeCount, 'CDF', data_exp);
disp(['Exponential distribution for entire data - p-value: ', num2str(p_exp), ', Test Statistic: ', num2str(h_exp)]);

[h_poisson, p_poisson] = chi2gof(data.RentedBikeCount, 'CDF', data_poisson);
disp(['Poisson distribution for entire data - p-value: ', num2str(p_poisson), ', Test Statistic: ', num2str(h_poisson)]);

% Evaluate the fit : Chi-Squared test -> Seasons
[h_winter_normal, p_winter_normal] = chi2gof(winter.RentedBikeCount, 'CDF', winter_normal);
disp(['Normal distribution for winter - p-value: ', num2str(p_winter_normal), ', Test Statistic: ', num2str(h_winter_normal)]);

[h_spring_normal, p_spring_normal] = chi2gof(spring.RentedBikeCount, 'CDF', spring_normal);
disp(['Normal distribution for spring - p-value: ', num2str(p_spring_normal), ', Test Statistic: ', num2str(h_spring_normal)]);

[h_summer_normal, p_summer_normal] = chi2gof(summer.RentedBikeCount, 'CDF', summer_normal);
disp(['Normal distribution for summer - p-value: ', num2str(p_summer_normal), ', Test Statistic: ', num2str(h_summer_normal)]);

[h_autumn_normal, p_autumn_normal] = chi2gof(autumn.RentedBikeCount, 'CDF', autumn_normal);
disp(['Normal distribution for autumn - p-value: ', num2str(p_autumn_normal), ', Test Statistic: ', num2str(h_autumn_normal)]);

%------------------------------------------------------------------

[h_winter_exp, p_winter_exp] = chi2gof(winter.RentedBikeCount, 'CDF', winter_exp);
disp(['Exponential distribution for winter - p-value: ', num2str(p_winter_exp), ', Test Statistic: ', num2str(h_winter_exp)]);

[h_spring_exp, p_spring_exp] = chi2gof(spring.RentedBikeCount, 'CDF', spring_exp);
disp(['Exponential distribution for spring - p-value: ', num2str(p_spring_exp), ', Test Statistic: ', num2str(h_spring_exp)]);

[h_summer_exp, p_summer_exp] = chi2gof(summer.RentedBikeCount, 'CDF', summer_exp);
disp(['Exponential distribution for summer - p-value: ', num2str(p_summer_exp), ', Test Statistic: ', num2str(h_summer_exp)]);

[h_autumn_exp, p_autumn_exp] = chi2gof(autumn.RentedBikeCount, 'CDF', autumn_exp);
disp(['Exponential distribution for autumn - p-value: ', num2str(p_autumn_exp), ', Test Statistic: ', num2str(h_autumn_exp)]);

%------------------------------------------------------------------

[h_winter_poisson, p_winter_poisson] = chi2gof(winter.RentedBikeCount, 'CDF', winter_poisson);
disp(['Poisson distribution for winter - p-value: ', num2str(p_winter_poisson), ', Test Statistic: ', num2str(h_winter_poisson)]);

[h_spring_poisson, p_spring_poisson] = chi2gof(spring.RentedBikeCount, 'CDF', spring_poisson);
disp(['Poisson distribution for spring - p-value: ', num2str(p_spring_poisson), ', Test Statistic: ', num2str(h_spring_poisson)]);

[h_summer_poisson, p_summer_poisson] = chi2gof(summer.RentedBikeCount, 'CDF', summer_poisson);
disp(['Poisson distribution for summer - p-value: ', num2str(p_summer_poisson), ', Test Statistic: ', num2str(h_summer_poisson)]);


% Compare across seasons
%{
    - We observe that None of the distributions fit the data well.
    - The p-values are all less than 0.05, which means that we reject the null hypothesis that the data follows the distribution.
    - This suggest that the distribution of the data is complex, however it seems to follow a bimodal distribution (Not sure about this and fitdist does not have a bimodal distribution)

%}









