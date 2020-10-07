%% %%%%% CLEAN WORKSPACE AND PREVIOUS SIMULATION FILES %%%%%
close all;
clc;clear;
if exist('Source Code/Library/Third Party/ppmt_le/par/','dir');rmdir('Source Code/Library/Third Party/ppmt_le/par/','s');mkdir('Source Code/Library/Third Party/ppmt_le/par/');else mkdir('Source Code/Library/Third Party/ppmt_le/par/');end 
if exist('Source Code/Library/Third Party/ppmt_le/data/','dir');rmdir('Source Code/Library/Third Party/ppmt_le/data/','s');mkdir('Source Code/Library/Third Party/ppmt_le/data/');else mkdir('Source Code/Library/Third Party/ppmt_le/data/');end 
if exist('sgsim.dbg');delete('sgsim.dbg');end

load('datasets/HardData_ReferenceModel_size100_range20.mat');

%% EXECUTION OF PROJECTION PERSUIT MULTIVARIATE TRANSFORMATION (PPMT)
% Connectionism and Cognitive Science Lab  
%
%% DATA PREPARATION FOR PPMT
load('reference_data.mat');
reference_logs = [z1_analytic, z2_analytic, z3_analytic, z4_analytic, z5_analytic, z6_analytic];

dx_sim = 50;
dy_sim = 50;
simulation_ranges = [20 20];

dx_ref = 200;
dy_ref = 200;

n_vars = 6; %number of variables to simulate
index_variables_to_sim = 1:n_vars;
K = 10000; %make reference data positive
analytic_ref_logs = [z1_analytic, z2_analytic, z3_analytic, z4_analytic, z5_analytic, z6_analytic];
variable_names = {'z1','z2','z3','z4','z5','z6'};
variable_names = variable_names(index_variables_to_sim);

%CREATE GRID FOR REFERENCE DATA
y = repmat(1:dy_ref,[dx_ref 1]);x = repmat(1:dx_ref,[dy_ref 1])';z = ones(dx_ref,dy_ref);
grid_v = [reshape(x,[dy_ref*dx_ref 1]) reshape(y,[dy_ref*dx_ref 1]) reshape(z,[dy_ref*dx_ref 1])];

[cond_pos,ind_cond_unique] = unique(cond_pos,'rows');
condtioning_indexes = zeros(size(grid_v,1),1);
for cp_id = 1:size(cond_pos,1)
    ind = logical(ismember(grid_v(:,1),cond_pos(cp_id,1)))&...
        logical(ismember(grid_v(:,2),cond_pos(cp_id,2)));
    analytic_ref_logs(ind,:) = cond_value(cp_id,:);
    
    condtioning_indexes = condtioning_indexes + double(ind);
end

analytic_ref_logs = analytic_ref_logs(:,index_variables_to_sim)+K;

%SAVE DATA
save_table_dat('Reference Values',['X','Y','Z',variable_names(1:end)],'Source Code/Library/Third Party/ppmt_le/data/data.dat', [grid_v analytic_ref_logs] );

%% %%%%% EXECUTE PPMT FORWARD %%%%%
ppmt_param.n_vars = n_vars;
ppmt_param.columns = 4:(n_vars+3);
ppmt_param.ppmt_par_file = 'Source Code/Library/Third Party/ppmt_le/par/ppmt_par_file.par';
ppmt_param.ref_file = 'Source Code/Library/Third Party/ppmt_le/data/data.dat';
ppmt_param.nscored_f = 'Source Code/Library/Third Party/ppmt_le/data/nscored_vars.dat';
ppmt_param.ppmt_out = 'Source Code/Library/Third Party/ppmt_le/data/ppmt.dat';
ppmt_param.ppmt_table_file = 'Source Code/Library/Third Party/ppmt_le/par/ppmt_table.trn';
generate_ppmt_par(ppmt_param);
tic
system(['"Source Code/Library/Third Party/ppmt_le/exe/ppmt.exe" "',ppmt_param.ppmt_par_file,'"']);
forward_transformation_time = toc;

%Prepare Conditioning Points table
ppmt_out_original = read_eas('Source Code/Library/Third Party/ppmt_le/data/ppmt.dat');

