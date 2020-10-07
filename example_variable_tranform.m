

load('datasets/HardData_ReferenceModel_size200_range40.mat');
I = size(reference_models,2);
J = size(reference_models,3);
reference_variables = [reshape(reference_models(1,:,:),I*J,1) reshape(reference_models(2,:,:),I*J,1) reshape(reference_models(3,:,:),I*J,1) reshape(reference_models(4,:,:),I*J,1) reshape(reference_models(5,:,:),I*J,1) reshape(reference_models(6,:,:),I*J,1) ] ;

grid_size = 0.05; 
range = 15;

n_cond_points = 200;
cond_value_original = cond_value(1:n_cond_points ,:);
cond_pos_ = cond_pos(1:n_cond_points ,:);



[ variable_uniform ] = nonParametric_to_uniform( cond_value_original, reference_variables, grid_size);
variable_gaussian = norminv(variable_uniform);

variable_uniform_ = normcdf(variable_gaussian);
cond_value_original_ = uniform_to_nonParametric( variable_uniform_, reference_variables, grid_size);

figure
subplot(1,2,1)
plot(variable_uniform(:,1),variable_uniform(:,2),'.')
hold all
plot(variable_uniform_(:,1),variable_uniform_(:,2),'.')
title('Uniform')
grid
subplot(1,2,2)
plot(cond_value_original(:,1),cond_value_original(:,2),'.')
hold all
plot(cond_value_original_(:,1),cond_value_original_(:,2),'.')
title('Uniform')
grid

    



