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

pde_config.loss.method = 'custom';
pde_config.loss.ev_point_order = 3;
pde_config.loss.loss_fun = @(x, y) max(abs(x - y));

pde_config.mesh_config = mesh_config;
pde_config.basis_config = basis_config;
pde_config.boundary.script = boundary_script;
pde_config.boundary.nums = boundary_nums;
pde_config.boundary.types = 1;

ns = [4, 8, 16, 32, 64, 128];
err = zeros(size(ns));
fprintf('h\terr\n');
for idx = 1:length(ns);
	pde_config.mesh_config.h = 1.0 / ns(idx);
	[sol, pde] = possion_solver(pde_config);
	[sol, pde] = equ_error(sol, pde);
	err(idx) = sol.err;
	fprintf('1/%d\t%e\n', ns(idx), err(idx));
end
% result
% h     max-abs-err
% 1/4   2.333971e-03
% 1/8   5.831721e-04
% 1/16  1.464455e-04
% 1/32  3.667515e-05
% 1/64  9.170024e-06
% 1/128 2.292923e-06
