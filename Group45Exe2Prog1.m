

%% Task 2
%% Dataset : Seoul Bike Sharing Demand -> SeoulBike.xlsx

%{
    - Select two seasons for comparison
    - Sample the data to otain a random sample of 100 observations from each season.
    - Visual comparison: Plot histograms of the bike rental counts for each season to visually compare the distributions.
    - Statistical comparison: Perform a Chi-square test to compare the two distributions: the observed counts are the counts in the first histogram, and the expected counts are the counts in the second histogram.
    Repeat the process M=100 times and calculate the percentage of times the bikes rental distributions do not differ between the two seasons.
        Do this for all pairs of seasons (Spring and Summer, Spring and Autumn, Spring and Winter, Summer and Autumn, Summer and Winter, Autumn and Winter). 
    

%}

% Load the data
data = readtable('SeoulBike.xlsx');

% Define the number of repetitions
M = 100;
seasons = unique(data.Seasons);
num_seasons = length(seasons);
comparison_results = zeros(num_seasons);

% Define bin edges for histogram
min_count = min(data.RentedBikeCount);
max_count = max(data.RentedBikeCount);
num_bins = 100; % Adjust number of bins as needed

% Create bin edges that cover the entire range of your data
bin_edges = linspace(min_count, max_count, num_bins);

% Extend the bin edges to ensure coverage
bin_edges = [min_count - 1, bin_edges, max_count + 1];

for i = 1:num_seasons
    for j = 1:num_seasons
        if i ~= j
            count_diff = 0;
            for k = 1:M
                % Randomly sample 100 observations from each season
                sample_i = randsample(data.RentedBikeCount(data.Seasons == seasons(i)), 100);
                sample_j = randsample(data.RentedBikeCount(data.Seasons == seasons(j)), 100);

                % Calculate histogram frequencies for both samples with adjusted bin edges
                freq1 = histcounts(sample_i, bin_edges);
                freq2 = histcounts(sample_j, bin_edges);

                % Perform goodness-of-fit test (Chi-Squared or other)
                [h, p] = chi2gof(freq1, 'Expected', freq2);

                % Count how many times distributions do not differ
                if p > 0.05 % Adjust significance level as needed
                    count_diff = count_diff + 1;
                end
            end
            % Calculate the percentage of no difference
            comparison_results(i,j) = count_diff / M * 100;
        end
    end
end

% Display or store the results
disp(comparison_results);

%{
Results: Exemple with 100 repetitions and number of bins = 100 

     Winter Spring Summer Autumn
Winter  0      0      0      0
Spring  0      0      0      0
Summer  0     46      0      4
Autumn  0     44      2      0

    - The value 46 (Summer, Spring) and 44 (Autumn, Spring) indicates lack of significant difference between the two distributions in 46% and 44% of the cases respectively.

    - The other small percentages (4% and 2%) indicate some instances of similarity between Summer and Autumn and Autumn and Summer distributions respectively.

    - Most of the comparisons resulted in 0% indicating significant difference between those seasons pairs for most iterations
%}