ppmt_logs = ppmt_out_original(logical(condtioning_indexes),[1 2 3 end-n_vars+1:end]);
save_table_dat('Conditioning_Points',['X','Y', 'Z',variable_names],'Source Code/Library/Third Party/ppmt_le/data/ppmt.dat', ppmt_logs);
%%%
%% %%%%% EXECUTE SEQUENTIAL GAUSSIAN SIMULATION %%%%%
ppmt_out = read_eas(ppmt_param.ppmt_out);
ppmt_out = ppmt_out(:,end-n_vars+1:end);
for sim_id = 1:n_vars
    sgs_param = [];
    sgs_param.min = 1.05*min(ppmt_out(:,sim_id));
    sgs_param.max = 1.05*max(ppmt_out(:,sim_id));
    sgs_param.cellsx = dx_sim;
    sgs_param.cellsy = dy_sim;
    column_id = 3 + sim_id;
    sgs_param.variogram_model = 2; %1.Sph; 2.Exp; 3.Gauss; 4.Power; 5.Cossine
    sgs_param.range = simulation_ranges; 
    sgs_param.seed = [num2str(sim_id),'69069'];%2*(randi(9598)+randi(9598)+randi(9598))+1;
    sgs_param.search_radius = sgs_param.range*4;
    sgs_param.sgs_par_file = ['Source Code/Library/Third Party/ppmt_le/par/sgs',num2str(sim_id),'.par'];
    sgs_param.input_file = 'Source Code/Library/Third Party/ppmt_le/data/ppmt.dat'; 
    sgs_param.output_file = ['Source Code/Library/Third Party/ppmt_le/data/sgs',num2str(sim_id),'.dat'];
    generate_sgs_par(sgs_param,column_id);
    system(['"Source Code/Library/Third Party/ppmt_le/exe/sgsim.exe" "',sgs_param.sgs_par_file,'"']);
end

%PUT THE SIMULATIONS TOGETHER:
simulations = [];
for sim_id = 1:n_vars
    simulations = [simulations,dlmread(['Source Code/Library/Third Party/ppmt_le/data/sgs',num2str(sim_id),'.dat'],'\t',3,0)];
%      delete(['data/sgs',num2str(sim_id),'.dat']);
end
save_table_dat('Unconditional SGS Simulations',variable_names,'Source Code/Library/Third Party/ppmt_le/data/sgs.dat', simulations);

%% %%%%% EXECUTE PPMT BACK TRANSFORMATION %%%%%
ppmt_b_param.n_vars = n_vars;
ppmt_b_param.min_max = [min(min(analytic_ref_logs)),max(max(analytic_ref_logs))];
ppmt_b_param.columns = 1:n_vars;
ppmt_b_param.cellsx = dx_sim;
ppmt_b_param.cellsy = dy_sim;
ppmt_b_param.ppmtb_par_file = 'Source Code/Library/Third Party/ppmt_le/par/ppmtb_par_file.par';
ppmt_b_param.transf_table = ppmt_param.ppmt_table_file;
ppmt_b_param.input_file = 'Source Code/Library/Third Party/ppmt_le/data/sgs.dat';
ppmt_b_param.output_file = 'Source Code/Library/Third Party/ppmt_le/data/out_simulations.out';
generate_ppmtb_par(ppmt_b_param);

before_ppmtb_time = toc;
system(['"Source Code/Library/Third Party/ppmt_le/exe/ppmt_b.exe" "',ppmt_b_param.ppmtb_par_file,'"']);
total_simulation_time = toc;

logs_simulated_ppmt = read_eas(ppmt_b_param.output_file)-K;
save_table_dat('PPMT Back Transform: Conditional SGS Simulations',...
    variable_names,ppmt_b_param.output_file,logs_simulated_ppmt);

disp(['Time for Total Simulation: ',num2str(total_simulation_time)]);
disp(['Time for PPMT Forward Transformation: ',num2str(forward_transformation_time)]);
disp(['Time for PPMT Back Transformation: ',num2str(total_simulation_time-before_ppmtb_time)]);
%% END OF SIMULATIONS AND DATA TRANSFORMATION

 generate_2D(reshape(logs_simulated_ppmt',6,dx_sim,dx_sim))
 generate_histograms(logs_simulated_ppmt)
   
 load('reference_data.mat')
 reference = [z1_analytic z2_analytic, z3_analytic, z4_analytic, z5_analytic, z6_analytic];
 num_of_bins = 50;
 aux_ppmt = [ logs_simulated_ppmt(:,1) logs_simulated_ppmt(:,2) logs_simulated_ppmt(:,3) logs_simulated_ppmt(:,4) logs_simulated_ppmt(:,5) logs_simulated_ppmt(:,6)];
 chi2_ppmt = generate_chi2(reference,aux_ppmt, num_of_bins,0)


