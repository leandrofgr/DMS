pos_known=[50,50; 25, 25]; %
val_known=[100;0];  % 
[m, v] = Kriging(pos_known, val_known, [100,100]);
figure; 
imagesc(m);

figure; 
imagesc(v);
