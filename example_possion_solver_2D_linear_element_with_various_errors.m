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

basis_config.type = 201;
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
% [sol, pde] = equ_error2D(sol, pde);
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
% ns = [2, 4, 8, 16];
ns = [2, 4, 8, 16, 32, 64, 128];
method = {'custom', 'L_inf', 'L2', 'H1'};
err = zeros(length(ns), length(method));
fprintf('h     max-abs-err     L_inf err       L2 err          H1 err\n');
for idx = 1:length(ns);
	pde_config.mesh_config.hx = 1.0 / ns(idx);
	pde_config.mesh_config.hy = 1.0 / ns(idx);
	[sol, pde] = possion2D_solver(pde_config);
	for jj = 1 : length(method)
		pde.loss.method = method{jj};
		[sol, pde] = equ_error2D(sol, pde);
		err(idx, jj) = sol.err;
	end
	fprintf('1/%d\t%e\t%e\t%e\t%e\n', ns(idx), err(idx, 1), err(idx, 2), err(idx, 3), err(idx, 4));
end
% result
% h     max-abs-err     L_inf err       L2 err          H1 err
% 1/2   2.495332e-02    2.339767e-01    9.791517e-02    7.069796e-01
% 1/4   6.697883e-03    7.781467e-02    2.668079e-02    3.708270e-01
% 1/8   1.730405e-03    2.239213e-02    6.833922e-03    1.877403e-01
% 1/16  4.352294e-04    6.003198e-03    1.719393e-03    9.416670e-02
% 1/32  1.090224e-04    1.553992e-03    4.305454e-04    4.712061e-02
% 1/64  2.726978e-05    3.953120e-04    1.076802e-04    2.356497e-02
% 1/128 6.817896e-06    9.969028e-05    2.692281e-05    1.178307e-02
