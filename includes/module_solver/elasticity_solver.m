function [sol, pde_config] = elasticity_solver(pde_config)
	f_fun = pde_config.f_fun;
	coef_fun = pde_config.coef_fun;
	mesh_config = pde_config.mesh_config;
	basis_config = pde_config.basis_config;
	boundary = pde_config.boundary;

	[p, t] = generate_pt_2D(mesh_config);
	[pb1, tb1] = generate_pt_local_2D(mesh_config, basis_config.type(1), p, t);
	[pb2, tb2] = generate_pt_local_2D(mesh_config, basis_config.type(2), p, t);
	sol.mesh_femesh.p = p;
	sol.mesh_femesh.t = t;
	sol.mesh_femesh.meshes{1}.pb = pb1;
	sol.mesh_femesh.meshes{1}.tb = tb1;
	sol.mesh_femesh.meshes{2}.pb = pb2;
	sol.mesh_femesh.meshes{2}.tb = tb2;
	boundary_1 = generate_boundary_2D(boundary{1}, mesh_config, sol.mesh_femesh, basis_config.type(1));
	boundary_2 = generate_boundary_2D(boundary{2}, mesh_config, sol.mesh_femesh, basis_config.type(2));
	boundarys = {boundary_1, boundary_2};

	A1 = assemble_matrix_2Ds(sol.mesh_femesh, [1, 1], basis_config, coef_fun.lambda, [1, 0, 1, 0]);
	A2 = assemble_matrix_2Ds(sol.mesh_femesh, [1, 1], basis_config, coef_fun.mu, [1, 0, 1, 0]);
	A3 = assemble_matrix_2Ds(sol.mesh_femesh, [1, 1], basis_config, coef_fun.mu, [0, 1, 0, 1]);
	A4 = assemble_matrix_2Ds(sol.mesh_femesh, [2, 1], basis_config, coef_fun.lambda, [0, 1, 1, 0]);
	A5 = assemble_matrix_2Ds(sol.mesh_femesh, [2, 1], basis_config, coef_fun.mu, [1, 0, 0, 1]);
	A6 = assemble_matrix_2Ds(sol.mesh_femesh, [1, 2], basis_config, coef_fun.lambda, [1, 0, 0, 1]);
	A7 = assemble_matrix_2Ds(sol.mesh_femesh, [1, 2], basis_config, coef_fun.mu, [0, 1, 1, 0]);
	A8 = assemble_matrix_2Ds(sol.mesh_femesh, [2, 2], basis_config, coef_fun.lambda, [0, 1, 0, 1]);
	A9 = assemble_matrix_2Ds(sol.mesh_femesh, [2, 2], basis_config, coef_fun.mu, [0, 1, 0, 1]);
	AX = assemble_matrix_2Ds(sol.mesh_femesh, [2, 2], basis_config, coef_fun.mu, [1, 0, 1, 0]);

	b1 = assemble_vector_2Ds(sol.mesh_femesh, 1, basis_config, f_fun.f1, [0, 0]);
	b2 = assemble_vector_2Ds(sol.mesh_femesh, 2, basis_config, f_fun.f2, [0, 0]);

	A = [A1 + 2 * A2 + A3, A4 + A5; A6 + A7, A8 + 2 * A9 + AX];
	b = [b1; b2];
    
    fprintf('before treat boundary, condest(A)= %f\n', condest(A));
	[A, b] = treat_dirichlet_boundary_2Ds(A, b, boundarys, sol.mesh_femesh, [1, 2]);
    fprintf('after treat boundary, condest(A)= %f\n', condest(A));
    
	u = full(A\b)';
	ulen = length(pb1(1, :));
	sol.sol.u1 = u(1 : ulen);
	sol.sol.u2 = u(ulen + 1 : end);
	sol.sol_exact.u1 = pde_config.u1.exact_sol_script(pb1(1, :), pb1(2, :));
	sol.sol_exact.u2 = pde_config.u2.exact_sol_script(pb2(1, :), pb2(2, :));
	% begin debug
	% [sol.sol.u1', sol.sol_exact.u1', (sol.sol.u1' - sol.sol_exact.u1')]
	% [sol.sol.u2', sol.sol_exact.u2', (sol.sol.u2' - sol.sol_exact.u2')]
	% end debug
	pde_config.boundary = {boundary_1, boundary_2};
end