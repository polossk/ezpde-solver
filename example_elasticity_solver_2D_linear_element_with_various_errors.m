clear all; include('.');
mesh_config.type = 'triangular';
mesh_config.xl = 0;
mesh_config.xr = 1;
mesh_config.hx = 1.0/4;
mesh_config.yl = 0;
mesh_config.yr = 1;
mesh_config.hy = 1.0/4;

u1_boundary.boundary_nums = 1;
s1_1 = @(x, y) exp(y - 1);
s2_1 = @(x, y) exp(y);
s3_1 = @(x, y) exp(x - 1);
s4_1 = @(x, y) exp(x);
b1_1 = @(x, y) ((x == mesh_config.xl) .* s1_1(x, y));
b2_1 = @(x, y) ((x == mesh_config.xr) .* s2_1(x, y));
b3_1 = @(x, y) ((y == mesh_config.yl) .* s3_1(x, y));
b4_1 = @(x, y) ((y == mesh_config.yr) .* s4_1(x, y));
u1_boundary.script = @(x, y) (b1_1(x, y) + b2_1(x, y) + b3_1(x, y) + b4_1(x, y));
u1_boundary.types = 1;

u2_boundary.boundary_nums = 1;
s1_2 = @(x, y) exp(1 - y);
s2_2 = @(x, y) exp(2 - y);
s3_2 = @(x, y) exp(x + 1);
s4_2 = @(x, y) exp(x);
b1_2 = @(x, y) ((x == mesh_config.xl) .* s1_2(x, y));
b2_2 = @(x, y) ((x == mesh_config.xr) .* s2_2(x, y));
b3_2 = @(x, y) ((y == mesh_config.yl) .* s3_2(x, y));
b4_2 = @(x, y) ((y == mesh_config.yr) .* s4_2(x, y));
u2_boundary.script = @(x, y) (b1_2(x, y) + b2_2(x, y) + b3_2(x, y) + b4_2(x, y));
u2_boundary.types = 1;

basis_config.type = [201, 202];
basis_config.nums = arrayfun(@generate_basis_nums, basis_config.type);
basis_config.gauss_order = 3;

pde_config.coef_fun.lambda = @(x, y) 0.75;
pde_config.coef_fun.mu = @(x, y) 1;
pde_config.f_fun.f1 = @(x, y) ( 1.75 .* exp(1+x-y) - 3.75 .* exp(-1+x+y));
pde_config.f_fun.f2 = @(x, y) (-3.75 .* exp(1+x-y) - 1.75 .* exp(-1+x+y));


pde_config.u1.exact_sol_script = @(x, y) exp(x + y - 1);
pde_config.u2.exact_sol_script = @(x, y) exp(x - y + 1);
pde_config.u1.exact_sol_script_diffx = @(x, y) exp(x + y - 1);
pde_config.u1.exact_sol_script_diffy = @(x, y) exp(x + y - 1);
pde_config.u2.exact_sol_script_diffx = @(x, y) exp(x - y + 1);
pde_config.u2.exact_sol_script_diffy = @(x, y) -exp(x - y + 1);

pde_config.loss.method = 'custom';
pde_config.loss.ev_point_order = 4;
pde_config.loss.loss_fun = @(x, y) max(abs(x - y));

pde_config.mesh_config = mesh_config;
pde_config.basis_config = basis_config;
pde_config.boundary = {u1_boundary, u2_boundary};

ns = [32];
% ns = [2, 4, 8, 16];
% ns = [2, 4, 8, 16, 32, 64, 128];
method = {'custom', 'L_inf', 'L2', 'H1'};
% method = {'custom'};
err = zeros(2, length(ns), length(method));
for idx = 1:length(ns);
	pde_config.mesh_config.hx = 1.0 / ns(idx);
	pde_config.mesh_config.hy = 1.0 / ns(idx);
	[sol, pde] = elasticity_solver(pde_config);
	for jj = 1 : length(method)
		pde.loss.method = method{jj};
		[sol, pde] = elasticity_error(sol, pde);
		err(1, idx, jj) = sol.err.u1;
		err(2, idx, jj) = sol.err.u2;
	end
	fprintf('ns = %d: done.\n', ns(idx));
end

for kdx = 1:2
	fprintf('u%d error:\n', kdx);
	fprintf('h     max-abs-err     L_inf err       L2 err          H1 err\n');
	for idx = 1:length(ns)
		fprintf('1/%d', ns(idx));
		for jdx = 1:length(method)
			fprintf('\t%e', err(kdx, idx, jdx));
		end
		fprintf('\n');
	end
end

% result
% u1 error:
% h     max-abs-err     L_inf err       L2 err          H1 err
% 1/2   8.244519e-04    6.513749e-02    2.719907e-02    2.426600e-01
% 1/4   1.747946e-04    1.846312e-02    6.760518e-03    1.203125e-01
% 1/8   5.180036e-05    4.919714e-03    1.690982e-03    6.001864e-02
% 1/16  1.276328e-05    1.270089e-03    4.231547e-04    2.999175e-02
% u2 error:
% h     max-abs-err     L_inf err       L2 err          H1 err
% 1/2   1.847288e-02    2.614994e-02    9.545408e-03    1.721748e-01
% 1/4   6.203519e-03    4.902700e-03    1.648114e-03    6.300281e-02
% 1/8   1.756637e-03    1.395369e-03    3.483584e-04    2.825345e-02
% 1/16  4.638766e-04    3.688796e-04    8.256522e-05    1.385259e-02