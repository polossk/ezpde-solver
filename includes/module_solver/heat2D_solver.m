function [sol, pde_config] = heat2D_solver(pde_config)
	f_fun = pde_config.f_fun;
	coef_fun = pde_config.coef_fun;
	mesh_config = pde_config.mesh_config;
	basis_config = pde_config.basis_config;
	boundary = pde_config.boundary;
	
	[p, t] = generate_pt_2D(mesh_config);
	[pb, tb] = generate_pt_local_2D(mesh_config, basis_config.type, p, t);
	sol.mesh_femesh.p = p;
	sol.mesh_femesh.t = t;
	sol.mesh_femesh.pb = pb;
	sol.mesh_femesh.tb = tb;
	pbx = sol.mesh_femesh.pb(1, :);
	pby = sol.mesh_femesh.pb(2, :);
	boundary = generate_boundary_2D(boundary, mesh_config, sol.mesh_femesh, basis_config.type);

	t0 = mesh_config.t0;
	th = mesh_config.th;
	t1 = mesh_config.t1;
	ts = t0 : th : t1;
	theta = mesh_config.theta;
	
	curry_fs = cellfun(@(t_)(@(x, y)(f_fun(x, y, t_))), num2cell(ts), 'UniformOutput', false);
	bs = cellfun(@(f_)(assemble_vector_2D(sol.mesh_femesh, basis_config, f_, [0, 0])), curry_fs, 'UniformOutput', false);
	bs = cell2mat(bs);

	% curry_cs = cellfun(@(t_)(@(x, y)(coef_fun(x, y, t_))), num2cell(t));
	% A1s = cellfun(@(f_)(assemble_matlab_2D(sol.mesh_femesh, basis_config, f_, [1, 0, 1, 0])), curry_cs);
	% A2s = cellfun(@(f_)(assemble_matlab_2D(sol.mesh_femesh, basis_config, f_, [0, 1, 0, 1])), curry_cs);
	% [m_, n_] = size(A1s{1});
	% As = reshape(cell2mat(A1s) + cell2mat(A2s), m_, n_, length(t));
	
	A1 = assemble_matrix_2D(sol.mesh_femesh, basis_config, coef_fun, [1, 0, 1, 0]);
	A2 = assemble_matrix_2D(sol.mesh_femesh, basis_config, coef_fun, [0, 1, 0, 1]);
	M = assemble_matrix_2D(sol.mesh_femesh, basis_config, @(x, y)(1), [0, 0, 0, 0]);
	A = A1 + A2;
	At = M / th + A * theta;
	Au = M / th - A * (1 - theta);
	At = treat_dirichlet_boundary_2D_A(At, boundary, sol.mesh_femesh);
	bt = (1 - theta) * bs(:, 1 : end - 1) + theta * bs(:, 2 : end);
	sol.sol = zeros(length(ts), length(pb));
	sol.sol_exact = zeros(length(ts), length(pb));
	sol.sol(1, :) = pde_config.boundary.u0(pbx, pby);
	sol.sol_exact(1, :) = pde_config.exact_sol_script(pbx, pby, t0);
	boundary.script_0 = boundary.script;
	for idx = 2:length(ts)
		boundary.script = @(x, y) (boundary.script_0(x, y, ts(idx)));
		bs = bt(:, idx - 1) + Au * sol.sol(idx - 1, :)';
		bs = treat_dirichlet_boundary_2D_b(bs, boundary, sol.mesh_femesh);
		sol.sol(idx, :) = full(At\bs)';
		sol.sol_exact(idx, :) = pde_config.exact_sol_script(pbx, pby, ts(idx));
	end
	pde_config.boundary = boundary;
end