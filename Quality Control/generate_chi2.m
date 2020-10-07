function [result] = generate_chi2(logs,logs_simulated, num_of_bins, p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
histogram_edges = zeros(size(logs,2), num_of_bins);
for i = 1:1:size(histogram_edges,1)
    mmin = min(logs(:,i));
    mmax = max(logs(:,i));
    delta = (mmax - mmin) / (num_of_bins-1);
    edges_0 = [mmin:delta:mmax];
    histogram_edges(i,:) = edges_0;
end



QS = zeros(size(logs,2), size(logs,2));

for i = 1:1:size(logs,2)
    for j = 1:1:size(logs,2);
       [Nexp, ~,~] = histcounts2(logs(:,i), logs(:,j),histogram_edges(i,:), histogram_edges(j,:) );
       Nexp = Nexp ./ sum(sum(Nexp));
       [Nsim, ~,~] = histcounts2(logs_simulated(:,i), logs_simulated(:,j),histogram_edges(i,:), histogram_edges(j,:) );
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

