function [sol, pde_config] = equation_error2Ds(sol, pde_config)
	lmethod = pde_config.loss.method;
	if strcmp(lmethod, 'custom')
		sol.err.u1 = pde_config.loss.loss_fun(sol.sol.u1, sol.sol_exact.u1);
		sol.err.u2 = pde_config.loss.loss_fun(sol.sol.u2, sol.sol_exact.u2);
		return;
	end
	sol_u1.sol = sol.sol.u1;
	sol_u1.mesh_femesh = sol.mesh_femesh;
	sol_u1.mesh_femesh = rmfield(sol_u1.mesh_femesh, 'meshes');
	sol_u1.mesh_femesh.pb = sol.mesh_femesh.meshes{1}.pb;
	sol_u1.mesh_femesh.tb = sol.mesh_femesh.meshes{1}.tb;
	
	pde_config_u1 = pde_config.u1;
	pde_config_u1.loss = pde_config.loss;
	pde_config_u1.basis_config.type = pde_config.basis_config.type(1);
	pde_config_u1.basis_config.nums = pde_config.basis_config.nums(1);
	
	sol_u2.sol = sol.sol.u2;
	sol_u2.mesh_femesh = sol.mesh_femesh;
	sol_u2.mesh_femesh = rmfield(sol_u2.mesh_femesh, 'meshes');
	sol_u2.mesh_femesh.pb = sol.mesh_femesh.meshes{2}.pb;
	sol_u2.mesh_femesh.tb = sol.mesh_femesh.meshes{2}.tb;
	
	pde_config_u2 = pde_config.u2;
	pde_config_u2.loss = pde_config.loss;
	pde_config_u2.basis_config.type = pde_config.basis_config.type(2);
	pde_config_u2.basis_config.nums = pde_config.basis_config.nums(2);
	
	switch lmethod %todo
		case 'L_inf'
			sol.err.u1 = calc_inf_error_2D(sol_u1, pde_config_u1);
			sol.err.u2 = calc_inf_error_2D(sol_u2, pde_config_u2);
		case 'L2'
			sol.err.u1 = calc_l2_error_2D(sol_u1, pde_config_u1);
			sol.err.u2 = calc_l2_error_2D(sol_u2, pde_config_u2);
		case 'H1'
			sol.err.u1 = calc_h1_error_2D(sol_u1, pde_config_u1);
			sol.err.u2 = calc_h1_error_2D(sol_u2, pde_config_u2);
		otherwise
			warning(['No implementation.']);
	end
end