function [sol, pde_config] = possion_solver(pde_config)
	f_fun = pde_config.f_fun;
	coef_fun = pde_config.coef_fun;
	mesh_config = pde_config.mesh_config;
	basis_config = pde_config.basis_config;
	boundary = pde_config.boundary;

	[p, t, pb, tb] = generate_pt(mesh_config, basis_config.type);
	sol.mesh_femesh.p = p;
	sol.mesh_femesh.t = t;
	sol.mesh_femesh.pb = pb;
	sol.mesh_femesh.tb = tb;
	boundary = generate_boundary(boundary, mesh_config, sol.mesh_femesh);

	A = assemble_matrix_1D(sol.mesh_femesh, basis_config, coef_fun, 1);
	b = assemble_vector_1D(sol.mesh_femesh, basis_config, f_fun, 0);
	[A, b] = treat_dirichlet_boundary(A, b, boundary, sol.mesh_femesh);
	
	sol.sol = full(A\b)';
	sol.sol_exact = pde_config.exact_sol_script(sol.mesh_femesh.pb);

	pde_config.boundary = boundary;
end