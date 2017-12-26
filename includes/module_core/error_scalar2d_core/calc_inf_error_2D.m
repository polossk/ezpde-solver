function [err] = calc_inf_error_2D( sol, pde_config )
	err = 0;
	epord = pde_config.loss.ev_point_order;
	meshes = sol.mesh_femesh;
	element_nums = length(meshes.tb);
	for n = 1 : element_nums
		vertices = meshes.pb(:, meshes.tb(:, n));
		uh_local = sol.sol(meshes.tb(:, n));
		[ev_w, ev_x, ev_y] = point_selection_2D(vertices, epord);
		epu = pde_config.exact_sol_script(ev_x, ev_y);
		uh = FE_function_2D(ev_x, ev_y, uh_local, vertices, ...
			pde_config.basis_config, [0, 0]);
		err = max(err, max(abs(epu - uh)));
	end
end