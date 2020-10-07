close all
load('HardData_ReferenceModel_size100_range60.mat')

logs = reference_models(:,:)';
generate_biplots(logs);
num_of_bins = 50;

load('logs_simulated_all.mat');
lsa = [];
for i = 1:1:size(logs_simulated_all)
lsa = [lsa; logs_simulated_all{i}(:,:)'];
end
logs_simulated = lsa;
generate_biplots(logs_simulated);

chi2_dms = generate_chi2(logs,logs_simulated, num_of_bins,0)

load('logs_simulated_all_ppmt.mat');
lsa = [];
for i = 1:1:size(logs_simulated_all)
lsa = [lsa; logs_simulated_all{i}(:,:)'];
end
logs_simulated = lsa;
generate_biplots(logs_simulated);
chi2_ppmt = generate_chi2(logs,logs_simulated, num_of_bins,0)

chi2_ppmt - chi2_dms;