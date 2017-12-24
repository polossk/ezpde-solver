clear all; include('.');
mesh_config.type = 'triangular';
mesh_config.xl = -1;
mesh_config.xr = 1;
mesh_config.hx = 2.0/4;
mesh_config.yl = -1;
mesh_config.yr = 1;
mesh_config.hy = 2.0/4;

boundary.boundary_nums = 1;
s1 = @(x, y) (-1.5 * y .* (1 - y) .* exp(y - 1));
s2 = @(x, y) ( 0.5 * y .* (1 - y) .* exp(y + 1));
s3 = @(x, y) (-x .* (2 - x) .* exp(x - 1));
s4 = @(x, y) 0;
b1 = @(x, y) ((x == mesh_config.xl) .* s1(x, y));
b2 = @(x, y) ((x == mesh_config.xr) .* s2(x, y));
b3 = @(x, y) ((y == mesh_config.yl) .* s3(x, y));
b4 = @(x, y) ((y == mesh_config.yr) .* s4(x, y));
boundary.script = @(x, y) (b1(x, y) + b2(x, y) + b3(x, y) + b4(x, y));
boundary.types = 1;

basis_config.type = 202;
basis_config.nums = generate_basis_nums(basis_config.type);
basis_config.gauss_order = 3;

pde_config.coef_fun = @(x, y) 1;
pde_config.f_fun = @(x, y) (exp(x + y) .* (y .* (y - 1) .* (1 - x - x .* x / 2) + x .* (1 - x / 2) .* (3 * y + y .* y))); 
pde_config.exact_sol_script = @(x, y) (exp(x + y) .* x .* y .* (1 - x / 2) .* (1 - y));
pde_config.exact_sol_script_diffx = @(x, y) (exp(x + y) / 2 .* (2 - x .* x) .* (1 - y) .* y);
pde_config.exact_sol_script_diffy = @(x, y) (exp(x + y) / 2 .* (2 - x) .* (1 - y - y .* y) .* x);

pde_config.loss.method = 'custom';
pde_config.loss.ev_point_order = 4;
pde_config.loss.loss_fun = @(x, y) max(abs(x - y));

pde_config.mesh_config = mesh_config;
pde_config.basis_config = basis_config;
pde_config.boundary = boundary;

% [sol, pde] = possion2D_solver(pde_config);
% [sol, pde] = possion2D_error(sol, pde);
% err = sol.err
% xl = mesh_config.xl;
% xr = mesh_config.xr;
% yl = mesh_config.yl;
% yr = mesh_config.yr;
% hx = mesh_config.hx;
% hy = mesh_config.hy;
% nx = (xr - xl) / hx;
% ny = (yr - yl) / hy;
% px = xl : hx : xr; npx = nx + 1;
% py = yl : hy : yr; npy = ny + 1;
% [xx, yy] = meshgrid(px, py);
% u_exact = pde_config.exact_sol_script(xx, yy);
% u = reshape(sol.sol, npy, npx);
% figure;
% subplot(1, 3, 1); mesh(xx, yy, u_exact);
% subplot(1, 3, 2); mesh(xx, yy, u);
% subplot(1, 3, 3); mesh(xx, yy, u - u_exact);

% ns = [2, 4];
ns = [2, 4, 8, 16];
% ns = [2, 4, 8, 16, 32, 64, 128];
method = {'custom', 'L_inf', 'L2', 'H1'};
err = zeros(length(ns), length(method));
fprintf('h     max-abs-err     L_inf err       L2 err          H1 err\n');
for idx = 1:length(ns);
	pde_config.mesh_config.hx = 1.0 / ns(idx);
	pde_config.mesh_config.hy = 1.0 / ns(idx);
	[sol, pde] = possion2D_solver(pde_config);
	for jj = 1 : length(method)
		pde.loss.method = method{jj};
		[sol, pde] = possion2D_error(sol, pde);
		err(idx, jj) = sol.err;
	end
	fprintf('1/%d\t%e\t%e\t%e\t%e\n', ns(idx), err(idx, 1), err(idx, 2), err(idx, 3), err(idx, 4));
end
% result
% h     max-abs-err     L_inf err       L2 err          H1 err
% 1/2   2.053777e-03    1.432207e-02    6.675543e-03    1.342336e-01
% 1/4   1.832846e-04    2.174267e-03    8.664180e-04    3.533126e-02
% 1/8   1.503997e-05    2.997468e-04    1.092810e-04    8.950835e-03
% 1/16  1.129650e-06    3.935364e-05    1.368942e-05    2.245258e-03
% 1/32  7.792216e-08    5.041543e-06    1.712071e-06    5.617911e-04
% 1/64  5.162271e-09    6.379829e-07    2.140364e-07    1.404777e-04
% 1/128 3.347873e-10    8.023928e-08    2.675541e-08    3.512130e-05
% Elapsed time is 12768.767043 seconds.
