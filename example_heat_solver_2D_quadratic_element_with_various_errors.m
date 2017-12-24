clear all; include('.');
mesh_config.type = 'triangular';
mesh_config.xl = 0;
mesh_config.xr = 1;
mesh_config.hx = 1/2;
mesh_config.yl = 0;
mesh_config.yr = 1;
mesh_config.hy = 1/2;
mesh_config.t0 = 0;
mesh_config.t1 = 1;
mesh_config.th = mesh_config.hx;
mesh_config.theta = 0.5;

boundary.boundary_nums = 1;
s1 = @(x, y, t) (exp(y + t));
s2 = @(x, y, t) (exp(y + t + 1));
s3 = @(x, y, t) (exp(x + t));
s4 = @(x, y, t) (exp(x + t + 1));
b1 = @(x, y, t) ((x == mesh_config.xl) .* s1(x, y, t));
b2 = @(x, y, t) ((x == mesh_config.xr) .* s2(x, y, t));
b3 = @(x, y, t) ((y == mesh_config.yl) .* s3(x, y, t));
b4 = @(x, y, t) ((y == mesh_config.yr) .* s4(x, y, t));
boundary.script = @(x, y, t) (b1(x, y, t) + b2(x, y, t) + b3(x, y, t) + b4(x, y, t));
boundary.types = 1;
boundary.u0 = @(x, y) (exp(x + y));

basis_config.type = 202;
basis_config.nums = generate_basis_nums(basis_config.type);
basis_config.gauss_order = 3;

pde_config.coef_fun = @(x, y) 2;
pde_config.f_fun = @(x, y, t) (-3 * exp(x + y + t)); 
pde_config.exact_sol_script = @(x, y, t) (exp(x + y + t));
pde_config.exact_sol_script_diffx = @(x, y, t) (exp(x + y + t));
pde_config.exact_sol_script_diffy = @(x, y, t) (exp(x + y + t));

pde_config.loss.method = 'custom';
pde_config.loss.ev_point_order = 3;
pde_config.loss.loss_fun = @(x, y) max(max(abs(x - y)));
pde_config.loss.t = 1;

pde_config.mesh_config = mesh_config;
pde_config.basis_config = basis_config;
pde_config.boundary = boundary;

% [sol, pde] = heat2D_solver(pde_config);
% [sol, pde] = heat2D_error(sol, pde);
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

% ns = [4];
% ns = [4, 8];
ns = [4, 8, 16, 32, 64];
ts = [8, 23, 64, 181, 512];
% method = {'custom'};
method = {'custom', 'L_inf', 'L2', 'H1'};
err = zeros(length(ns), length(method));
fprintf('h     max-abs-err     L_inf err       L2 err          H1 err\n');
for idx = 1:length(ns);
	pde_config.mesh_config.hx = 1.0 / ns(idx);
	pde_config.mesh_config.hy = 1.0 / ns(idx);
	pde_config.mesh_config.th = 1.0 / ts(idx);
	[sol, pde] = heat2D_solver(pde_config);
	for jj = 1 : length(method)
		pde.loss.method = method{jj};
		[sol, pde] = heat2D_error(sol, pde);
		err(idx, jj) = sol.err;
	end
	fprintf('1/%d\t%e\t%e\t%e\t%e\n', ns(idx), err(idx, 1), err(idx, 2), err(idx, 3), err(idx, 4));
end
% result
% h     max-abs-err     L_inf err       L2 err          H1 err
% 1/4   5.556340e-04    2.183865e-03    9.981548e-04    1.312811e-02
% 1/8   5.971986e-05    2.954009e-04    1.252787e-04    3.227846e-03
% 1/16  6.630525e-06    3.809792e-05    1.576157e-05    8.008876e-04
% 1/32  7.924670e-07    4.835851e-06    1.974932e-06    2.000215e-04
% 1/64  9.609279e-08    6.090371e-07    2.472313e-07    4.997478e-05
% Elapsed time is 12054.431790 seconds.
