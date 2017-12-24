function [err] = calc_hs_error_2D( rs, sol, pde_config )
	errs = [];
	epord = pde_config.loss.ev_point_order;
	meshes = sol.mesh_femesh;
	element_nums = length(meshes.tb);
	for n = 1 : element_nums
		vertices = meshes.pb(:, meshes.tb(:, n));
		uh_local = sol.sol(meshes.tb(:, n));
		[ev_w, ev_x, ev_y] = point_selection_2D(vertices, epord);
		epu = evaluate_us_2D(pde_config, [ev_x, ev_y], rs);
		uh = FE_function_2D(ev_x, ev_y, uh_local, vertices, ...
			pde_config.basis_config, rs);
		errs = [errs, dot(ev_w, (epu - uh) .^ 2)];
	end
	err = sqrt(sum(errs));
end