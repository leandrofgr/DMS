
%load('datasets/HardData_ReferenceModel_size200_range40.mat');
load('datasets/HardData_ReferenceModel_size100_range20.mat');
%load('datasets/HardData_ReferenceModel_size40_range20.mat');
%I = size(reference_models,2);
%J = size(reference_models,3);
%reference_variables = [reshape(reference_models(1,:,:),I*J,1) reshape(reference_models(2,:,:),I*J,1) reshape(reference_models(3,:,:),I*J,1) reshape(reference_models(4,:,:),I*J,1) reshape(reference_models(5,:,:),I*J,1) reshape(reference_models(6,:,:),I*J,1) ] ;


load('datasets/reference_data.mat')
reference_variables = [z1_analytic z2_analytic, z3_analytic, z4_analytic, z5_analytic, z6_analytic];
I = 200;
J = 200;

% DKE: OPTIONAL
%[reference_variables] = extend_dateset_KDE(reference_variables,2,0.05);

grid_size = 0.05; 
range = 40;
n_simulations = 1;


% Uncondicional DMS
[simulations_all_dms] = DMS(I,J, range, grid_size, reference_variables, [], [], n_simulations);


simulation_dms = simulations_all_dms{1};

generate_2D(simulation_dms)
set_caxis_6variate

generate_histograms(reference_variables)
generate_histograms(reshape(simulation_dms,6,I*J)')

generate_isotropic_variograms(0.5,simulation_dms)


num_of_bins = 50;
aux_dms = reshape(simulation_dms,6,I*J)';
%aux_dms = [ simulation(:,1) simulation(:,2) simulation(:,3) simulation(:,4) simulation(:,5) simulation(:,6)];
chi2_dms = generate_chi2(reference_variables,aux_dms, num_of_bins,0)


    



