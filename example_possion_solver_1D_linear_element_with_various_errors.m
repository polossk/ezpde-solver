clear all; include('.');
mesh_config.xl = 0;
mesh_config.xr = 1;
mesh_config.h = 1.0/64;

boundary_nums = 2;
boundary_script = @(x) ((x == mesh_config.xr) .* cos(1));

basis_config.type = 101;
basis_config.nums = generate_basis_nums(basis_config.type);
basis_config.gauss_order = 3;

pde_config.coef_fun = @(x) exp(x);
pde_config.f_fun = @(x) (-exp(x) .* (cos(x) - 2 * sin(x) - x .* cos(x) - x .* sin(x))); 
pde_config.exact_sol_script = @(x) (x .* cos(x));
pde_config.exact_sol_script_diff1 = @(x) (cos(x) - x .* sin(x));

pde_config.loss.method = 'L_inf';
pde_config.loss.ev_point_order = 3;
pde_config.loss.loss_fun = @(x, y) max(abs(x - y));

pde_config.mesh_config = mesh_config;
pde_config.basis_config = basis_config;
pde_config.boundary.script = boundary_script;
pde_config.boundary.nums = boundary_nums;
pde_config.boundary.types = 1;

ns = [4, 8, 16, 32, 64, 128];
method = {'L_inf', 'L2', 'H1'};
err = zeros(length(ns), length(method));
fprintf('h\tL_inf err\tL2 err\tH1 err\n');
for idx = 1:length(ns);
	pde_config.mesh_config.h = 1.0 / ns(idx);
	[sol, pde] = possion_solver(pde_config);
	for jj = 1 : length(method)
		pde.loss.method = method{jj};
		[sol, pde] = possion_error(sol, pde);
		err(idx, jj) = sol.err;
	end
	fprintf('1/%d\t%e\t%e\t%e\n', ns(idx), err(idx, 1), err(idx, 2), err(idx, 3));
end

% h     L_inf err       L2 err          H1 err
% 1/4   1.404062e-02    7.196939e-03    1.052814e-01
% 1/8   3.680327e-03    1.795143e-03    5.273087e-02
% 1/16  9.404788e-04    4.485397e-04    2.637626e-02
% 1/32  2.375981e-04    1.121197e-04    1.318947e-02
% 1/64  5.970435e-05    2.802898e-05    6.594901e-03
% 1/128 1.496386e-05    7.007185e-06    3.297471e-03