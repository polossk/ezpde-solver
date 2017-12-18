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
pde_config.loss.ev_point_order = 3;
pde_config.loss.loss_fun = @(x, y) max(abs(x - y));

pde_config.mesh_config = mesh_config;
pde_config.basis_config = basis_config;
pde_config.boundary = boundary;

% [sol, pde] = possion2D_solver(pde_config);
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

% ns = [2, 4, 8, 16];
ns = [2, 4, 8, 16, 32, 64, 128];
err = zeros(size(ns));
fprintf('h\terr\n');
for idx = 1:length(ns);
	pde_config.mesh_config.hx = 2.0 / ns(idx);
	pde_config.mesh_config.hy = 2.0 / ns(idx);
	[sol, pde] = possion2D_solver(pde_config);
	[sol, pde] = possion2D_error(sol, pde);
	err(idx) = sol.err;
	fprintf('1/%d\t%e\n', ns(idx), err(idx));
end
% result
% h     max-abs-err
% 1/2   6.930708e-02
% 1/4   2.495332e-02
% 1/8   6.697883e-03
% 1/16  1.730405e-03
% 1/32  4.352294e-04
% 1/64  1.090224e-04
% 1/128 2.726978e-05