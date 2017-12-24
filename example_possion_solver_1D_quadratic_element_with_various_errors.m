clear all; include('.');
mesh_config.xl = 0;
mesh_config.xr = 1;
mesh_config.h = 1.0/64;

boundary_nums = 2;
boundary_script = @(x) ((x == mesh_config.xr) .* cos(1));

basis_config.type = 102;
basis_config.nums = generate_basis_nums(basis_config.type);
basis_config.gauss_order = 3;

pde_config.coef_fun = @(x) exp(x);
pde_config.f_fun = @(x) (-exp(x) .* (cos(x) - 2 * sin(x) - x .* cos(x) - x .* sin(x))); 
pde_config.exact_sol_script = @(x) (x .* cos(x));
pde_config.exact_sol_script_diff1 = @(x) (cos(x) - x .* sin(x));

pde_config.loss.method = 'custom';
pde_config.loss.ev_point_order = 3;
pde_config.loss.loss_fun = @(x, y) max(abs(x - y));

pde_config.loss_fun = @(x, y) max(abs(x - y));

pde_config.mesh_config = mesh_config;
pde_config.basis_config = basis_config;
pde_config.boundary.script = boundary_script;
pde_config.boundary.nums = boundary_nums;
pde_config.boundary.types = 1;

ns = [4, 8, 16, 32, 64, 128];
method = {'custom', 'L_inf', 'L2', 'H1'};
err = zeros(length(ns), length(method));
fprintf('h     max-abs-err     L_inf err       L2 err          H1 err\n');
for idx = 1:length(ns);
	pde_config.mesh_config.h = 1.0 / ns(idx);
	[sol, pde] = possion_solver(pde_config);
	for jj = 1 : length(method)
		pde.loss.method = method{jj};
		[sol, pde] = possion_error(sol, pde);
		err(idx, jj) = sol.err;
	end
	fprintf('1/%d\t%e\t%e\t%e\t%e\n', ns(idx), err(idx, 1), err(idx, 2), err(idx, 3), err(idx, 4));
end
% result
% h     max-abs-err     L_inf err       L2 err          H1 err
% 1/4   4.659667e-05    3.312807e-04    2.104080e-04    5.421242e-03
% 1/8   2.991841e-06    3.923965e-05    2.614449e-05    1.353397e-03
% 1/16  1.890097e-07    4.751777e-06    3.263135e-06    3.382297e-04
% 1/32  1.186940e-08    5.838982e-07    4.077376e-07    8.454996e-05
% 1/64  7.435081e-10    7.234276e-08    5.096238e-08    2.113702e-05
% 1/128 4.659373e-11    9.002181e-09    6.370147e-09    5.284227e-06