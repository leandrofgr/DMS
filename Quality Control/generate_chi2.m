function [result] = generate_chi2(reference_Variables,simulated_variables, num_of_bins, p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
histogram_edges = zeros(size(reference_Variables,2), num_of_bins);
for i = 1:1:size(histogram_edges,1)
    mmin = min(reference_Variables(:,i));
    mmax = max(reference_Variables(:,i));
    delta = (mmax - mmin) / (num_of_bins-1);
    edges_0 = [mmin:delta:mmax];
    histogram_edges(i,:) = edges_0;
end



QS = zeros(size(reference_Variables,2), size(reference_Variables,2));

for i = 1:1:size(reference_Variables,2)
    for j = 1:1:size(reference_Variables,2);
       [Nexp, ~,~] = histcounts2(reference_Variables(:,i), reference_Variables(:,j),histogram_edges(i,:), histogram_edges(j,:) );
       Nexp = Nexp ./ sum(sum(Nexp));
       [Nsim, ~,~] = histcounts2(simulated_variables(:,i), simulated_variables(:,j),histogram_edges(i,:), histogram_edges(j,:) );
       Nsim = Nsim ./ sum(sum(Nsim));
       if p == 0
           A = (Nexp - Nsim) .^2;
       else
           A = (Nexp - Nsim) .^2 ./ Nexp .* 100;
           A(isnan(A)) = 0;
           A(isinf(A)) = 0;
       end
       QS(i,j) = sum(sum(A(~isnan(A)))) ./ size(A,1) .* size(A,2);
    end
end

result = QS;
end

