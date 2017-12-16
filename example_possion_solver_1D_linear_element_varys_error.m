include('.');
mesh_config.xl = 0;
mesh_config.xr = 1;
mesh_config.h = 1.0/64;

boundary_nums = 2;
boundary_script = @(x) ((x == mesh_config.xr) .* cos(1));

basis_config.type = 101;
basis_config.nums = 2;
basis_config.gauss_order = 3;

pde_config.coef_fun = @(x) exp(x);
pde_config.f_fun = @(x) (-exp(x) .* (cos(x) - 2 * sin(x) - x .* cos(x) - x .* sin(x))); 
pde_config.exact_sol_script = @(x) (x .* cos(x));
pde_config.exact_sol_script_diff1 = @(x) (cos(x) - x .* sin(x));

pde_config.loss.method = 'L_inf';
pde_config.loss.ev_point_nums = 4;
pde_config.loss.loss_fun = @(x, y) max(abs(x - y));

pde_config.mesh_config = mesh_config;
pde_config.basis_config = basis_config;
pde_config.boundary.script = boundary_script;
pde_config.boundary.nums = boundary_nums;
pde_config.boundary.types = [1, 1];

for method = {'L_inf', 'L2', 'H1'}
	pde_config.loss.method = method;
	ns = [4, 8, 16, 32, 64, 128];
	% ns = 4;
	err = zeros(size(ns));
	fprintf('h\terr\n');
	for idx = 1:length(ns);
	    pde_config.mesh_config.h = 1.0 / ns(idx);
	    [sol, pde] = possion_solver(pde_config);
	    err(idx) = sol.err;
	    fprintf('1/%d\t%e\n', ns(idx), err(idx));
	end
end

% h     L-inf err
% 1/4   1.553899e-02
% 1/8   4.119458e-03
% 1/16  1.058202e-03
% 1/32  2.680052e-04
% 1/64  6.742689e-05
% 1/128 1.690951e-05
% h     L2-err
% 1/4   7.196939e-03
% 1/8   1.795143e-03
% 1/16  4.485397e-04
% 1/32  1.121197e-04
% 1/64  2.802898e-05
% 1/128 7.007185e-06
% h     H1-err
% 1/4   1.052814e-01
% 1/8   5.273087e-02
% 1/16  2.637626e-02
% 1/32  1.318947e-02
% 1/64  6.594901e-03
% 1/128 3.297471e-03
