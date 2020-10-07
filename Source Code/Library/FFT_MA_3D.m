function [ simulation ] = FFT_MA_3D( correlation_function, noise )

	X = correlation_function;
	Y = noise;
    
    S = size(noise);
    S = log2(S);
    S = round(S+0.5);
    S = 2.^S;
    
    c2 = ifftn(sqrt(abs(fftn(X, S ))) .* fftn(Y,S),S);

    simulation = real(c2);
    simulation = simulation(1:size(noise,1), 1:size(noise,2));

end