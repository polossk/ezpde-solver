function [err] = calc_inf_error( sol, pde_config )
	err = 0;
	epord = pde_config.loss.ev_point_order;
	meshes = sol.mesh_femesh;
	element_nums = length(meshes.tb);
	for n = 1 : element_nums
		vertices = meshes.pb(:, meshes.tb(:, n));
		uh_local = sol.sol(meshes.tb(:, n));
		[ev_w, ev_x] = point_selection(vertices, epord);
		epu = pde_config.exact_sol_script(ev_x);
		uh = FE_function_1D(ev_x, uh_local, vertices, ...
			pde_config.basis_config, 0);
		err = max(err, max(abs(epu - uh)));
	end
end