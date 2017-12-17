include('.');
mesh_config.type = 'triangular'
mesh_config.xl = -1;
mesh_config.xr = 1;
mesh_config.hx = 1.0/8;
mesh_config.yl = -1;
mesh_config.yr = 1;
mesh_config.hy = 1.0/8;

boundary.boundary_nums = 4;
s1 = @(x, y) (-1.5 * y .* (1 - y) .* exp(y - 1));
s2 = @(x, y) ( 0.5 * y .* (1 - y) .* exp(y + 1));
s3 = @(x, y) (-x .* (2 - x) .* exp(x - 1));
s4 = @(x, y) 0;
b1 = @(x, y) ((x == mesh_config.xl) .* s1(x, y));
b2 = @(x, y) ((x == mesh_config.xr) .* s2(x, y));
b3 = @(x, y) ((x == mesh_config.yl) .* s3(x, y));
b4 = @(x, y) ((x == mesh_config.yr) .* s4(x, y));
boundary.script = {b1, b2, b3, b4};
boundary.types = 1;

basis_config.type = 201;
basis_config.nums = generate_basis_nums(basis_config.type);
basis_config.gauss_order = 3;

pde_config.coef_fun = @(x) 1;
pde_config.f_fun = @(x) (-exp(x) .* (cos(x) - 2 * sin(x) - x .* cos(x) - x .* sin(x))); 
pde_config.exact_sol_script = @(x) (x .* cos(x));
pde_config.exact_sol_script_diff1 = @(x) (cos(x) - x .* sin(x));

pde_config.loss.method = 'custom';
pde_config.loss.ev_point_nums = 4;
pde_config.loss.loss_fun = @(x, y) max(abs(x - y));

pde_config.mesh_config = mesh_config;
pde_config.basis_config = basis_config;
pde_config.boundary = boundary;

ns = [4, 8, 16, 32, 64, 128];
err = zeros(size(ns));
fprintf('h\terr\n');
for idx = 1:length(ns);
    pde_config.mesh_config.h = 1.0 / ns(idx);
    [sol, pde] = possion_solver(pde_config);
    err(idx) = sol.err;
    fprintf('1/%d\t%e\n', ns(idx), err(idx));
end
% result
% h     err
% 1/4   2.333971e-03
% 1/8   5.831721e-04
% 1/16  1.464455e-04
% 1/32  3.667515e-05
% 1/64  9.170024e-06
% 1/128 2.292923e-06
