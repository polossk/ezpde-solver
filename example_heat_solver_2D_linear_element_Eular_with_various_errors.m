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
mesh_config.theta = 1;

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

basis_config.type = 201;
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

% ns = [2];
% ns = [2, 4];
ns = [2, 4, 8, 16, 32, 64];
% method = {'custom'};
method = {'custom', 'L_inf', 'L2', 'H1'};
err = zeros(length(ns), length(method));
fprintf('h     max-abs-err     L_inf err       L2 err          H1 err\n');
for idx = 1:length(ns);
	pde_config.mesh_config.hx = 1.0 / ns(idx);
	pde_config.mesh_config.hy = 1.0 / ns(idx);
	pde_config.mesh_config.th = 4.0 / ns(idx) / ns(idx) ;
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
% 1/2   8.227782e-02    4.796730e-01    2.077961e-01    1.793681e+00
% 1/4   2.906897e-02    1.342295e-01    5.818379e-02    8.910719e-01
% 1/8   8.149709e-03    3.553807e-02    1.524567e-02    4.438637e-01
% 1/16  2.121309e-03    9.145208e-03    3.862929e-03    2.216633e-01
% 1/32  5.335734e-04    2.319745e-03    9.691051e-04    1.107958e-01
% 1/64  1.337710e-04    5.841713e-04    2.424899e-04    5.539334e-02
% Elapsed time is 10003.337414 seconds.