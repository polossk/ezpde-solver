function [err] = calc_hs_error( s, sol, pde_config )
	errs = [];
	eplen = pde_config.loss.ev_point_nums;
	meshes = sol.mesh_femesh;
	point_nums = length(meshes.pb);
	element_nums = length(meshes.p) - 1;
	for n = 1 : element_nums
		vertices = meshes.p(:, meshes.t(:, n));
		uh_local = sol.sol(meshes.tb(:, n));
		[ev_w, ev_x] = point_selection(vertices, eplen);
		epu = evaluate_us(pde_config, ev_x, s);
		uh = FE_function_1D(ev_x, uh_local, vertices, ...
			pde_config.basis_config, s);

		errs = [errs, dot(ev_w, (epu - uh) .^ 2)];
	end
	err = sqrt(sum(errs));
end