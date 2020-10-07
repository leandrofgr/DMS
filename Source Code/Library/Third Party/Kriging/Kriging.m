function [m, v] = Kriging(pos_known, val_known, s, range)
    out_size_x = s(1);
    out_size_y = s(2);
    pos_est = zeros(out_size_x * out_size_y,2);
    for i = 1:1:out_size_x
        for j = 1:1:out_size_y
            pos_est((i-1)*out_size_y+j,:) = [i,j];
        end
    end

    V = ['1 Sph(',num2str(range),')'];
    %V = ['1 Gau(',num2str(range),')'];
    options.mean = 0;
    options.ktype = 2;
    [d_est_ok,d_var_ok]=krig(pos_known,val_known,pos_est,V, options);

    
    v = zeros(out_size_x, out_size_y);
    m = zeros(out_size_x, out_size_y);
    for i = 1:1:size(pos_est,1)
        x = pos_est(i,1);
        y = pos_est(i,2);
        var_k = d_var_ok(i);
        mean_k = d_est_ok(i);
        m(x,y) = mean_k;
        v(x,y) = var_k;
    end
    
end