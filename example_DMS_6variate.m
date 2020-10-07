%load('datasets/HardData_ReferenceModel_size200_range40.mat');
%load('datasets/HardData_ReferenceModel_size100_range20.mat');
load('datasets/HardData_ReferenceModel_size40_range20.mat');

I = size(reference_models,2);
J = size(reference_models,3);
reference_variables = [reshape(reference_models(1,:,:),I*J,1) reshape(reference_models(2,:,:),I*J,1) reshape(reference_models(3,:,:),I*J,1) reshape(reference_models(4,:,:),I*J,1) reshape(reference_models(5,:,:),I*J,1) reshape(reference_models(6,:,:),I*J,1) ] ;

[reference_variables] = extend_dateset_KDE(reference_variables,10,0.05);

grid_size = 0.05; 
range = 20;
n_simulations = 1;

n_cond_points = 10;
cond_value_ = cond_value(1:n_cond_points ,:);
cond_pos_ = cond_pos(1:n_cond_points ,:);

% Conditioned simulation
[simulations_all_dms] = DMS(I,J, range, grid_size, reference_variables, cond_pos_, cond_value, n_simulations);
% Unconditioned simulation
%[simulations_all_dms] = DMS(I,J, range, grid_size, reference_variables, [], [], n_simulations);

simulation_dms = simulations_all_dms{1};

generate_2D(reference_models,cond_pos_)
generate_2D(simulation_dms,cond_pos_)

generate_histograms(reshape(reference_models,6,I*J)')
generate_histograms(reshape(simulation_dms,6,I*J)')

%generate_isotropic_variograms(0.5,reference_models,simulation)

load('datasets/reference_data.mat')
reference = [z1_analytic z2_analytic, z3_analytic, z4_analytic, z5_analytic, z6_analytic];
num_of_bins = 50;
aux_dms = reshape(simulation_dms,6,I*J)';
%aux_dms = [ simulation(:,1) simulation(:,2) simulation(:,3) simulation(:,4) simulation(:,5) simulation(:,6)];
chi2_dms = generate_chi2(reference,aux_dms, num_of_bins,0)


    



