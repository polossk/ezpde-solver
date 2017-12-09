function [sol, pde_config] = possion_solver(pde_config)
	f_fun = pde_config.f_fun;
	coef_fun = pde_config.coef_fun;
	loss_fun = pde_config.loss_fun;
	mesh_config = pde_config.mesh_config;
	basis_config = pde_config.basis_config;
	boundary = pde_config.boundary;

	[p, t] = generate_pt(mesh_config, basis_config.type);
	[pb, tb] = generate_pt_fe_basis_fun(p, t);
	sol.mesh_femesh.p = p;
	sol.mesh_femesh.t = t;
	sol.mesh_femesh.pb = pb;
	sol.mesh_femesh.tb = tb;
	boundary = generate_boundary(boundary, sol.mesh_femesh);

	A = assemble_matrix_1D(sol.mesh_femesh, basis_config, coef_fun);
	b = assemble_vector_1D(sol.mesh_femesh, basis_config, f_fun);
	[A, b] = treat_dirichlet_boundary(A, b, boundary, sol.mesh_femesh);

	sol.sol = full(A\b)';
	sol.sol_exact = pde_config.exact_sol((sol.mesh_femesh.p));
	sol.err = loss_fun(sol.sol, sol.sol_exact);

	pde_config.boundary = boundary;
end