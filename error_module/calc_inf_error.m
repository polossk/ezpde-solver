function [err] = calc_inf_error( sol, pde_config )
	err = 0;
	eplen = pde_config.loss.ev_point_nums;
	meshes = sol.mesh_femesh;
	point_nums = length(meshes.pb);
	element_nums = length(meshes.p) - 1;
	for n = 1 : element_nums
		vertices = meshes.p(:, meshes.t(:, n));
		uh_local = sol.sol(meshes.tb(:, n));
		[ev_w, ev_x] = point_selection(vertices, eplen);
		epu = pde_config.exact_sol_script(ev_x);
		uh = FE_function_1D(ev_x, uh_local, vertices, ...
			pde_config.basis_config, 0);
		err = max(err, max(abs(epu - uh)));
	end
end