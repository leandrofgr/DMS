function [] = generate_isotropic_variograms(fraction2optimize,simulations_1,simulations_2,simulations_3)

figure
for var_i=1:size(simulations_1,1)
    for var_j=var_i:size(simulations_1,1)
        
        figure(10);subplot(size(simulations_1,1),size(simulations_1,1),var_i+size(simulations_1,1)*(var_j-1))
        
        simu_dms1 = squeeze(simulations_1(var_i,:,:));
        simu_dms2 = squeeze(simulations_1(var_j,:,:));
        [X,Y] = meshgrid(1:size(simu_dms1,1),1:size(simu_dms1,2));
        variogram_field_1 = cross_variogram([X(:) Y(:)], simu_dms1(:), simu_dms2(:),'subsample',round(fraction2optimize*length(simu_dms1(:))),'nrbins',30,'maxdist',50);
        
        plot(variogram_field_1.distance, variogram_field_1.val,'k')
        hold all
        title('z^'+string(var_i)+',z^'+string(var_j))
        grid
        xlabel('h')
        
        if nargin>2
            simu_ref1 = squeeze(simulations_2(var_i,:,:));
            simu_ref2 = squeeze(simulations_2(var_j,:,:));
            variogram_field_ref = cross_variogram([X(:) Y(:)], simu_ref1(:), simu_ref2(:),'subsample',round(fraction2optimize*length(simu_dms1(:))),'nrbins',30,'maxdist',50);
            plot(variogram_field_ref.distance, variogram_field_ref.val,'b')
        end
        
        if nargin>3
            simu_ppmt1 = squeeze(simulations_3(var_i,:,:));
            simu_ppmt2 = squeeze(simulations_3(var_j,:,:));
            variogram_field_2 = cross_variogram([X(:) Y(:)], simu_ppmt1(:), simu_ppmt2(:),'subsample',round(fraction2optimize*length(simu_dms1(:))),'nrbins',30,'maxdist',50);
            plot(variogram_field_2.distance, variogram_field_2.val,'r')
        end
        
        drawnow
        xlim([0 50])
                
    end
end