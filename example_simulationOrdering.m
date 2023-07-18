n_variables = 2;


addpath(genpath('SeReM'))

%load('datasets/HardData_ReferenceModel_size200_range40.mat');
load('datasets/HardData_ReferenceModel_size100_range20.mat');
%load('datasets/HardData_ReferenceModel_size40_range20.mat');
load('datasets/reference_data.mat')

reference_models = reference_models(1:n_variables,:,:);

I = size(reference_models,2);
J = size(reference_models,3);


n_cond_points = 20;
cond_pos_ = cond_pos(1:n_cond_points ,1:n_variables);

grid_size = 0.05;
range = 18;
n_simulations = 1;
type = 'sph';

%[reference_variables] = extend_dateset_KDE(reference_variables,2,0.05);

n_simulations = 100;
for simulation = 1:n_simulations   
    %% ORDER 1, 2
    % condicional DMS
    reference_variables = [reshape(reference_models(1,:,:),I*J,1) reshape(reference_models(2,:,:),I*J,1)] ;
    reference_variables = [z1_analytic z2_analytic];
    
    cond_value_ = cond_value(1:n_cond_points ,1:n_variables);
    
    [simulations_all_dms_order_12] = DMS(I,J, range, type, grid_size, reference_variables, cond_pos_, cond_value_, 1);
    
    simulation_dms_order_12 = simulations_all_dms_order_12{1};
    
    %generate_2D(reference_models,cond_pos_)
    %generate_2D(simulation_dms_order_12,cond_pos_)
    
    
    %% ORDER 2, 1
    reference_variables = [reshape(reference_models(2,:,:),I*J,1) reshape(reference_models(1,:,:),I*J,1)] ;
    reference_variables = [z2_analytic z1_analytic];
    
    n_cond_points = 20;
    cond_value_ = cond_value(1:n_cond_points ,n_variables:-1:1);
    
    [simulations_all_dms_order_21] = DMS(I,J, range, type, grid_size, reference_variables, cond_pos_, cond_value_, 1);
    
    simulation_dms_order_21 = simulations_all_dms_order_21{1};
    
    %generate_2D(reference_models,cond_pos_)
    %generate_2D(simulation_dms_order_21,cond_pos_)
    
    
    
    %% variograms
    fraction2optimize = 1;
    
    figure(10)
    for var_i=1:size(reference_models,1)
        
        subplot(1,size(reference_models,1),var_i)
        
        if simulation == 1
            simu_dms1 = squeeze(reference_models(var_i,:,:));
            simu_dms2 = squeeze(reference_models(var_i,:,:));
            [X,Y] = meshgrid(1:size(simu_dms1,1),1:size(simu_dms1,2));
            variogram_field_1 = cross_variogram([X(:) Y(:)], simu_dms1(:), simu_dms2(:),'subsample',round(fraction2optimize*length(simu_dms1(:))),'nrbins',30,'maxdist',30);
            
            plot(variogram_field_1.distance, variogram_field_1.val,'k')
            hold all
            title('z^'+string(var_i)+',z^'+string(var_i))
            xlabel('h')
        end
        
        simu_ref1 = squeeze(simulation_dms_order_12(var_i,:,:));
        simu_ref2 = squeeze(simulation_dms_order_12(var_i,:,:));
        variogram_field_ref = cross_variogram([X(:) Y(:)], simu_ref1(:), simu_ref2(:),'subsample',round(fraction2optimize*length(simu_dms1(:))),'nrbins',30,'maxdist',30);
        plot(variogram_field_ref.distance, variogram_field_ref.val,'b')
        
        if var_i == 1
            aux = 2
        end
        if var_i == 2
            aux = 1
        end
        subplot(1,size(reference_models,1),aux)
        
        simu_1 = squeeze(simulation_dms_order_21(var_i,:,:));
        simu_2 = squeeze(simulation_dms_order_21(var_i,:,:));
        variogram_field_2 = cross_variogram([X(:) Y(:)], simu_1(:), simu_2(:),'subsample',round(fraction2optimize*length(simu_dms1(:))),'nrbins',30,'maxdist',30);
        plot(variogram_field_2.distance, variogram_field_2.val,'r')
        hold all
        drawnow
        title(simulation)
    end
end

subplot(1,2,1)
grid
legend('Order: z^1, z^2','Order: z^2, z^1')
subplot(1,2,2)
grid





