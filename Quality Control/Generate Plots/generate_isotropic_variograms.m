function [] = generate_isotropic_variograms(fraction2optimize,reference,simulations_1,simulations_2)

figure
for var_i=1:size(simulations_1,1)
    for var_j=var_i:size(simulations_1,1)
        
        figure(10);subplot(size(simulations_1,1),size(simulations_1,1),var_i+size(simulations_1,1)*(var_j-1))
        
        simu_dms1 = squeeze(simulations_1(var_i,:,:));
        simu_dms2 = squeeze(simulations_1(var_j,:,:));
        [X,Y] = meshgrid(1:size(simu_dms1,1),1:size(simu_dms1,2));
        variogram_field_1 = cross_variogram([X(:) Y(:)], simu_dms1(:), simu_dms2(:),'subsample',round(fraction2optimize*length(simu_dms1(:))),'nrbins',30,'maxdist',50);
        
        simu_ref1 = squeeze(reference(var_i,:,:));
        simu_ref2 = squeeze(reference(var_j,:,:));
        variogram_field_ref = cross_variogram([X(:) Y(:)], simu_ref1(:), simu_ref2(:),'subsample',round(fraction2optimize*length(simu_dms1(:))),'nrbins',30,'maxdist',50);
        
        %cov_aux = cov([reference(:,var_i) reference(:,var_j)]);
        %cov_aux = cov_aux(1,2);
        %plot(variogram_field_1.distance, cov_aux*ones(size(variogram_field_1.distance)),'k')        

        plot(variogram_field_1.distance, variogram_field_1.val,'k')
        hold all
        plot(variogram_field_ref.distance, variogram_field_ref.val,'b')        
        title('z^'+string(var_i)+',z^'+string(var_j))
        grid
        drawnow
        if nargin>3
            simu_ppmt1 = squeeze(simulations_2(var_i,:,:));
            simu_ppmt2 = squeeze(simulations_2(var_i,:,:));
            variogram_field_2 = cross_variogram([X(:) Y(:)], simu_ppmt1(:), simu_ppmt2(:),'subsample',round(fraction2optimize*length(simu_dms1(:))),'nrbins',30);
            plot(variogram_field_2.distance, variogram_field_2.val,'r')
        end
    end
end