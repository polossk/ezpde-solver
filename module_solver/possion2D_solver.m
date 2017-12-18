function [sol, pde_config] = possion2D_solver(pde_config)
	f_fun = pde_config.f_fun;
	coef_fun = pde_config.coef_fun;
	mesh_config = pde_config.mesh_config;
	basis_config = pde_config.basis_config;
	boundary = pde_config.boundary;

	[p, t] = generate_pt_2D(mesh_config, basis_config.type);
	[pb, tb] = generate_pt_fe_basis_fun(p, t, basis_config.type);
	sol.mesh_femesh.p = p;
	sol.mesh_femesh.t = t;
	sol.mesh_femesh.pb = pb;
	sol.mesh_femesh.tb = tb;
	boundary = generate_boundary_2D(boundary, mesh_config, sol.mesh_femesh);

	A1 = assemble_matrix_2D(sol.mesh_femesh, basis_config, coef_fun, [1, 0, 1, 0]);
	A2 = assemble_matrix_2D(sol.mesh_femesh, basis_config, coef_fun, [0, 1, 0, 1]);
	b = assemble_vector_2D(sol.mesh_femesh, basis_config, f_fun, [0, 0]);
	[A, b] = treat_dirichlet_boundary_2D(A1 + A2, b, boundary, sol.mesh_femesh);
	
	sol.sol = full(A\b)';
	pbx = sol.mesh_femesh.pb(1, :);
	pby = sol.mesh_femesh.pb(2, :);
	sol.sol_exact = pde_config.exact_sol_script(pbx, pby);
	pde_config.boundary = boundary;
end