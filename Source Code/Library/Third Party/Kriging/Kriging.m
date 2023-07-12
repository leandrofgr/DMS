function [m, v] = Kriging(pos_known, val_known, s, range)

    [X, Y] = meshgrid([1:s(1)], [1:s(2)]);
    pos_est = [X(:), Y(:)];

    V = ['1 Sph(',num2str(range),')'];
    %V = ['1 Gau(',num2str(range),')'];
    options.mean = 0;
    options.ktype = 2;
    [d_est_ok,d_var_ok]=krig(pos_known,val_known,pos_est,V, options);

    m = reshape(d_est_ok, s(1), s(2));
    v = reshape(d_var_ok, s(1), s(2));
    

end