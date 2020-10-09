
load('datasets/HardData_ReferenceModel_size100_range20.mat');
%load('datasets/HardData_ReferenceModel_size40_range20.mat');
I = size(reference_models,2);
J = size(reference_models,3);

reference_variables = [reshape(reference_models(1,:,:),I*J,1) reshape(reference_models(2,:,:),I*J,1) reshape(reference_models(3,:,:),I*J,1) reshape(reference_models(4,:,:),I*J,1) reshape(reference_models(5,:,:),I*J,1) reshape(reference_models(6,:,:),I*J,1) ] ;

grid_size = 0.05; 

[ cond_value_uniform ] = nonParametric_to_uniform( cond_value, reference_variables, grid_size);
cond_value_gaussian = norminv(cond_value_uniform);

%% EXPERIMENTAL VARIOGRAMS AND VARIABLE FIT IN GAUSSIAN TRANSFORMED VARIABLES
range = 0;
figure
for var_i=1:size(cond_value_gaussian,2)
        
        subplot(2,size(cond_value_gaussian,2)/2,var_i)
        variogram_field = cross_variogram(cond_pos, cond_value_gaussian(:,var_i), cond_value_gaussian(:,var_i),'nrbins',20,'maxdist',75);
        plot(variogram_field.distance, variogram_field.val,'--ok')                        
        if var_i==var_i
            [dum,dum,dum,vstruct_field] = variogramfit(variogram_field.distance,variogram_field.val,[],[],[],'model','spherical');
            range = range + vstruct_field.range;
        end 
        title('z^'+string(var_i))
        grid
           
end

range_mean = range/size(cond_value,2)


%% EXPERIMENTAL VARIOGRAM OF THE ORIGINAL VARIABLE
figure
for var_i=1:size(cond_value,2)
    for var_j=var_i:size(cond_value,2)
        
        subplot(size(cond_value,2),size(cond_value,2),var_i+size(cond_value,2)*(var_j-1))
        variogram_field = cross_variogram(cond_pos, cond_value(:,var_i), cond_value(:,var_j),'nrbins',20,'maxdist',75);
        plot(variogram_field.distance, variogram_field.val,'--ok')     
        xlim([0 40])
        
    end
end

